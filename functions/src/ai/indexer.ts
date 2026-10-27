import { onCall } from 'firebase-functions/v2/https';
import { onSchedule } from 'firebase-functions/v2/scheduler';
import * as logger from 'firebase-functions/logger';
import { extractText } from 'unpdf';
import { bucket, callableOpts, db, FieldValue, monthKey, REGION, requireAuth } from '../lib/admin';
import { getEntitlement } from '../lib/entitlements';
import { AI_INDEX_PAGES_PER_MONTH, EMBEDDING_DIMENSIONS, MAX_INDEX_CHARS, MAX_OCR_PAGES } from '../plans';
import { chunkText } from './chunking';
import { embed, InputPart, MODELS, OPENAI_API_KEY, SECURITY_PREAMBLE, textCall } from './client';
import { estimateCostUsd, recordAiUsage } from './usage';

/*
 * Full-text index used by aiAsk. Server-only collections (no client rules):
 *   documentChunks/{docId}_{n}  passage text + embedding, keyed by owner
 *   documentIndex/{docId}       per-document status: pending | indexing | ready | skipped | deferred | failed | too_large | unsupported
 *   aiIndexMeta/{uid}           when the user's documents were last scanned for missing entries
 */

const HAS_FILE = ['uploaded', 'ready', 'needs_review', 'processing'];
const MAX_ATTEMPTS = 3;

const OCR_SYSTEM = `Transcribe ALL text of this document exactly as written, in reading order and in the original
language. Include handwriting, stamps, tables (one row per line, cells separated by " | ") and form fields
("Label: value"). Do not summarise, translate, explain or add anything. If something is illegible write [nečitko].
${SECURITY_PREAMBLE}`;

export interface DocumentText { text: string; pages: number; source: 'pdf_text' | 'ocr'; ocrInputTokens: number; ocrOutputTokens: number }

const indexRef = (docId: string) => db.collection('documentIndex').doc(docId);

/** Reads the whole document: the PDF text layer when present, otherwise the model transcribes it. */
export async function readDocumentText(storagePath: string, mimeType: string): Promise<DocumentText> {
  const [buf] = await bucket().file(storagePath).download();
  let pages = 1;
  let part: InputPart;
  if (mimeType === 'application/pdf') {
    const { totalPages, text } = await extractText(new Uint8Array(buf), { mergePages: false });
    pages = totalPages;
    const joined = (text as string[]).map((p, i) => `--- ${i + 1} ---\n${p}`).join('\n\n');
    if ((text as string[]).join('').replace(/\s+/g, '').length > 80 * Math.max(1, Math.min(totalPages, 3))) {
      return { text: joined.slice(0, MAX_INDEX_CHARS), pages, source: 'pdf_text', ocrInputTokens: 0, ocrOutputTokens: 0 };
    }
    if (totalPages > MAX_OCR_PAGES) throw new IndexSkip('too_large');
    part = { type: 'input_file', filename: 'document.pdf', file_data: `data:application/pdf;base64,${buf.toString('base64')}` };
  } else if (mimeType === 'image/jpeg' || mimeType === 'image/png') {
    part = { type: 'input_image', image_url: `data:${mimeType};base64,${buf.toString('base64')}`, detail: 'high' };
  } else {
    throw new IndexSkip('unsupported');
  }
  const res = await textCall({
    model: MODELS.extraction,
    system: OCR_SYSTEM,
    user: [part],
    maxOutputTokens: Math.min(32_000, 2500 * pages),
  });
  return { text: res.text.slice(0, MAX_INDEX_CHARS), pages, source: 'ocr', ocrInputTokens: res.inputTokens, ocrOutputTokens: res.outputTokens };
}

class IndexSkip extends Error {
  constructor(readonly status: 'skipped' | 'deferred' | 'too_large' | 'unsupported') { super(status); }
}

async function deleteChunks(docId: string) {
  const old = await db.collection('documentChunks').where('documentId', '==', docId).select().get();
  for (let i = 0; i < old.docs.length; i += 400) {
    const b = db.batch();
    old.docs.slice(i, i + 400).forEach((d) => b.delete(d.ref));
    await b.commit();
  }
}

