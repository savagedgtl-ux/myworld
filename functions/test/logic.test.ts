import { describe, expect, it } from 'vitest';
import { computeEntitlement, isEntitled, parseRevenueCatSubscriber, SubscriptionSnapshot } from '../src/lib/entitlementLogic';
import { canRead } from '../src/lib/access';
import { nextOccurrence, zonedTimeToInstant } from '../src/lib/recurrence';
import { sniffMime, isCompatible } from '../src/lib/fileSniff';
import { validateAnswer, validateExtraction, validateBusinessCard, parseIsoDate, Extraction } from '../src/ai/schemas';
import { selectRelevant, vehicleCostSummary, normalize, recordLine } from '../src/ai/catalog';
import { estimateCostUsd } from '../src/ai/usage';
import { PLANS } from '../src/plans';

const NOW = Date.parse('2026-06-15T12:00:00Z');
const day = 86400_000;
const sub = (planId: SubscriptionSnapshot['planId'], status: SubscriptionSnapshot['status'], endOffset = 10 * day): SubscriptionSnapshot => ({
  planId, status, currentPeriodStart: NOW - 20 * day, currentPeriodEnd: NOW + endOffset, gracePeriodEnd: null,
  cancelAtPeriodEnd: status === 'cancelled', platform: 'ios', providerPurchaseId: 'x',
});

describe('entitlements', () => {
  it('free user: ads, no AI, base limits', () => {
    const e = computeEntitlement({ uid: 'u', now: NOW, ownSubscription: null, family: null });
    expect(e.planId).toBe('individual_base');
    expect(e.aiEnabled).toBe(false);
    expect(e.adsEnabled).toBe(true);
    expect(e.storageLimitBytes).toBe(PLANS.individual_base.storageLimitBytes);
    expect(e.maxDocuments).toBe(100);
    expect(e.usageKey).toBe('u');
  });

  it('individual pro: AI, no ads', () => {
    const e = computeEntitlement({ uid: 'u', now: NOW, ownSubscription: sub('individual_pro', 'active'), family: null });
    expect(e.aiEnabled).toBe(true);
    expect(e.adsEnabled).toBe(false);
  });

  it('family base: no AI, no ads, shared pool', () => {
    const e = computeEntitlement({ uid: 'm', now: NOW, ownSubscription: null, family: { familyId: 'f', role: 'member', planSubscription: sub('family_base', 'active') } });
    expect(e.planId).toBe('family_base');
    expect(e.aiEnabled).toBe(false);
    expect(e.adsEnabled).toBe(false);
    expect(e.usageKey).toBe('f');
    expect(e.maxFamilyMembers).toBe(5);
    expect(e.canInviteMembers).toBe(false);
  });

  it('family pro member gets AI; admin can invite', () => {
    const e = computeEntitlement({ uid: 'm', now: NOW, ownSubscription: null, family: { familyId: 'f', role: 'admin', planSubscription: sub('family_pro', 'active') } });
    expect(e.aiEnabled).toBe(true);
    expect(e.canInviteMembers).toBe(true);
    expect(e.maxFamilyMembers).toBe(10);
  });

  it('11. cancelled subscription keeps access until period end, then loses it', () => {
    expect(isEntitled(sub('individual_pro', 'cancelled', 2 * day), NOW)).toBe(true);
    const expired = computeEntitlement({ uid: 'u', now: NOW, ownSubscription: sub('individual_pro', 'cancelled', -1), family: null });
    expect(expired.aiEnabled).toBe(false);
    expect(expired.adsEnabled).toBe(true);
  });

  it('grace period honoured only while it lasts', () => {
    const g = { ...sub('individual_pro', 'in_grace_period', -day), gracePeriodEnd: NOW + day };
    expect(isEntitled(g, NOW)).toBe(true);
    expect(isEntitled({ ...g, gracePeriodEnd: NOW - 1 }, NOW)).toBe(false);
  });

  it('refunded and expired never entitle', () => {
    expect(isEntitled(sub('family_pro', 'refunded'), NOW)).toBe(false);
    expect(isEntitled(sub('family_pro', 'expired'), NOW)).toBe(false);
  });

  it('lapsed family plan drops member back to base', () => {
    const e = computeEntitlement({ uid: 'm', now: NOW, ownSubscription: null, family: { familyId: 'f', role: 'member', planSubscription: sub('family_pro', 'expired') } });
    expect(e.planId).toBe('individual_base');
    expect(e.aiEnabled).toBe(false);
    expect(e.usageKey).toBe('m');
  });

  it('own individual pro inside a family base keeps AI (union)', () => {
    const e = computeEntitlement({ uid: 'm', now: NOW, ownSubscription: sub('individual_pro', 'active'), family: { familyId: 'f', role: 'member', planSubscription: sub('family_base', 'active') } });
    expect(e.aiEnabled).toBe(true);
    expect(e.adsEnabled).toBe(false);
  });

  it('family plan buyer without family can create one', () => {
    const e = computeEntitlement({ uid: 'o', now: NOW, ownSubscription: sub('family_base', 'active'), family: null });
    expect(e.canCreateFamily).toBe(true);
  });
});

