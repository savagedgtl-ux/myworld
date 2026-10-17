import { db } from './admin';
import { canRead, isActiveRecord } from './access';
import { getActiveMembership } from './entitlements';

export const RECORD_COLLECTIONS = [
  'documents', 'assets', 'vehicles', 'vehicleRecords', 'reminders', 'walletCards', 'businessCards',
] as const;
export type RecordCollection = typeof RECORD_COLLECTIONS[number];

export interface LoadedRecord {
  collection: RecordCollection;
  id: string;
  data: FirebaseFirestore.DocumentData;
}

/**
 * Loads every record the user is authorised to read, using the same three
 * query shapes the client uses (own / family-level / explicitly shared), then
 * re-checks each with canRead(). Deleted (trashed) records are excluded.
 */
export async function loadAccessibleRecords(uid: string, collections: readonly RecordCollection[] = RECORD_COLLECTIONS): Promise<LoadedRecord[]> {
  const membership = await getActiveMembership(uid);
  const families = new Set<string>(membership ? [membership.familyId] : []);
  const out = new Map<string, LoadedRecord>();

  for (const col of collections) {
    const queries: FirebaseFirestore.Query[] = [db.collection(col).where('ownerUid', '==', uid)];
    if (membership) {
      queries.push(db.collection(col).where('familyId', '==', membership.familyId).where('privacyLevel', '==', 'family'));
      queries.push(db.collection(col).where('familyId', '==', membership.familyId).where('privacyLevel', '==', 'shared')
        .where('sharedWith', 'array-contains', uid));
    }
    const snaps = await Promise.all(queries.map((q) => q.get()));
    for (const s of snaps) {
      for (const d of s.docs) {
        const data = d.data();
        if (!isActiveRecord(data) || !canRead(data as any, uid, families)) continue;
        out.set(`${col}/${d.id}`, { collection: col, id: d.id, data });
      }
    }
  }
  return [...out.values()];
}

export async function getReadableDocument(uid: string, documentId: string) {
  const d = await db.collection('documents').doc(documentId).get();
  if (!d.exists) return null;
  const membership = await getActiveMembership(uid);
  const families = new Set<string>(membership ? [membership.familyId] : []);
  return canRead(d.data() as any, uid, families) ? d : null;
}
