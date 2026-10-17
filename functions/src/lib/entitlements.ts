import { db, bucket, FieldValue, audit } from './admin';
import { computeEntitlement, Entitlement, SubscriptionSnapshot } from './entitlementLogic';
import { isPlanId } from '../plans';
import { HttpsError } from 'firebase-functions/v2/https';

function toSnapshot(data: FirebaseFirestore.DocumentData | undefined): SubscriptionSnapshot | null {
  if (!data || !isPlanId(data.planId)) return null;
  const t = (v: any) => (v?.toMillis ? v.toMillis() : typeof v === 'number' ? v : null);
  return {
    planId: data.planId,
    status: data.status,
    currentPeriodStart: t(data.currentPeriodStart),
    currentPeriodEnd: t(data.currentPeriodEnd),
    gracePeriodEnd: t(data.gracePeriodEnd),
    cancelAtPeriodEnd: Boolean(data.cancelAtPeriodEnd),
    platform: data.platform ?? 'unknown',
    providerPurchaseId: data.providerPurchaseId ?? null,
  };
}

/** One subscription doc per purchasing user: subscriptions/{uid}. */
export async function getSubscription(uid: string): Promise<SubscriptionSnapshot | null> {
  const s = await db.collection('subscriptions').doc(uid).get();
  return s.exists ? toSnapshot(s.data()) : null;
}

export async function getActiveMembership(uid: string): Promise<{ familyId: string; role: 'owner' | 'admin' | 'member' } | null> {
  const user = await db.collection('users').doc(uid).get();
  const fid = user.get('activeFamilyId');
  if (!fid) return null;
  const m = await db.collection('families').doc(fid).collection('members').doc(uid).get();
  if (!m.exists || m.get('status') !== 'active') return null;
  return { familyId: fid, role: m.get('role') };
}

/** Recomputes and stores entitlements/{uid}. Server is the only writer. */
export async function recomputeEntitlement(uid: string): Promise<Entitlement> {
  const [own, membership] = await Promise.all([getSubscription(uid), getActiveMembership(uid)]);
  let family: Parameters<typeof computeEntitlement>[0]['family'] = null;
  if (membership) {
    const fam = await db.collection('families').doc(membership.familyId).get();
    const planOwner = fam.get('planOwnerUid') as string | undefined;
    const planSubscription = planOwner ? await getSubscription(planOwner) : null;
    family = { ...membership, planSubscription };
  }
  const ent = computeEntitlement({ uid, now: Date.now(), ownSubscription: own, family });
  const ref = db.collection('entitlements').doc(uid);
  const prev = await ref.get();
  await ref.set({ ...ent, updatedAt: FieldValue.serverTimestamp() });
  await db.collection('usage').doc(ent.usageKey).set(
    { activeDocumentCount: FieldValue.increment(0), storageUsedBytes: FieldValue.increment(0) },
    { merge: true },
  );
  if (prev.exists && prev.get('planId') !== ent.planId) {
    await audit('entitlement_changed', uid, { from: prev.get('planId'), to: ent.planId });
  }
  if (prev.exists && prev.get('usageKey') !== ent.usageKey) {
    await Promise.all([recomputeUsage(prev.get('usageKey')), recomputeUsage(ent.usageKey)]);
  }
  return ent;
}

/** Recompute a plan owner and every member of the family they pay for. */
export async function recomputeForPlanOwner(uid: string) {
  await recomputeEntitlement(uid);
  const fams = await db.collection('families').where('planOwnerUid', '==', uid).get();
  for (const f of fams.docs) {
    const members = await f.ref.collection('members').where('status', '==', 'active').get();
    await Promise.all(members.docs.map((m) => recomputeEntitlement(m.id)));
  }
}

export async function getEntitlement(uid: string): Promise<Entitlement> {
  const s = await db.collection('entitlements').doc(uid).get();
  if (!s.exists) return recomputeEntitlement(uid);
  return s.data() as Entitlement;
}

export async function requireAi(uid: string): Promise<Entitlement> {
  // Always recompute from the source of truth so a just-expired subscription
  // cannot keep using AI because of a stale cache.
  const ent = await recomputeEntitlement(uid);
  if (!ent.aiEnabled) throw new HttpsError('permission-denied', 'ai_not_in_plan');
  return ent;
}

/** Full usage recompute for a pool (uid or familyId). Used after membership/plan changes. */
export async function recomputeUsage(key: string) {
  let uids: string[] = [key];
  const fam = await db.collection('families').doc(key).get();
  if (fam.exists) {
    const members = await fam.ref.collection('members').where('status', '==', 'active').get();
    const pooled: string[] = [];
    for (const m of members.docs) {
      const e = await db.collection('entitlements').doc(m.id).get();
      if (e.get('usageKey') === key) pooled.push(m.id);
    }
    uids = pooled;
  }
  let count = 0;
  let bytes = 0;
  for (const u of uids) {
    const docs = await db.collection('documents').where('ownerUid', '==', u).select('fileSizeBytes', 'deletedAt').get();
    for (const d of docs.docs) {
      bytes += Number(d.get('fileSizeBytes') ?? 0);
      if (d.get('deletedAt') == null) count += 1;
    }
    const photosBytes = await sumPrefixBytes(`users/${u}/photos/`);
    bytes += photosBytes;
  }
  await db.collection('usage').doc(key).set({
    activeDocumentCount: count,
    storageUsedBytes: bytes,
    recomputedAt: FieldValue.serverTimestamp(),
  }, { merge: true });
}

async function sumPrefixBytes(prefix: string): Promise<number> {
  const [files] = await bucket().getFiles({ prefix });
  return files.reduce((a, f) => a + Number(f.metadata.size ?? 0), 0);
}