describe('RevenueCat parsing', () => {
  const body = (over: any = {}) => ({
    subscriber: {
      entitlements: {
        individual_pro: { expires_date: '2026-07-01T00:00:00Z', product_identifier: 'mw_ind_pro_m', purchase_date: '2026-06-01T00:00:00Z' },
        ...over.entitlements,
      },
      subscriptions: {
        mw_ind_pro_m: { expires_date: '2026-07-01T00:00:00Z', purchase_date: '2026-06-01T00:00:00Z', store: 'app_store', ...over.sub },
        ...over.subscriptions,
      },
    },
  });

  it('active', () => {
    const s = parseRevenueCatSubscriber(body() as any, NOW)!;
    expect(s.planId).toBe('individual_pro');
    expect(s.status).toBe('active');
    expect(s.platform).toBe('ios');
  });
  it('cancel detected', () => {
    expect(parseRevenueCatSubscriber(body({ sub: { unsubscribe_detected_at: '2026-06-10T00:00:00Z' } }) as any, NOW)!.status).toBe('cancelled');
  });
  it('refund', () => {
    expect(parseRevenueCatSubscriber(body({ sub: { refunded_at: '2026-06-10T00:00:00Z' } }) as any, NOW)!.status).toBe('refunded');
  });
  it('billing issue with grace', () => {
    const s = parseRevenueCatSubscriber(body({ sub: { billing_issues_detected_at: '2026-06-14T00:00:00Z', grace_period_expires_date: '2026-06-20T00:00:00Z' } }) as any, NOW)!;
    expect(s.status).toBe('in_grace_period');
  });
  it('picks highest entitled plan', () => {
    const s = parseRevenueCatSubscriber(body({
      entitlements: { family_pro: { expires_date: '2026-07-01T00:00:00Z', product_identifier: 'mw_fam_pro_m', purchase_date: '2026-06-01T00:00:00Z' } },
      subscriptions: { mw_fam_pro_m: { expires_date: '2026-07-01T00:00:00Z', purchase_date: '2026-06-01T00:00:00Z', store: 'play_store' } },
    }) as any, NOW)!;
    expect(s.planId).toBe('family_pro');
  });
  it('ignores unknown entitlements', () => {
    expect(parseRevenueCatSubscriber({ subscriber: { entitlements: { hacked: { expires_date: null, product_identifier: 'x', purchase_date: '' } }, subscriptions: {} } } as any, NOW)).toBeNull();
  });
});

