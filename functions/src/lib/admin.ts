import { initializeApp, getApps } from 'firebase-admin/app';
import { getFirestore, FieldValue, Timestamp } from 'firebase-admin/firestore';
import { getStorage } from 'firebase-admin/storage';
import { getAuth } from 'firebase-admin/auth';
import { getMessaging } from 'firebase-admin/messaging';
import { HttpsError, CallableRequest } from 'firebase-functions/v2/https';
import { createHash } from 'node:crypto';

if (getApps().length === 0) initializeApp();

export const db = getFirestore();
export const bucket = () => getStorage().bucket();
export const auth = () => getAuth();
export const messaging = () => getMessaging();
export { FieldValue, Timestamp };

export const REGION = process.env.APP_REGION || 'europe-west1';

/** Common options for callables: App Check enforced in production. */
export const callableOpts = {
  region: REGION,
  // Enforced in production. Test projects (sideloaded APKs can't pass Play
  // Integrity) set ENFORCE_APP_CHECK=false in functions/.env.<projectId>.
  enforceAppCheck: process.env.FUNCTIONS_EMULATOR !== 'true' && process.env.ENFORCE_APP_CHECK !== 'false',
};

export function requireAuth(req: CallableRequest<unknown>): string {
  if (!req.auth?.uid) throw new HttpsError('unauthenticated', 'auth_required');
  return req.auth.uid;
}

/** Sensitive operations require a sign-in within the last `maxAgeSec` seconds. */
export function requireRecentAuth(req: CallableRequest<unknown>, maxAgeSec = 600): string {
  const uid = requireAuth(req);
  const authTime = Number(req.auth?.token?.auth_time ?? 0);
  if (!authTime || Date.now() / 1000 - authTime > maxAgeSec) {
    throw new HttpsError('failed-precondition', 'recent_login_required');
  }
  return uid;
}

export function sha256(input: string): string {
  return createHash('sha256').update(input).digest('hex');
}

/**
 * Audit log of critical actions. Never include document content, secrets or
 * unnecessary personal data — only ids and action names.
 */
export async function audit(action: string, actorUid: string, details: Record<string, string | number | boolean | null> = {}) {
  await db.collection('auditLogs').add({
    action,
    actorUid,
    details,
    createdAt: FieldValue.serverTimestamp(),
  });
}

export function monthKey(d = new Date()): string {
  return `${d.getUTCFullYear()}${String(d.getUTCMonth() + 1).padStart(2, '0')}`;
}

export function str(v: unknown, max: number, field: string, required = true): string {
  if (typeof v !== 'string' || (required && v.trim().length === 0) || v.length > max) {
    throw new HttpsError('invalid-argument', `invalid_${field}`);
  }
  return v.trim();
}
