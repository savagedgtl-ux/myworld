import { onCall, HttpsError } from 'firebase-functions/v2/https';
import { defineSecret } from 'firebase-functions/params';
import * as logger from 'firebase-functions/logger';
import { ZipArchive } from 'archiver';
import { audit, auth, bucket, callableOpts, db, FieldValue, requireAuth, requireRecentAuth, sha256 } from '../lib/admin';
import { getEntitlement, recomputeUsage } from '../lib/entitlements';
import { RECORD_COLLECTIONS } from '../lib/records';
import { dissolve } from '../family/family';

const RC_SECRET = defineSecret('REVENUECAT_SECRET_API_KEY');

function serialize(v: any): any {
  if (v == null) return v;
  if (typeof v.toDate === 'function') return v.toDate().toISOString();
  if (Array.isArray(v)) return v.map(serialize);
  if (typeof v === 'object') return Object.fromEntries(Object.entries(v).map(([k, x]) => [k, serialize(x)]));
  return v;
}

function csv(rows: Record<string, any>[], cols: string[]): string {
  const esc = (x: any) => {
    const s = x == null ? '' : String(serialize(x));
    return /[",\n;]/.test(s) ? `"${s.replace(/"/g, '""')}"` : s;
  };
  return [cols.join(','), ...rows.map((r) => cols.map((c) => esc(r[c])).join(','))].join('\n');
}

/**
 * Exports everything the user OWNS (metadata JSON, CSV summaries for advanced
 * plans, and original files) into a private ZIP in Storage. Family members'
 * records are not included — each person exports their own data.
 */
export const exportUserData = onCall({ ...callableOpts, timeoutSeconds: 540, memory: '1GiB' }, async (req) => {
  const uid = requireAuth(req);
  const ent = await getEntitlement(uid);
  const exportRef = db.collection('exports').doc();
  const path = `exports/${uid}/${exportRef.id}.zip`;
  await exportRef.set({ uid, status: 'running', storagePath: path, createdAt: FieldValue.serverTimestamp() });

  try {
    return await writeExport(uid, ent.advancedExport, exportRef, path);
  } catch (e) {
    logger.error('export_failed', { error: String(e) });
    await exportRef.update({ status: 'failed', failedAt: FieldValue.serverTimestamp() });
    throw new HttpsError('internal', 'export_failed');
  }
});

async function writeExport(uid: string, advancedExport: boolean, exportRef: FirebaseFirestore.DocumentReference, path: string) {
  const out = bucket().file(path).createWriteStream({ contentType: 'application/zip', resumable: false });
  const zip = new ZipArchive({ zlib: { level: 6 } });
  const done = new Promise<void>((resolve, reject) => { out.on('finish', resolve).on('error', reject); zip.on('error', reject); });
  zip.pipe(out);

  const data: Record<string, any[]> = {};
  for (const col of RECORD_COLLECTIONS) {
    const s = await db.collection(col).where('ownerUid', '==', uid).get();
    data[col] = s.docs.map((d) => ({ id: d.id, ...serialize(d.data()) }));
  }
  const ex = await db.collection('documentExtractions').where('ownerUid', '==', uid).get();
  data.documentExtractions = ex.docs.map((d) => ({ id: d.id, ...serialize(d.data()) }));
  const cats = await db.collection('categories').where('ownerUid', '==', uid).get();
  data.categories = cats.docs.map((d) => ({ id: d.id, ...serialize(d.data()) }));
  const profile = await db.collection('users').doc(uid).get();

  zip.append(JSON.stringify({ exportedAt: new Date().toISOString(), profile: serialize(profile.data()), ...data }, null, 2), { name: 'myworldplus-data.json' });
  zip.append(
    'MyWorld+ izvoz podataka / data export\n\nmyworldplus-data.json — svi metapodaci, veze, podsetnici.\nfiles/ — originalni dokumenti i fotografije.\n',
    { name: 'README.txt' },
  );
  if (advancedExport) {
    zip.append(csv(data.documents, ['id', 'title', 'categoryId', 'vendor', 'documentDate', 'purchaseDate', 'amount', 'currency', 'warrantyExpiryDate', 'expiryDate', 'tags', 'privacyLevel']), { name: 'documents.csv' });
    zip.append(csv(data.vehicleRecords, ['id', 'vehicleId', 'recordType', 'date', 'mileage', 'amount', 'currency', 'vendor', 'description', 'nextDueDate']), { name: 'vehicle-records.csv' });
    zip.append(csv(data.assets, ['id', 'name', 'area', 'category', 'brand', 'model', 'serialNumber', 'purchaseDate', 'purchasePrice', 'currency', 'warrantyExpiryDate']), { name: 'assets.csv' });
  }

  const [files] = await bucket().getFiles({ prefix: `users/${uid}/` });
  for (const f of files) {
    zip.append(f.createReadStream(), { name: `files/${f.name.slice(`users/${uid}/`.length)}` });
  }
  await zip.finalize();
  await done;
  await exportRef.update({ status: 'ready', fileCount: files.length, readyAt: FieldValue.serverTimestamp() });
  await audit('data_exported', uid, { exportId: exportRef.id });
  return { exportId: exportRef.id, storagePath: path };
}

async function deleteQuery(q: FirebaseFirestore.Query) {
  for (;;) {
    const s = await q.limit(400).get();
    if (s.empty) return;
    const b = db.batch();
    s.docs.forEach((d) => b.delete(d.ref));
    await b.commit();
  }
}

/**
 * Real server-side account deletion. Requires a recent sign-in. A family owner
 * with other active members must remove them first (no silent data loss for
 * other people). Store subscriptions cannot be cancelled by us — the app shows
 * the user how to cancel in the App Store / Google Play.
 */
export const deleteAccount = onCall({ ...callableOpts, timeoutSeconds: 540, secrets: [RC_SECRET] }, async (req) => {
  const uid = requireRecentAuth(req);
  const user = await db.collection('users').doc(uid).get();
  const fid: string | null = user.get('activeFamilyId') ?? null;

  if (fid) {
    const fam = await db.collection('families').doc(fid).get();
    if (fam.get('ownerUid') === uid) {
      await dissolve(fid, uid); // throws family_has_members if others remain
    } else {
      const m = fam.ref.collection('members').doc(uid);
      await m.update({ status: 'left', leftAt: FieldValue.serverTimestamp() });
      await fam.ref.update({ memberCount: FieldValue.increment(-1) });
    }
  }
  await db.collection('users').doc(uid).set({ accountStatus: 'deleting' }, { merge: true });
  // A family member's usage is pooled under the family; recount it at the end.
  const pooledKey = (await db.collection('entitlements').doc(uid).get()).get('usageKey') as string | undefined;
  // Remove server docs first so cleanup-triggered usage updates are no-ops.
  await db.collection('entitlements').doc(uid).delete();
  await db.collection('usage').doc(uid).delete();

  // Remove this user from anything shared with them.
  for (const col of RECORD_COLLECTIONS) {
    const shared = await db.collection(col).where('sharedWith', 'array-contains', uid).get();
    await Promise.all(shared.docs.map((d) => d.ref.update({ sharedWith: FieldValue.arrayRemove(uid) })));
    await deleteQuery(db.collection(col).where('ownerUid', '==', uid));
  }
  await deleteQuery(db.collection('documentExtractions').where('ownerUid', '==', uid));
  await deleteQuery(db.collection('documentChunks').where('ownerUid', '==', uid));
  await deleteQuery(db.collection('documentIndex').where('ownerUid', '==', uid));
  await db.collection('aiIndexMeta').doc(uid).delete();
  await deleteQuery(db.collection('categories').where('ownerUid', '==', uid));
  await deleteQuery(db.collection('exports').where('uid', '==', uid));
  await deleteQuery(db.collection('aiBudgets').where('uid', '==', uid));
  await deleteQuery(db.collection('familyInvitations').where('invitedBy', '==', uid));
  await deleteQuery(db.collection('users').doc(uid).collection('devices'));

  // AI usage is kept only as anonymised cost accounting.
  const usage = await db.collection('aiUsage').where('uid', '==', uid).get();
  const anon = `deleted_${sha256(uid).slice(0, 16)}`;
  await Promise.all(usage.docs.map((d) => d.ref.update({ uid: anon })));
  const logs = await db.collection('auditLogs').where('actorUid', '==', uid).get();
  await Promise.all(logs.docs.map((d) => d.ref.update({ actorUid: anon })));

  await bucket().deleteFiles({ prefix: `users/${uid}/` });
  await bucket().deleteFiles({ prefix: `exports/${uid}/` });

  // Subscription record: anonymised (may be needed for refunds/accounting).
  const sub = db.collection('subscriptions').doc(uid);
  const subSnap = await sub.get();
  if (subSnap.exists) {
    await db.collection('subscriptionsArchive').doc(anon).set({ ...subSnap.data(), ownerUid: anon, archivedAt: FieldValue.serverTimestamp() });
    await sub.delete();
  }
  try {
    if (RC_SECRET.value()) {
      await fetch(`https://api.revenuecat.com/v1/subscribers/${encodeURIComponent(uid)}`, {
        method: 'DELETE', headers: { Authorization: `Bearer ${RC_SECRET.value()}` },
      });
    }
  } catch (e) {
    logger.warn('revenuecat_delete_failed', { error: String(e) });
  }

  await db.collection('users').doc(uid).delete();
  if (pooledKey && pooledKey !== uid) await recomputeUsage(pooledKey);
  await audit('account_deleted', anon, {});
  await auth().deleteUser(uid).catch((e) => {
    if (e?.code !== 'auth/user-not-found') throw new HttpsError('internal', 'auth_delete_failed');
  });
  return { ok: true };
});