describe('access', () => {
  const fams = new Set(['f']);
  it('private visible only to owner', () => {
    expect(canRead({ ownerUid: 'a', familyId: 'f', privacyLevel: 'private' }, 'a', fams)).toBe(true);
    expect(canRead({ ownerUid: 'a', familyId: 'f', privacyLevel: 'private' }, 'b', fams)).toBe(false);
  });
  it('family requires active membership', () => {
    expect(canRead({ ownerUid: 'a', familyId: 'f', privacyLevel: 'family' }, 'b', fams)).toBe(true);
    expect(canRead({ ownerUid: 'a', familyId: 'f', privacyLevel: 'family' }, 'b', new Set())).toBe(false);
  });
  it('shared only to listed members', () => {
    expect(canRead({ ownerUid: 'a', familyId: 'f', privacyLevel: 'shared', sharedWith: ['b'] }, 'b', fams)).toBe(true);
    expect(canRead({ ownerUid: 'a', familyId: 'f', privacyLevel: 'shared', sharedWith: ['b'] }, 'c', fams)).toBe(false);
  });
});

describe('recurrence (timezones)', () => {
  const tz = 'Europe/Belgrade';
  it('keeps local wall time across DST', () => {
    const due = zonedTimeToInstant({ y: 2026, mo: 3, d: 20, h: 9, mi: 0, s: 0 }, tz); // CET
    const next = nextOccurrence(due, 'weekly', tz, due)!; // Mar 27 still CET? DST starts Mar 29
    const next2 = nextOccurrence(due, 'weekly', tz, next)!; // Apr 3 CEST
    const hour = (t: number) => new Intl.DateTimeFormat('en-GB', { timeZone: tz, hour: '2-digit', hourCycle: 'h23' }).format(new Date(t));
    expect(hour(next)).toBe('09');
    expect(hour(next2)).toBe('09');
    expect(next2 - next).toBe(7 * day - 3600_000);
  });
  it('monthly clamps to month end', () => {
    const due = zonedTimeToInstant({ y: 2026, mo: 1, d: 31, h: 10, mi: 0, s: 0 }, tz);
    const next = nextOccurrence(due, 'monthly', tz, due)!;
    expect(new Date(next).toISOString().slice(0, 10)).toBe('2026-02-28');
  });
  it('yearly skips past occurrences', () => {
    const due = Date.parse('2020-05-01T08:00:00Z');
    const next = nextOccurrence(due, 'yearly', 'UTC', NOW)!;
    expect(new Date(next).toISOString()).toBe('2027-05-01T08:00:00.000Z');
  });
  it('none returns null', () => {
    expect(nextOccurrence(NOW, 'none', tz, NOW)).toBeNull();
  });
});

describe('file sniffing', () => {
  it('detects real types and rejects mismatches', () => {
    expect(sniffMime(new Uint8Array([0x25, 0x50, 0x44, 0x46, 0x2d, 0x31]))).toBe('application/pdf');
    expect(sniffMime(new Uint8Array([0xff, 0xd8, 0xff, 0xe0]))).toBe('image/jpeg');
    expect(sniffMime(new Uint8Array([0x4d, 0x5a, 0x90, 0x00]))).toBeNull(); // .exe
    expect(isCompatible('application/pdf', 'image/jpeg')).toBe(false);
    expect(isCompatible('image/heif', 'image/heic')).toBe(true);
  });
});

