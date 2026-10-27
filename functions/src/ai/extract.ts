import { onCall, HttpsError } from 'firebase-functions/v2/https';
import { onDocumentUpdated } from 'firebase-functions/v2/firestore';
import { extractText } from 'unpdf';
import { bucket, callableOpts, db, FieldValue, REGION, requireAuth, str } from '../lib/admin';
import { getEntitlement, requireAi } from '../lib/entitlements';
import { getReadableDocument } from '../lib/records';
import { MAX_AI_INPUT_CHARS, MAX_INDEX_CHARS, MAX_PAGES_FOR_AI } from '../plans';
import { indexDocument, markIndexPending } from './indexer';
import { MODELS, OPENAI_API_KEY, InputPart, SECURITY_PREAMBLE, structuredCall } from './client';
import { BusinessCardSchema, ExtractionSchema, ExtractionWithTranscriptSchema, validateBusinessCard, validateExtraction } from './schemas';
import { recordAiUsage, reserveAiRequest } from './usage';

export { SECURITY_PREAMBLE };

const EXTRACTION_SYSTEM = `You extract structured data from personal documents (receipts, invoices, warranties,
contracts, policies, IDs, manuals) for a personal organiser app.
Rules:
- Only report values that are clearly visible. If unsure, return null and list the field in fieldsNeedingReview.
- NEVER invent or infer a warranty duration or warranty expiry date. Return them only if explicitly printed.
- NEVER assume a default warranty (e.g. 2 years) or contract terms.
- Dates in ISO YYYY-MM-DD. If several dates could be the relevant one, list them in dateCandidates.
- currency: ISO 4217 code only if printed or unambiguous from the symbol; otherwise null.
- amount: the final total paid.
- title: short and neutral, in the document's language.
${SECURITY_PREAMBLE}`;

async function buildFileInput(storagePath: string, mimeType: string): Promise<{ parts: InputPart[]; pages: number; fullText: string | null }> {
  const [buf] = await bucket().file(storagePath).download();
  if (mimeType === 'application/pdf') {
    const { totalPages, text } = await extractText(new Uint8Array(buf), { mergePages: false });
    if (totalPages > MAX_PAGES_FOR_AI) throw new HttpsError('invalid-argument', 'too_many_pages_for_ai');
    const pages = text as string[];
    const clean = pages.join(' ').replace(/\s+/g, ' ').trim();
    if (clean.length > 80) {
      // Text layer present: send only text (cheaper, less data).
      const fullText = pages.map((p, i) => `--- ${i + 1} ---\n${p}`).join('\n\n');
      return { parts: [{ type: 'input_text', text: `<document>\n${clean.slice(0, MAX_AI_INPUT_CHARS)}\n</document>` }], pages: totalPages, fullText };
    }
    // Scanned PDF without text layer: send the file for OCR by the model.
    return {
      parts: [{ type: 'input_file', filename: 'document.pdf', file_data: `data:application/pdf;base64,${buf.toString('base64')}` }],
      pages: totalPages,
      fullText: null,
    };
  }
  if (mimeType === 'image/heic') throw new HttpsError('invalid-argument', 'heic_not_supported_for_ai');
  return { parts: [{ type: 'input_image', image_url: `data:${mimeType};base64,${buf.toString('base64')}`, detail: 'high' }], pages: 1, fullText: null };
}

async function runExtraction(uid: string, documentId: string) {
  const ent = await requireAi(uid);
  const doc = await getReadableDocument(uid, documentId);
  // Only the owner may trigger processing of their file.
  if (!doc || doc.get('ownerUid') !== uid) throw new HttpsError('permission-denied', 'no_access');
  if (doc.get('deletedAt') != null) throw new HttpsError('failed-precondition', 'document_in_trash');
  if (!['uploaded', 'ready', 'failed', 'needs_review'].includes(doc.get('processingStatus'))) {
    throw new HttpsError('failed-precondition', 'document_not_uploaded');
  }

  await reserveAiRequest(uid, ent);
  await doc.ref.update({ processingStatus: 'processing', updatedAt: FieldValue.serverTimestamp() });

  try {
    const { parts, pages, fullText } = await buildFileInput(doc.get('storagePath'), doc.get('mimeType'));
    // Scans have no text layer: ask for a verbatim transcript in the same call so
    // the full-text index never pays to read the page a second time.
    const transcribe = fullText == null && doc.get('isVault') !== true;
    const res = await structuredCall({
      model: MODELS.extraction,
      system: EXTRACTION_SYSTEM,
      user: [{ type: 'input_text', text: `Today is ${new Date().toISOString().slice(0, 10)}.` }, ...parts],
      schema: transcribe ? ExtractionWithTranscriptSchema : ExtractionSchema,
      schemaName: 'document_extraction',
      maxOutputTokens: transcribe ? Math.min(32_000, 4000 + 2500 * pages) : 4000,
    });
    const v = validateExtraction(res.data);
    await db.collection('documentExtractions').doc(documentId).set({
      documentId,
      ownerUid: uid,
      provider: 'openai',
      model: res.model,
      schemaVersion: 1,
      extractedFields: v.fields,
      confidence: v.confidence,
      needsReview: v.needsReview,
      fieldsNeedingReview: v.fieldsNeedingReview,
      warnings: v.warnings,
      createdAt: FieldValue.serverTimestamp(),
      updatedAt: FieldValue.serverTimestamp(),
    });
    await doc.ref.update({ processingStatus: 'needs_review', updatedAt: FieldValue.serverTimestamp() });
    await recordAiUsage({ uid, ent, task: 'extract_document', model: res.model, inputTokens: res.inputTokens, outputTokens: res.outputTokens, status: 'ok' });
    const text = fullText ?? (transcribe ? (res.data as any).transcript as string | null : null);
    if (text) {
      await indexDocument(documentId, { text: text.slice(0, MAX_INDEX_CHARS), pages, source: fullText ? 'pdf_text' : 'ocr', ocrInputTokens: 0, ocrOutputTokens: 0 });
    } else {
      await markIndexPending(documentId, uid);
    }
    return { status: 'needs_review' };
  } catch (e: any) {
    // AI failure never deletes or blocks the document — it stays available for manual editing.
    await doc.ref.update({ processingStatus: 'ready', updatedAt: FieldValue.serverTimestamp() });
    await recordAiUsage({ uid, ent, task: 'extract_document', model: MODELS.extraction, inputTokens: 0, outputTokens: 0, status: 'error', errorCode: e?.message ?? 'unknown' });
    throw e instanceof HttpsError ? e : new HttpsError('internal', 'ai_failed');
  }
}