/** Removes a document's passages and index entry (hard delete, vault, account deletion). */
export async function removeFromIndex(docId: string) {
  await deleteChunks(docId);
  await indexRef(docId).delete();
}

async function globalBudgetLeft(): Promise<boolean> {
  const g = await db.collection('aiGlobal').doc(monthKey()).get();
  return Number(g.get('costUsd') ?? 0) < Number(process.env.AI_GLOBAL_MONTHLY_BUDGET_USD ?? 200);
}

/**
 * Indexes one document. `known` lets extraction pass text it already has, so a
 * scanned page is never read by the model twice.
 */
export async function indexDocument(docId: string, known?: DocumentText): Promise<string> {
  const doc = await db.collection('documents').doc(docId).get();
  if (!doc.exists) { await removeFromIndex(docId); return 'gone'; }
  const d = doc.data()!;
  const ownerUid = d.ownerUid as string;
  const ref = indexRef(docId);
  const base = { documentId: docId, ownerUid, updatedAt: FieldValue.serverTimestamp() };
  try {
    if (d.deletedAt != null || d.isVault === true) { await removeFromIndex(docId); return 'removed'; }
    if (!HAS_FILE.includes(d.processingStatus) || typeof d.storagePath !== 'string') throw new IndexSkip('skipped');
    const ent = await getEntitlement(ownerUid);
    if (!ent.aiEnabled) throw new IndexSkip('skipped');

    const mk = monthKey();
    const budgetRef = db.collection('aiBudgets').doc(`${ownerUid}_${mk}`);
    if (!known) {
      const used = Number((await budgetRef.get()).get('indexPages') ?? 0);
      if (used >= AI_INDEX_PAGES_PER_MONTH || !(await globalBudgetLeft())) throw new IndexSkip('deferred');
    }

    const content = known ?? await readDocumentText(d.storagePath, d.mimeType);
    const header = [d.title, d.vendor].filter(Boolean).join(' — ');
    const chunks = chunkText(content.text);
    // The title goes into every embedded passage so "the Doronjski report" finds all of its pages.
    const { vectors, tokens } = chunks.length ? await embed(chunks.map((c) => `${header}\n${c}`), EMBEDDING_DIMENSIONS) : { vectors: [], tokens: 0 };

    await deleteChunks(docId);
    for (let i = 0; i < chunks.length; i += 200) {
      const b = db.batch();
      chunks.slice(i, i + 200).forEach((text, j) => {
        const n = i + j;
        b.set(db.collection('documentChunks').doc(`${docId}_${n}`), {
          documentId: docId, ownerUid, chunkIndex: n, text,
          embedding: FieldValue.vector(vectors[n]), createdAt: FieldValue.serverTimestamp(),
        });
      });
      await b.commit();
    }
    await ref.set({ ...base, status: 'ready', chunks: chunks.length, pages: content.pages, source: content.source, chars: content.text.length, attempts: 0, error: null });

    if (!known) await budgetRef.set({ uid: ownerUid, month: mk, indexPages: FieldValue.increment(content.pages) }, { merge: true });
    // OCR done here (not by extraction) is billed at the extraction model; embeddings always.
    const ocrHere = !known && content.source === 'ocr';
    await recordAiUsage({
      uid: ownerUid, ent, task: 'index_document',
      model: ocrHere ? MODELS.extraction : MODELS.embedding,
      inputTokens: ocrHere ? content.ocrInputTokens : tokens,
      outputTokens: ocrHere ? content.ocrOutputTokens : 0,
      extraCostUsd: ocrHere ? estimateCostUsd(MODELS.embedding, tokens, 0) : 0,
      status: 'ok', chargeUser: false,
    });
    return 'ready';
  } catch (e: any) {
    if (e instanceof IndexSkip) {
      await ref.set({ ...base, status: e.status, month: monthKey() }, { merge: true });
      return e.status;
    }
    const prev = await ref.get();
    const attempts = Number(prev.get('attempts') ?? 0) + 1;
    await ref.set({ ...base, status: attempts >= MAX_ATTEMPTS ? 'failed' : 'pending', attempts, error: String(e?.message ?? 'unknown').slice(0, 200) }, { merge: true });
    logger.warn('index_failed', { docId, attempts, error: e?.message });
    return 'error';
  }
}