describe('AI output validation', () => {
  const base: Extraction = {
    documentType: 'receipt', title: 'Račun', vendor: 'Gigatron', productName: 'TV', purchaseDate: '2025-12-12',
    documentDate: null, amount: 549.99, currency: 'eur', warrantyDurationMonths: null, warrantyExpiryDate: null,
    expiryDate: null, suggestedCategory: 'receipts', suggestedArea: 'home', suggestedTags: ['TV'], summary: null,
    dateCandidates: [], confidence: 0.9, fieldsNeedingReview: [], containsInstructions: false,
  };
  it('normalises currency and keeps valid fields', () => {
    const v = validateExtraction(base, new Date(NOW));
    expect(v.fields.currency).toBe('EUR');
    expect(v.fields.purchaseDate).toBe('2025-12-12');
    expect(v.needsReview).toBe(true);
  });
  it('rejects impossible and future purchase dates', () => {
    expect(parseIsoDate('2025-02-31')).toBeNull();
    const v = validateExtraction({ ...base, purchaseDate: '2027-01-01' }, new Date(NOW));
    expect(v.fields.purchaseDate).toBeNull();
    expect(v.fieldsNeedingReview).toContain('purchaseDate');
  });
  it('never trusts warranty: before purchase is dropped, any warranty needs review', () => {
    const bad = validateExtraction({ ...base, warrantyExpiryDate: '2024-01-01' }, new Date(NOW));
    expect(bad.fields.warrantyExpiryDate).toBeNull();
    const ok = validateExtraction({ ...base, warrantyExpiryDate: '2027-12-12', warrantyDurationMonths: 24 }, new Date(NOW));
    expect(ok.fieldsNeedingReview).toContain('warrantyExpiryDate');
  });
  it('flags negative amounts and prompt injection', () => {
    const v = validateExtraction({ ...base, amount: -5, containsInstructions: true }, new Date(NOW));
    expect(v.fields.amount).toBeNull();
    expect(v.warnings).toContain('prompt_injection_suspected');
  });
  it('multiple date candidates force review', () => {
    const v = validateExtraction({ ...base, dateCandidates: [{ label: 'izdato', date: '2025-12-12' }, { label: 'isporuka', date: '2025-12-15' }] }, new Date(NOW));
    expect(v.fieldsNeedingReview).toContain('purchaseDate');
  });
  it('10. answers cannot cite records that were not provided', () => {
    const a = validateAnswer({ answer: 'x', sourceIds: ['mine', 'someoneElsesPrivateDoc'], insufficientData: false }, new Set(['mine']));
    expect(a.sourceIds).toEqual(['mine']);
    const none = validateAnswer({ answer: 'x', sourceIds: ['ghost'], insufficientData: false }, new Set(['mine']));
    expect(none.insufficientData).toBe(true);
  });
  it('business card validation drops junk', () => {
    const b = validateBusinessCard({ fullName: ' Ana ', company: null, jobTitle: null, phones: ['+381 64 123 4567', '12'], emails: ['ANA@X.RS', 'nope'], website: null, address: null, confidence: 2 });
    expect(b.fullName).toBe('Ana');
    expect(b.phones).toEqual(['+381 64 123 4567']);
    expect(b.emails).toEqual(['ana@x.rs']);
    expect(b.confidence).toBe(1);
  });
});

describe('AI context catalog', () => {
  const ts = (iso: string) => ({ toMillis: () => Date.parse(iso) });
  const recs = [
    { collection: 'documents', id: 'd1', data: { title: 'Garancija veš mašina Bosch', vendor: 'Tehnomanija', warrantyExpiryDate: ts('2027-03-01'), updatedAt: ts('2026-01-01') } },
    { collection: 'documents', id: 'd2', data: { title: 'Ugovor stan', updatedAt: ts('2026-02-01') } },
    { collection: 'vehicles', id: 'v1', data: { make: 'Škoda', model: 'Octavia' } },
    { collection: 'vehicleRecords', id: 'r1', data: { vehicleId: 'v1', recordType: 'service', date: ts('2026-03-01'), amount: 120, currency: 'EUR' } },
    { collection: 'vehicleRecords', id: 'r2', data: { vehicleId: 'v1', recordType: 'tires', date: ts('2026-04-01'), amount: 300, currency: 'EUR' } },
  ];
  it('normalises Serbian diacritics', () => {
    expect(normalize('Šta je VEŠ mašina, Đorđe?')).toBe('sta je ves masina djordje');
  });
  it('relevance puts matching record first', () => {
    const sel = selectRelevant('Kada mi ističe garancija za veš mašinu?', recs, new Map(), 3);
    expect(sel[0].id).toBe('d1');
  });
  it('vehicle totals are computed deterministically', () => {
    const lines = vehicleCostSummary(recs, new Date(NOW));
    expect(lines.some((l) => l.includes('period=2026') && l.includes('total=420 EUR'))).toBe(true);
  });
  it('record lines strip separators', () => {
    expect(recordLine({ collection: 'documents', id: 'x', data: { title: 'a|b\nc' } })).toContain('title=a b c');
  });
  it('cost estimate', () => {
    expect(estimateCostUsd('gpt-5-mini', 1_000_000, 0)).toBeCloseTo(0.25);
  });
});