/** Explicit, user-initiated extraction (e.g. "Analiziraj ponovo"). */
export const extractDocument = onCall({ ...callableOpts, secrets: [OPENAI_API_KEY], timeoutSeconds: 120, memory: '1GiB' }, async (req) => {
  const uid = requireAuth(req);
  return runExtraction(uid, str((req.data as any)?.documentId, 128, 'documentId'));
});

/**
 * Automatic extraction after upload, only for users whose plan includes AI and
 * who opted in on the document (client sets processingStatus=uploaded).
 */
export const autoExtractOnUpload = onDocumentUpdated(
  { document: 'documents/{docId}', region: REGION, secrets: [OPENAI_API_KEY], timeoutSeconds: 120, memory: '1GiB' },
  async (event) => {
    const before = event.data?.before.data();
    const after = event.data?.after.data();
    if (!before || !after) return;
    if (before.processingStatus === after.processingStatus || after.processingStatus !== 'uploaded') return;
    const ent = await getEntitlement(after.ownerUid);
    if (!ent.aiEnabled) {
      await event.data!.after.ref.update({ processingStatus: 'ready' });
      return;
    }
    try {
      await runExtraction(after.ownerUid, event.params.docId);
    } catch {
      // Already handled in runExtraction (status reset, usage recorded).
    }
  },
);

const BIZ_SYSTEM = `You read a photographed business card and return the contact details exactly as printed.
Do not guess missing data; return null or empty lists. ${SECURITY_PREAMBLE}`;

/** Returns suggested business-card fields; nothing is saved until the user confirms in the app. */
export const extractBusinessCard = onCall({ ...callableOpts, secrets: [OPENAI_API_KEY], timeoutSeconds: 60 }, async (req) => {
  const uid = requireAuth(req);
  const paths = ((req.data as any)?.photoPaths ?? []) as unknown[];
  if (!Array.isArray(paths) || paths.length === 0 || paths.length > 2) throw new HttpsError('invalid-argument', 'invalid_photoPaths');
  const prefix = `users/${uid}/photos/`;
  for (const p of paths) {
    if (typeof p !== 'string' || !p.startsWith(prefix) || p.includes('..')) throw new HttpsError('permission-denied', 'no_access');
  }
  const ent = await requireAi(uid);
  await reserveAiRequest(uid, ent);

  const parts: InputPart[] = [];
  for (const p of paths as string[]) {
    const f = bucket().file(p);
    const [meta] = await f.getMetadata();
    if (Number(meta.size) > 8 * 1024 * 1024) throw new HttpsError('invalid-argument', 'image_too_large');
    const [buf] = await f.download();
    parts.push({ type: 'input_image', image_url: `data:${meta.contentType};base64,${buf.toString('base64')}`, detail: 'high' });
  }
  try {
    const res = await structuredCall({
      model: MODELS.classify, system: BIZ_SYSTEM, user: parts,
      schema: BusinessCardSchema, schemaName: 'business_card', maxOutputTokens: 1500,
    });
    await recordAiUsage({ uid, ent, task: 'extract_business_card', model: res.model, inputTokens: res.inputTokens, outputTokens: res.outputTokens, status: 'ok' });
    return validateBusinessCard(res.data);
  } catch (e: any) {
    await recordAiUsage({ uid, ent, task: 'extract_business_card', model: MODELS.classify, inputTokens: 0, outputTokens: 0, status: 'error', errorCode: e?.message });
    throw e;
  }
});
