/**
 * Central plan catalog — the single source of truth for what each plan allows.
 * The Flutter app has a display-only mirror (app/lib/domain/plans.dart); the
 * server values below are authoritative.
 *
 * Limits are initial business assumptions and can be changed here without
 * touching any screen.
 */

export type PlanId = 'individual_base' | 'individual_pro' | 'family_base' | 'family_pro';

export interface PlanDefinition {
  id: PlanId;
  priceEurMonthly: number;
  isFamily: boolean;
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
  rank: number;
}

const MB = 1024 * 1024;
const GB = 1024 * MB;

export const PLANS: Record<PlanId, PlanDefinition> = {
  individual_base: {
    id: 'individual_base', priceEurMonthly: 0, isFamily: false,
    aiEnabled: false, adsEnabled: true,
    storageLimitBytes: 100 * MB, maxDocuments: 100, maxFamilyMembers: 1, maxVehicles: 2,
    advancedExport: false, advancedFilters: false,
    aiMonthlyRequests: 0, aiMonthlyBudgetUsd: 0, rank: 0,
  },
  individual_pro: {
    id: 'individual_pro', priceEurMonthly: 4.99, isFamily: false,
    aiEnabled: true, adsEnabled: false,
    storageLimitBytes: 10 * GB, maxDocuments: 10000, maxFamilyMembers: 1, maxVehicles: 10,
    advancedExport: true, advancedFilters: true,
    aiMonthlyRequests: 300, aiMonthlyBudgetUsd: 1.5, rank: 2,
  },
  family_base: {
    id: 'family_base', priceEurMonthly: 4.99, isFamily: true,
    aiEnabled: false, adsEnabled: false,
    storageLimitBytes: 20 * GB, maxDocuments: 20000, maxFamilyMembers: 5, maxVehicles: 10,
    advancedExport: false, advancedFilters: true,
    aiMonthlyRequests: 0, aiMonthlyBudgetUsd: 0, rank: 1,
  },
  family_pro: {
    id: 'family_pro', priceEurMonthly: 14.99, isFamily: true,
    aiEnabled: true, adsEnabled: false,
    storageLimitBytes: 100 * GB, maxDocuments: 100000, maxFamilyMembers: 10, maxVehicles: 25,
    advancedExport: true, advancedFilters: true,
    // Per user; the family as a whole is additionally capped by aiFamilyMonthlyBudgetUsd.
    aiMonthlyRequests: 400, aiMonthlyBudgetUsd: 2, rank: 3,
  },
};

export const AI_FAMILY_MONTHLY_BUDGET_USD = 6;
export const AI_REQUESTS_PER_MINUTE = 8;

/** Keep in sync with storage.rules. */
export const MAX_UPLOAD_BYTES = 25 * MB;
export const MAX_PAGES_FOR_AI = 15;
export const MAX_AI_INPUT_CHARS = 24000;
export const TRASH_RETENTION_DAYS = 30;
export const INVITATION_TTL_DAYS = 7;
export const EXPORT_TTL_DAYS = 7;

/** RevenueCat entitlement identifiers → plan. Configure the same IDs in RevenueCat. */
export const STORE_ENTITLEMENT_TO_PLAN: Record<string, PlanId> = {
  individual_pro: 'individual_pro',
  family_base: 'family_base',
  family_pro: 'family_pro',
};

export function isPlanId(v: unknown): v is PlanId {
  return typeof v === 'string' && v in PLANS;
}
