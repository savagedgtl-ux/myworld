import { onCall, onRequest, HttpsError } from 'firebase-functions/v2/https';
import { defineSecret } from 'firebase-functions/params';
import * as logger from 'firebase-functions/logger';
import { timingSafeEqual } from 'node:crypto';
import { audit, callableOpts, db, FieldValue, REGION, requireAuth, Timestamp } from '../lib/admin';
import { parseRevenueCatSubscriber, RcSubscriberResponse } from '../lib/entitlementLogic';
import { recomputeForPlanOwner } from '../lib/entitlements';

const RC_SECRET = defineSecret('REVENUECAT_SECRET_API_KEY');
const RC_WEBHOOK_AUTH = defineSecret('REVENUECAT_WEBHOOK_AUTH');

/**
 * Pulls the authoritative subscriber state from RevenueCat (which validates
 * receipts with Apple/Google) and stores it in subscriptions/{uid}.
 * The RevenueCat app_user_id is the Firebase uid (set in the app at login).
 */
async function syncFromRevenueCat(uid: string): Promise<void> {
  const res = await fetch(`https://api.revenuecat.com/v1/subscribers/${encodeURIComponent(uid)}`, {
    headers: { Authorization: `Bearer ${RC_SECRET.value()}`, 'Content-Type': 'application/json' },
  });
  if (!res.ok) {
    logger.error('revenuecat_fetch_failed', { status: res.status });
    throw new HttpsError('unavailable', 'billing_provider_unavailable');
  }
  const body = (await res.json()) as RcSubscriberResponse;
  const snap = parseRevenueCatSubscriber(body, Date.now());
  const ref = db.collection('subscriptions').doc(uid);
  const prev = await ref.get();

  if (!snap) {
    // Manually granted plans (tester / store-review accounts) have no store
    // purchase; only a real purchase replaces them, never its absence.
    if (prev.exists && prev.get('provider') !== 'manual') {
      await ref.set({ status: 'expired', updatedAt: FieldValue.serverTimestamp() }, { merge: true });
    }
  } else {
    const ts = (v: number | null) => (v == null ? null : Timestamp.fromMillis(v));
    await ref.set({
      ownerUid: uid,
      familyId: null,
      planId: snap.planId,
      platform: snap.platform,
      provider: 'revenuecat',
      providerPurchaseId: snap.providerPurchaseId,
      status: snap.status,
      currentPeriodStart: ts(snap.currentPeriodStart),
      currentPeriodEnd: ts(snap.currentPeriodEnd),
      gracePeriodEnd: ts(snap.gracePeriodEnd),
      cancelAtPeriodEnd: snap.cancelAtPeriodEnd,
      updatedAt: FieldValue.serverTimestamp(),
    });
  }
  const changed = !prev.exists || prev.get('planId') !== snap?.planId || prev.get('status') !== snap?.status;
  if (changed) await audit('subscription_synced', uid, { planId: snap?.planId ?? null, status: snap?.status ?? 'none' });

  // Family plan owner: attach the plan to the family they own.
  const fams = await db.collection('families').where('ownerUid', '==', uid).get();
  for (const f of fams.docs) {
    if (f.get('planOwnerUid') !== uid) await f.ref.update({ planOwnerUid: uid });
  }
  await recomputeForPlanOwner(uid);
}

/** Called by the app after a purchase / restore. Never trusts client-provided purchase data. */
export const syncSubscription = onCall({ ...callableOpts, secrets: [RC_SECRET] }, async (req) => {
  const uid = requireAuth(req);
  await syncFromRevenueCat(uid);
  const ent = await db.collection('entitlements').doc(uid).get();
  return { planId: ent.get('planId'), status: ent.get('status') };
});

/**
 * RevenueCat webhook (configure the Authorization header value in the
 * RevenueCat dashboard). Events only trigger a re-sync; state is always
 * re-fetched from the RevenueCat API, so a forged body cannot grant access.
 */
export const revenueCatWebhook = onRequest(
  { region: REGION, secrets: [RC_SECRET, RC_WEBHOOK_AUTH] },
  async (req, res) => {
    const expected = Buffer.from(`Bearer ${RC_WEBHOOK_AUTH.value()}`);
    const got = Buffer.from(String(req.headers.authorization ?? ''));
    if (req.method !== 'POST' || got.length !== expected.length || !timingSafeEqual(got, expected)) {
      res.status(401).send('unauthorized');
      return;
    }
    const event = req.body?.event;
    const ids = new Set<string>();
    for (const id of [event?.app_user_id, event?.original_app_user_id, ...(event?.transferred_to ?? []), ...(event?.transferred_from ?? [])]) {
      if (typeof id === 'string' && !id.startsWith('$RCAnonymousID')) ids.add(id);
    }
    try {
      for (const uid of ids) {
        const user = await db.collection('users').doc(uid).get();
        if (user.exists) await syncFromRevenueCat(uid);
      }
      res.status(200).send('ok');
    } catch (e) {
      logger.error('revenuecat_webhook_failed', { type: event?.type, error: String(e) });
      res.status(500).send('retry');
    }
  },
);
