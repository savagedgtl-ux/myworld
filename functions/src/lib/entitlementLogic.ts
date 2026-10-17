import { PLANS, PlanId, STORE_ENTITLEMENT_TO_PLAN } from '../plans';

/** Pure logic — no Firebase imports, fully unit-testable. */

export type SubscriptionStatus =
  | 'active' | 'in_grace_period' | 'billing_issue' | 'cancelled' | 'expired' | 'refunded' | 'paused';

export interface SubscriptionSnapshot {
  planId: PlanId;
  status: SubscriptionStatus;
  currentPeriodStart: number | null; // epoch ms
  currentPeriodEnd: number | null;
  gracePeriodEnd: number | null;
  cancelAtPeriodEnd: boolean;
  platform: 'ios' | 'android' | 'web' | 'unknown';
  providerPurchaseId: string | null;
}

/** Whether a subscription currently grants its plan's features. */
export function isEntitled(sub: SubscriptionSnapshot | null, now: number): boolean {
  if (!sub) return false;
  if (sub.status === 'expired' || sub.status === 'refunded' || sub.status === 'paused') return false;
  if (sub.status === 'in_grace_period' || sub.status === 'billing_issue') {
    const end = sub.gracePeriodEnd ?? sub.currentPeriodEnd;
    return end != null && end > now;
  }
  // active or cancelled (cancelled keeps access until the period ends)
  return sub.currentPeriodEnd == null ? sub.status === 'active' : sub.currentPeriodEnd > now;
}

export interface EntitlementInput {
  uid: string;
  now: number;
  ownSubscription: SubscriptionSnapshot | null;
  /** Active family membership of this user, with the family plan owner's subscription. */
  family: { familyId: string; role: 'owner' | 'admin' | 'member'; planSubscription: SubscriptionSnapshot | null } | null;
}

export interface Entitlement {
  planId: PlanId;
  /** Plan that comes from the user's own purchase (may be lower than planId). */
  ownPlanId: PlanId;
  status: SubscriptionStatus | 'none';
  source: 'none' | 'own' | 'family';
  currentPeriodEnd: number | null;
  cancelAtPeriodEnd: boolean;
  aiEnabled: boolean;
  adsEnabled: boolean;
  storageLimitBytes: number;
  maxDocuments: number;
  maxFamilyMembers: number;
  maxVehicles: number;
  advancedExport: boolean;
  advancedFilters: boolean;
  aiMonthlyRequests: number;
  aiMonthlyBudgetUsd: number;
  canCreateFamily: boolean;
  canInviteMembers: boolean;
  familyId: string | null;
  usageKey: string;
}

export function computeEntitlement(input: EntitlementInput): Entitlement {
  const { uid, now, ownSubscription, family } = input;
  const ownActive = isEntitled(ownSubscription, now);
  const ownPlan = ownActive ? PLANS[ownSubscription!.planId] : PLANS.individual_base;

  const familyActive = family != null && isEntitled(family.planSubscription, now)
    && PLANS[family.planSubscription!.planId].isFamily;
  const famPlan = familyActive ? PLANS[family!.planSubscription!.planId] : null;

  // The effective plan is the higher-ranked one; AI and ad-free are unions.
  const effective = famPlan && famPlan.rank >= ownPlan.rank ? famPlan : ownPlan;
  const useFamilyPool = famPlan != null;
  const pool = useFamilyPool ? famPlan! : ownPlan;

  const sourceSub = effective === famPlan ? family!.planSubscription : ownActive ? ownSubscription : null;

  return {
    planId: effective.id,
    ownPlanId: ownPlan.id,
    status: sourceSub ? sourceSub.status : 'none',
    source: effective === famPlan ? 'family' : ownActive ? 'own' : 'none',
    currentPeriodEnd: sourceSub?.currentPeriodEnd ?? null,
    cancelAtPeriodEnd: sourceSub?.cancelAtPeriodEnd ?? false,
    aiEnabled: ownPlan.aiEnabled || (famPlan?.aiEnabled ?? false),
    adsEnabled: ownPlan.adsEnabled && (famPlan == null),
    // Limits apply to the pool counted under usageKey (family pool or personal).
    storageLimitBytes: pool.storageLimitBytes,
    maxDocuments: pool.maxDocuments,
    maxFamilyMembers: famPlan?.maxFamilyMembers ?? (ownPlan.isFamily ? ownPlan.maxFamilyMembers : 1),
    maxVehicles: Math.max(ownPlan.maxVehicles, famPlan?.maxVehicles ?? 0),
    advancedExport: ownPlan.advancedExport || (famPlan?.advancedExport ?? false),
    advancedFilters: ownPlan.advancedFilters || (famPlan?.advancedFilters ?? false),
    aiMonthlyRequests: Math.max(ownPlan.aiMonthlyRequests, famPlan?.aiMonthlyRequests ?? 0),
    aiMonthlyBudgetUsd: Math.max(ownPlan.aiMonthlyBudgetUsd, famPlan?.aiMonthlyBudgetUsd ?? 0),
    canCreateFamily: ownPlan.isFamily && family == null,
    canInviteMembers: famPlan != null && family != null && (family.role === 'owner' || family.role === 'admin'),
    familyId: family?.familyId ?? null,
    usageKey: useFamilyPool ? family!.familyId : uid,
  };
}

