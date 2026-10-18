import { onObjectFinalized, onObjectDeleted } from 'firebase-functions/v2/storage';
import { onDocumentWritten } from 'firebase-functions/v2/firestore';
import { onSchedule } from 'firebase-functions/v2/scheduler';
import { onCall, HttpsError } from 'firebase-functions/v2/https';
import * as logger from 'firebase-functions/logger';
import { audit, bucket, callableOpts, db, FieldValue, REGION, requireAuth, str, Timestamp } from '../lib/admin';
import { isCompatible, sniffMime } from '../lib/fileSniff';
import { EXPORT_TTL_DAYS, MAX_UPLOAD_BYTES, TRASH_RETENTION_DAYS } from '../plans';

const DOC_PATH = /^users\/([^/]+)\/documents\/([^/]+)\/[^/]+$/;
const PHOTO_PATH = /^users\/([^/]+)\/photos\/([^/]+)\/[^/]+$/;

async function readHead(name: string): Promise<Uint8Array> {
  const chunks: Buffer[] = [];
  await new Promise<void>((resolve, reject) => {
    bucket().file(name).createReadStream({ start: 0, end: 15 })
      .on('data', (c: Buffer) => chunks.push(c)).on('end', resolve).on('error', reject);
  });
  return new Uint8Array(Buffer.concat(chunks));
}

/**
 * Usage pool of a user, or null when the account no longer exists (e.g. the
 * delete-account cleanup is firing these triggers) — never recreate its docs.
 */
async function usageKeyFor(uid: string): Promise<string | null> {
  const e = await db.collection('entitlements').doc(uid).get();
  return e.exists ? (e.get('usageKey') as string) : null;
}

/**
 * Validates every uploaded object by content (magic bytes) and updates the
 * storage usage counter. Invalid files are deleted and the record marked failed.
 */
export const onFileUploaded = onObjectFinalized({ region: REGION, memory: '256MiB' }, async (event) => {
  const name = event.data.name;
  const size = Number(event.data.size ?? 0);
  const docMatch = DOC_PATH.exec(name);
  const photoMatch = PHOTO_PATH.exec(name);
  if (!docMatch && !photoMatch) return;
  const ownerUid = (docMatch ?? photoMatch)![1];

  const sniffed = sniffMime(await readHead(name));
  const allowed = docMatch
    ? ['application/pdf', 'image/jpeg', 'image/png', 'image/heic']
    : ['image/jpeg', 'image/png', 'image/heic', 'image/webp'];
  const valid = sniffed != null && allowed.includes(sniffed)
    && isCompatible(event.data.contentType, sniffed) && size <= MAX_UPLOAD_BYTES;

  if (!valid) {
    logger.warn('rejected_upload', { ownerUid, reason: 'content_mismatch', declared: event.data.contentType, sniffed });
    await bucket().file(name).delete({ ignoreNotFound: true });
    if (docMatch) {
      await db.collection('documents').doc(docMatch[2]).set({ processingStatus: 'failed', updatedAt: FieldValue.serverTimestamp() }, { merge: true });
    }
    return;
  }

  const key = await usageKeyFor(ownerUid);
  if (key) await db.collection('usage').doc(key).set({ storageUsedBytes: FieldValue.increment(size) }, { merge: true });

  if (docMatch) {
    const ref = db.collection('documents').doc(docMatch[2]);
    const d = await ref.get();
    if (d.exists && d.get('storagePath') === name) {
      // Authoritative size and mime from the stored object.
      await ref.update({ fileSizeBytes: size, mimeType: sniffed, updatedAt: FieldValue.serverTimestamp() });
    }
  }
});

export const onFileDeleted = onObjectDeleted({ region: REGION }, async (event) => {
  const name = event.data.name;
  const m = DOC_PATH.exec(name) ?? PHOTO_PATH.exec(name);
  if (!m) return;
  const key = await usageKeyFor(m[1]);
  if (!key) return;
  await db.collection('usage').doc(key).set(
    { storageUsedBytes: FieldValue.increment(-Number(event.data.size ?? 0)) }, { merge: true });
});

/** Keeps activeDocumentCount accurate (trash does not count). */
export const onDocumentRecordWritten = onDocumentWritten({ document: 'documents/{docId}', region: REGION }, async (event) => {
  const before = event.data?.before;
  const after = event.data?.after;
  const wasActive = before?.exists && before.get('deletedAt') == null;
  const isActive = after?.exists && after.get('deletedAt') == null;
  if (wasActive === isActive) return;
  const owner = (after?.exists ? after : before)!.get('ownerUid');
  const key = await usageKeyFor(owner);
  if (!key) return;
  await db.collection('usage').doc(key).set(
    { activeDocumentCount: FieldValue.increment(isActive ? 1 : -1) }, { merge: true });
  if (!isActive && after?.exists) await audit('document_trashed', owner, { documentId: event.params.docId });
});

async function hardDeleteDocument(ref: FirebaseFirestore.DocumentReference) {
  const d = await ref.get();
  if (!d.exists) return;
  const path = d.get('storagePath');
  if (typeof path === 'string') await bucket().file(path).delete({ ignoreNotFound: true });
  await db.collection('documentExtractions').doc(ref.id).delete();
  await ref.delete();
}

/** Owner permanently deletes a document that is already in the trash. */
export const purgeDocument = onCall(callableOpts, async (req) => {
  const uid = requireAuth(req);
  const id = str((req.data as any)?.documentId, 128, 'documentId');
  const ref = db.collection('documents').doc(id);
  const d = await ref.get();
  if (!d.exists || d.get('ownerUid') !== uid) throw new HttpsError('permission-denied', 'not_owner');
  if (d.get('deletedAt') == null) throw new HttpsError('failed-precondition', 'move_to_trash_first');
  await hardDeleteDocument(ref);
  await audit('document_deleted', uid, { documentId: id });
  return { ok: true };
});

/** Daily housekeeping: purge expired trash, expired exports and stale invitations. */
export const dailyHousekeeping = onSchedule({ schedule: 'every day 03:30', timeZone: 'UTC', region: REGION }, async () => {
  const cutoff = Timestamp.fromMillis(Date.now() - TRASH_RETENTION_DAYS * 86400_000);
  const old = await db.collection('documents').where('deletedAt', '<', cutoff).limit(500).get();
  for (const d of old.docs) {
    await hardDeleteDocument(d.ref);
    await audit('document_purged', d.get('ownerUid'), { documentId: d.id });
  }

  const expCutoff = Timestamp.fromMillis(Date.now() - EXPORT_TTL_DAYS * 86400_000);
  const exports = await db.collection('exports').where('createdAt', '<', expCutoff).limit(200).get();
  for (const e of exports.docs) {
    if (e.get('storagePath')) await bucket().file(e.get('storagePath')).delete({ ignoreNotFound: true });
    await e.ref.delete();
  }

  const invites = await db.collection('familyInvitations').where('status', '==', 'pending')
    .where('expiresAt', '<', Timestamp.now()).limit(500).get();
  await Promise.all(invites.docs.map((i) => i.ref.update({ status: 'expired' })));
  logger.info('housekeeping_done', { purged: old.size, exports: exports.size, invites: invites.size });
});
