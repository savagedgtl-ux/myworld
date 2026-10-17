import * as functionsV1 from 'firebase-functions/v1';
import { onCall } from 'firebase-functions/v2/https';
import { callableOpts, db, FieldValue, requireAuth, REGION } from '../lib/admin';
import { recomputeEntitlement } from '../lib/entitlements';

async function ensureAccount(uid: string, email: string | null) {
  const userRef = db.collection('users').doc(uid);
  const snap = await userRef.get();
  if (!snap.exists) {
    // Minimal profile; the client completes displayName/language in onboarding.
    await userRef.set({
      uid,
      email: email ?? null,
      createdAt: FieldValue.serverTimestamp(),
      updatedAt: FieldValue.serverTimestamp(),
      onboardingCompleted: false,
      accountStatus: 'active',
      activeFamilyId: null,
      notificationPreview: 'generic',
    });
  } else if (snap.get('accountStatus') == null) {
    await userRef.set({ accountStatus: 'active', activeFamilyId: snap.get('activeFamilyId') ?? null }, { merge: true });
  }
  return recomputeEntitlement(uid);
}

/** Runs when a Firebase Auth user is created. */
export const onAuthUserCreated = functionsV1.region(REGION).auth.user().onCreate(async (user) => {
  await ensureAccount(user.uid, user.email ?? null);
});

/**
 * Idempotent bootstrap the app calls after every sign-in. Covers the race where
 * the client is faster than the auth trigger, and repairs missing server docs.
 */
export const bootstrapAccount = onCall(callableOpts, async (req) => {
  const uid = requireAuth(req);
  const ent = await ensureAccount(uid, (req.auth?.token?.email as string) ?? null);
  return { planId: ent.planId };
});