export async function markIndexPending(docId: string, ownerUid: string) {
  await indexRef(docId).set({ documentId: docId, ownerUid, status: 'pending', attempts: 0, updatedAt: FieldValue.serverTimestamp() }, { merge: true });
}

async function runPool<T>(items: T[], concurrency: number, fn: (t: T) => Promise<unknown>) {
  let i = 0;
  await Promise.all(Array.from({ length: Math.min(concurrency, items.length) }, async () => {
    while (i < items.length) await fn(items[i++]);
  }));
}

/** Works through the backlog (new users, plan upgrades, retries) a few documents at a time. */
export const processAiIndexQueue = onSchedule(
  { schedule: 'every 5 minutes', region: REGION, secrets: [OPENAI_API_KEY], timeoutSeconds: 540, memory: '1GiB', maxInstances: 1 },
  async () => {
    const started = Date.now();
    const pending = await db.collection('documentIndex').where('status', '==', 'pending').limit(40).get();
    let done = 0;
    await runPool(pending.docs, 4, async (d) => {
      // Stop picking new work well before the next run starts.
      if (Date.now() - started > 240_000) return;
      await d.ref.update({ status: 'indexing', updatedAt: FieldValue.serverTimestamp() });
      await indexDocument(d.id);
      done++;
    });
    if (pending.size) logger.info('ai_index_queue', { picked: pending.size, done });
  },
);

/**
 * Called when the AI screen opens: queues every document of the user that is
 * not indexed yet, cleans entries of trashed/vault documents and reports progress.
 */
export const prepareAiIndex = onCall({ ...callableOpts, timeoutSeconds: 120 }, async (req) => {
  const uid = requireAuth(req);
  const ent = await getEntitlement(uid);
  if (!ent.aiEnabled) return { enabled: false, total: 0, ready: 0, pending: 0 };

  const metaRef = db.collection('aiIndexMeta').doc(uid);
  const meta = await metaRef.get();
  const lastScan = Number(meta.get('scannedAt')?.toMillis?.() ?? 0);
  const mk = monthKey();

  const entries = await db.collection('documentIndex').where('ownerUid', '==', uid).get();
  const byDoc = new Map(entries.docs.map((e) => [e.id, e]));

  if (Date.now() - lastScan > 10 * 60_000) {
    const docs = await db.collection('documents').where('ownerUid', '==', uid).get();
    const writes: Promise<unknown>[] = [];
    for (const d of docs.docs) {
      const data = d.data();
      const e = byDoc.get(d.id);
      const indexable = data.deletedAt == null && data.isVault !== true && HAS_FILE.includes(data.processingStatus);
      if (!indexable) {
        if (e) { writes.push(removeFromIndex(d.id)); byDoc.delete(d.id); }
        continue;
      }
      const st = e?.get('status');
      const stuck = st === 'indexing' && Date.now() - Number(e!.get('updatedAt')?.toMillis?.() ?? 0) > 15 * 60_000;
      const retry = !e || st === 'skipped' || stuck || (st === 'deferred' && e.get('month') !== mk);
      if (retry) writes.push(markIndexPending(d.id, uid));
    }
    // Entries whose document no longer exists.
    const existing = new Set(docs.docs.map((d) => d.id));
    for (const id of byDoc.keys()) if (!existing.has(id)) writes.push(removeFromIndex(id));
    await Promise.all(writes);
    await metaRef.set({ uid, scannedAt: FieldValue.serverTimestamp() }, { merge: true });
  }

  const fresh = await db.collection('documentIndex').where('ownerUid', '==', uid).get();
  const count = (s: string) => fresh.docs.filter((e) => e.get('status') === s).length;
  return { enabled: true, total: fresh.size, ready: count('ready'), pending: count('pending') + count('indexing'), deferred: count('deferred') };
});