// ---------------- RevenueCat parsing ----------------

interface RcEntitlement {
  expires_date: string | null;
  grace_period_expires_date?: string | null;
  product_identifier: string;
  purchase_date: string;
}
interface RcSubscription {
  expires_date: string | null;
  purchase_date: string;
  original_purchase_date?: string;
  unsubscribe_detected_at?: string | null;
  billing_issues_detected_at?: string | null;
  grace_period_expires_date?: string | null;
  refunded_at?: string | null;
  store: string;
  store_transaction_id?: string;
}
export interface RcSubscriberResponse {
  subscriber: {
    entitlements: Record<string, RcEntitlement>;
    subscriptions: Record<string, RcSubscription>;
  };
}

const ms = (s: string | null | undefined): number | null => (s ? Date.parse(s) : null);

/**
 * Converts a RevenueCat subscriber (fetched server-side with the secret key)
 * into the highest-ranked subscription snapshot. Never trusts client input.
 */
export function parseRevenueCatSubscriber(body: RcSubscriberResponse, now: number): SubscriptionSnapshot | null {
  const ents = body?.subscriber?.entitlements ?? {};
  const subs = body?.subscriber?.subscriptions ?? {};
  let best: SubscriptionSnapshot | null = null;

  for (const [entId, ent] of Object.entries(ents)) {
    const planId = STORE_ENTITLEMENT_TO_PLAN[entId];
    if (!planId) continue;
    const sub = subs[ent.product_identifier];
    const expires = ms(ent.expires_date);
    const grace = ms(ent.grace_period_expires_date ?? sub?.grace_period_expires_date);
    let status: SubscriptionStatus;
    if (sub?.refunded_at) status = 'refunded';
    else if (expires != null && expires <= now && !(grace != null && grace > now)) status = 'expired';
    else if (sub?.billing_issues_detected_at) status = grace != null && grace > now ? 'in_grace_period' : 'billing_issue';
    else if (sub?.unsubscribe_detected_at) status = 'cancelled';
    else status = 'active';

    const store = sub?.store ?? 'unknown';
    const snap: SubscriptionSnapshot = {
      planId,
      status,
      currentPeriodStart: ms(sub?.purchase_date ?? ent.purchase_date),
      currentPeriodEnd: expires,
      gracePeriodEnd: grace,
      cancelAtPeriodEnd: Boolean(sub?.unsubscribe_detected_at),
      platform: store === 'app_store' ? 'ios' : store === 'play_store' ? 'android' : store === 'stripe' ? 'web' : 'unknown',
      providerPurchaseId: sub?.store_transaction_id ?? null,
    };
    const entitledNow = isEntitled(snap, now);
    if (!best) { best = snap; continue; }
    const bestEntitled = isEntitled(best, now);
    if ((entitledNow && !bestEntitled)
      || (entitledNow === bestEntitled && PLANS[planId].rank > PLANS[best.planId].rank)) {
      best = snap;
    }
  }
  return best;
}
