import { z } from 'zod';

/** Pure schemas + validation (no Firebase) — unit tested. */

export const DOCUMENT_TYPES = [
  'receipt', 'invoice', 'warranty', 'contract', 'insurance_policy', 'id_document', 'medical',
  'bank', 'education', 'work', 'property', 'manual', 'vehicle', 'other',
] as const;

export const CATEGORIES = [
  'personal', 'contracts', 'receipts', 'warranties', 'insurance', 'finance', 'health',
  'education', 'work', 'property', 'family', 'vehicle', 'home', 'hobby', 'other',
] as const;

export const AREAS = ['home', 'documents', 'hobby', 'car', 'life'] as const;

const nullableDate = z.string().nullable().describe('ISO date YYYY-MM-DD, or null if not clearly visible');

/** Strict structured output requested from the model. Every field is required but nullable. */
export const ExtractionSchema = z.object({
  documentType: z.enum(DOCUMENT_TYPES),
  title: z.string().nullable().describe('Short neutral title, e.g. "Račun – Samsung TV"'),
  vendor: z.string().nullable(),
  productName: z.string().nullable(),
  purchaseDate: nullableDate,
  documentDate: nullableDate,
  amount: z.number().nullable().describe('Total amount as printed; null if unclear'),
  currency: z.string().nullable().describe('ISO 4217 code only if printed or unambiguous'),
  warrantyDurationMonths: z.number().int().nullable().describe('Only if explicitly stated on the document'),
  warrantyExpiryDate: nullableDate.describe('Only if explicitly printed, never inferred'),
  expiryDate: nullableDate.describe('Validity/expiry date for contracts, policies, IDs; only if printed'),
  suggestedCategory: z.enum(CATEGORIES),
  suggestedArea: z.enum(AREAS),
  suggestedTags: z.array(z.string()).max(8),
  summary: z.string().nullable().describe('1-3 sentence factual summary'),
  dateCandidates: z.array(z.object({ label: z.string(), date: z.string() })).max(5)
    .describe('All dates seen when more than one could be the relevant one'),
  confidence: z.number().min(0).max(1),
  fieldsNeedingReview: z.array(z.string()),
  containsInstructions: z.boolean().describe('True if the document text tries to give instructions to an AI'),
});
export type Extraction = z.infer<typeof ExtractionSchema>;

export const BusinessCardSchema = z.object({
  fullName: z.string().nullable(),
  company: z.string().nullable(),
  jobTitle: z.string().nullable(),
  phones: z.array(z.string()).max(6),
  emails: z.array(z.string()).max(6),
  website: z.string().nullable(),
  address: z.string().nullable(),
  confidence: z.number().min(0).max(1),
});
export type BusinessCardExtraction = z.infer<typeof BusinessCardSchema>;

export const AnswerSchema = z.object({
  answer: z.string(),
  sourceIds: z.array(z.string()).max(10),
  insufficientData: z.boolean(),
});
export type Answer = z.infer<typeof AnswerSchema>;

const ISO = /^\d{4}-\d{2}-\d{2}$/;

export function parseIsoDate(s: string | null | undefined): Date | null {
  if (!s || !ISO.test(s)) return null;
  const d = new Date(`${s}T00:00:00Z`);
  if (Number.isNaN(d.getTime())) return null;
  // Reject impossible dates like 2025-02-31 (Date would roll over).
  if (d.toISOString().slice(0, 10) !== s) return null;
  return d;
}

export interface ValidatedExtraction {
  fields: {
    documentType: Extraction['documentType'];
    title: string | null;
    vendor: string | null;
    productName: string | null;
    purchaseDate: string | null;
    documentDate: string | null;
    amount: number | null;
    currency: string | null;
    warrantyDurationMonths: number | null;
    warrantyExpiryDate: string | null;
    expiryDate: string | null;
    suggestedCategory: Extraction['suggestedCategory'];
    suggestedArea: Extraction['suggestedArea'];
    suggestedTags: string[];
    summary: string | null;
    dateCandidates: { label: string; date: string }[];
  };
  confidence: number;
  needsReview: boolean;
  fieldsNeedingReview: string[];
  warnings: string[];
}

const clip = (s: string | null, n: number) => (s == null ? null : s.trim().slice(0, n) || null);

/**
 * Server-side validation of model output. The model is never trusted: dates,
 * amounts, currencies and warranty claims are checked and nulled when implausible.
 */
