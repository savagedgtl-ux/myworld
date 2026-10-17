import { HttpsError } from 'firebase-functions/v2/https';
import * as logger from 'firebase-functions/logger';
import { db, FieldValue, monthKey } from '../lib/admin';
import { Entitlement } from '../lib/entitlementLogic';
import { AI_FAMILY_MONTHLY_BUDGET_USD, AI_REQUESTS_PER_MINUTE } from '../plans';

export type AiTask = 'extract_document' | 'extract_business_card' | 'ask';

/** Estimated USD per 1M tokens. Update when provider pricing changes. */
const PRICES: Record<string, { in: number; out: number }> = {
  'gpt-5-mini': { in: 0.25, out: 2.0 },
  'gpt-5-nano': { in: 0.05, out: 0.4 },
  'gpt-5': { in: 1.25, out: 10.0 },
  'gpt-4.1-mini': { in: 0.4, out: 1.6 },
};

export function estimateCostUsd(model: string, inputTokens: number, outputTokens: number): number {
  const p = PRICES[model] ?? PRICES['gpt-5-mini'];
  return (inputTokens * p.in + outputTokens * p.out) / 1_000_000;
}

/**
 * Reserves one AI request against per-minute, monthly per-user, family and
 * global budgets. Throws a controlled error when any limit is hit.
 */
export async function reserveAiRequest(uid: string, ent: Entitlement): Promise<void> {
  const mk = monthKey();
  const userRef = db.collection('aiBudgets').doc(`${uid}_${mk}`);
  const famRef = ent.familyId ? db.collection('aiBudgets').doc(`family_${ent.familyId}_${mk}`) : null;
  const globalRef = db.collection('aiGlobal').doc(mk);
  const globalBudget = Number(process.env.AI_GLOBAL_MONTHLY_BUDGET_USD ?? 200);

  await db.runTransaction(async (tx) => {
    const [u, f, g] = await Promise.all([tx.get(userRef), famRef ? tx.get(famRef) : Promise.resolve(null), tx.get(globalRef)]);
    const now = Date.now();
    const windowStart = Number(u.get('minuteWindowStart') ?? 0);
    const inWindow = now - windowStart < 60_000;
    const minuteCount = inWindow ? Number(u.get('minuteCount') ?? 0) : 0;

    if (minuteCount >= AI_REQUESTS_PER_MINUTE) throw new HttpsError('resource-exhausted', 'ai_rate_limited');
    if (Number(u.get('requests') ?? 0) >= ent.aiMonthlyRequests) throw new HttpsError('resource-exhausted', 'ai_monthly_limit');
    if (Number(u.get('costUsd') ?? 0) >= ent.aiMonthlyBudgetUsd) throw new HttpsError('resource-exhausted', 'ai_monthly_limit');
    if (f && Number(f.get('costUsd') ?? 0) >= AI_FAMILY_MONTHLY_BUDGET_USD) throw new HttpsError('resource-exhausted', 'ai_family_limit');
    if (Number(g.get('costUsd') ?? 0) >= globalBudget) {
      logger.error('ai_global_budget_exhausted', { month: mk });
      throw new HttpsError('unavailable', 'ai_temporarily_unavailable');
    }

    tx.set(userRef, {
      uid, month: mk, requests: FieldValue.increment(1),
      minuteWindowStart: inWindow ? windowStart : now,
      minuteCount: minuteCount + 1,
      limitRequests: ent.aiMonthlyRequests,
      updatedAt: FieldValue.serverTimestamp(),
    }, { merge: true });
  });
}

export async function recordAiUsage(args: {
  uid: string; ent: Entitlement; task: AiTask; model: string;
  inputTokens: number; outputTokens: number; status: 'ok' | 'error'; errorCode?: string;
}) {
  const cost = estimateCostUsd(args.model, args.inputTokens, args.outputTokens);
  const mk = monthKey();
  const batch = db.batch();
  batch.set(db.collection('aiUsage').doc(), {
    uid: args.uid, planId: args.ent.planId, familyId: args.ent.familyId, task: args.task, model: args.model,
    inputTokens: args.inputTokens, outputTokens: args.outputTokens, estimatedCostUsd: cost,
    status: args.status, errorCode: args.errorCode ?? null, createdAt: FieldValue.serverTimestamp(),
  });
  batch.set(db.collection('aiBudgets').doc(`${args.uid}_${mk}`), { costUsd: FieldValue.increment(cost) }, { merge: true });
  if (args.ent.familyId) {
    batch.set(db.collection('aiBudgets').doc(`family_${args.ent.familyId}_${mk}`),
      { uid: null, familyId: args.ent.familyId, costUsd: FieldValue.increment(cost) }, { merge: true });
  }
  batch.set(db.collection('aiGlobal').doc(mk), { costUsd: FieldValue.increment(cost) }, { merge: true });
  await batch.commit();

  const g = await db.collection('aiGlobal').doc(mk).get();
  const budget = Number(process.env.AI_GLOBAL_MONTHLY_BUDGET_USD ?? 200);
  if (Number(g.get('costUsd') ?? 0) > budget * 0.8) logger.warn('ai_global_budget_80_percent', { month: mk });
}
