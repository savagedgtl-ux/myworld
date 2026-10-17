/**
 * Server-side mirror of the Firestore rules privacy model. The Admin SDK
 * bypasses security rules, so every server feature (AI, export, search) MUST
 * filter through these functions before touching record content.
 */

export type PrivacyLevel = 'private' | 'shared' | 'family';

export interface PrivacyFields {
  ownerUid: string;
  familyId?: string | null;
  privacyLevel?: PrivacyLevel;
  sharedWith?: string[];
  deletedAt?: unknown;
}

export function canRead(record: PrivacyFields, uid: string, activeFamilyIds: ReadonlySet<string>): boolean {
  if (record.ownerUid === uid) return true;
  const fid = record.familyId;
  if (!fid || !activeFamilyIds.has(fid)) return false;
  if (record.privacyLevel === 'family') return true;
  if (record.privacyLevel === 'shared') return Array.isArray(record.sharedWith) && record.sharedWith.includes(uid);
  return false;
}

export function isActiveRecord(record: { deletedAt?: unknown }): boolean {
  return record.deletedAt == null;
}