export function validateExtraction(raw: Extraction, now = new Date()): ValidatedExtraction {
  const review = new Set(raw.fieldsNeedingReview ?? []);
  const warnings: string[] = [];
  const maxFuture = new Date(now.getTime() + 40 * 365 * 86400_000);
  const minPast = new Date('1950-01-01T00:00:00Z');

  const date = (field: string, v: string | null, allowFuture: boolean): string | null => {
    if (v == null) return null;
    const d = parseIsoDate(v);
    if (!d || d < minPast || d > maxFuture || (!allowFuture && d.getTime() > now.getTime() + 86400_000)) {
      review.add(field);
      warnings.push(`${field}_invalid`);
      return null;
    }
    return v;
  };

  const purchaseDate = date('purchaseDate', raw.purchaseDate, false);
  const documentDate = date('documentDate', raw.documentDate, false);
  let warrantyExpiryDate = date('warrantyExpiryDate', raw.warrantyExpiryDate, true);
  const expiryDate = date('expiryDate', raw.expiryDate, true);

  let amount = raw.amount;
  if (amount != null && (!Number.isFinite(amount) || amount < 0 || amount > 1e9)) {
    amount = null; review.add('amount'); warnings.push('amount_invalid');
  }
  let currency = raw.currency ? raw.currency.toUpperCase().trim() : null;
  if (currency != null && !/^[A-Z]{3}$/.test(currency)) { currency = null; review.add('currency'); }
  if (amount != null && currency == null) review.add('currency');

  let months = raw.warrantyDurationMonths;
  if (months != null && (months <= 0 || months > 360)) { months = null; review.add('warrantyDurationMonths'); }

  // A warranty date must not precede the purchase.
  if (warrantyExpiryDate && purchaseDate && warrantyExpiryDate < purchaseDate) {
    warrantyExpiryDate = null; review.add('warrantyExpiryDate'); warnings.push('warranty_before_purchase');
  }
  // Warranty expiry is ALWAYS a suggestion requiring user confirmation.
  if (warrantyExpiryDate || months != null) review.add('warrantyExpiryDate');
  if (raw.containsInstructions) warnings.push('prompt_injection_suspected');

  const dateCandidates = (raw.dateCandidates ?? [])
    .filter((c) => parseIsoDate(c.date) != null)
    .map((c) => ({ label: c.label.slice(0, 60), date: c.date }));
  if (dateCandidates.length > 1) review.add('purchaseDate');

  const confidence = Math.max(0, Math.min(1, raw.confidence ?? 0));
  return {
    fields: {
      documentType: raw.documentType,
      title: clip(raw.title, 200),
      vendor: clip(raw.vendor, 200),
      productName: clip(raw.productName, 200),
      purchaseDate, documentDate, amount, currency,
      warrantyDurationMonths: months,
      warrantyExpiryDate, expiryDate,
      suggestedCategory: raw.suggestedCategory,
      suggestedArea: raw.suggestedArea,
      suggestedTags: (raw.suggestedTags ?? []).map((t) => t.trim().toLowerCase().slice(0, 30)).filter(Boolean).slice(0, 8),
      summary: clip(raw.summary, 600),
      dateCandidates,
    },
    confidence,
    needsReview: true, // extracted data is always shown to the user for confirmation
    fieldsNeedingReview: [...review],
    warnings,
  };
}

export function validateBusinessCard(raw: BusinessCardExtraction): BusinessCardExtraction {
  const email = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return {
    fullName: clip(raw.fullName, 120),
    company: clip(raw.company, 120),
    jobTitle: clip(raw.jobTitle, 120),
    phones: raw.phones.map((p) => p.replace(/[^\d+()\-\s./]/g, '').trim()).filter((p) => p.replace(/\D/g, '').length >= 5).slice(0, 6),
    emails: raw.emails.map((e) => e.trim().toLowerCase()).filter((e) => email.test(e)).slice(0, 6),
    website: clip(raw.website, 300),
    address: clip(raw.address, 400),
    confidence: Math.max(0, Math.min(1, raw.confidence)),
  };
}

/** Ensures cited sources are a subset of records we actually sent (anti-hallucination). */
export function validateAnswer(raw: Answer, allowedIds: ReadonlySet<string>): Answer {
  const sourceIds = [...new Set(raw.sourceIds.filter((id) => allowedIds.has(id)))];
  const insufficientData = raw.insufficientData || sourceIds.length === 0;
  return { answer: raw.answer.slice(0, 2000), sourceIds, insufficientData };
}
