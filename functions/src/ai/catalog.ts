/**
 * Builds the compact, permission-filtered context sent to the model for
 * questions. Pure functions — unit tested. Only metadata the user can already
 * see is included; vault documents are never included.
 */

export interface CatalogRecord {
  collection: string;
  id: string;
  data: Record<string, any>;
}

export function normalize(s: string): string {
  return s.toLowerCase()
    .replace(/đ/g, 'dj')
    .normalize('NFD').replace(/[̀-ͯ]/g, '')
    .replace(/[^a-z0-9а-я\s]/gi, ' ')
    .replace(/\s+/g, ' ').trim();
}

const STOP = new Set(['i', 'u', 'na', 'za', 'je', 'da', 'sam', 'mi', 'moj', 'moja', 'moje', 'koji', 'koja', 'koje', 'kada', 'gde',
  'sve', 'svi', 'the', 'a', 'an', 'of', 'my', 'is', 'when', 'what', 'which', 'do', 'i', 'to', 'for', 'in', 'pronadji', 'prikazi', 'find', 'show']);

export function tokens(s: string): string[] {
  return normalize(s).split(' ').filter((t) => t.length > 1 && !STOP.has(t));
}

const iso = (v: any): string | null => {
  if (!v) return null;
  const ms = typeof v.toMillis === 'function' ? v.toMillis() : typeof v === 'number' ? v : Date.parse(v);
  return Number.isFinite(ms) ? new Date(ms).toISOString().slice(0, 10) : null;
};

/** One line per record, limited fields, no file contents. */
export function recordLine(r: CatalogRecord, summary?: string | null): string {
  const d = r.data;
  const f = (k: string, v: unknown) => (v == null || v === '' ? '' : `${k}=${String(v).replace(/[|\n]/g, ' ').slice(0, 120)}`);
  const parts: string[] = [];
  switch (r.collection) {
    case 'documents':
      parts.push(f('title', d.title), f('category', d.categoryId), f('vendor', d.vendor), f('date', iso(d.documentDate) ?? iso(d.purchaseDate)),
        f('amount', d.amount != null ? `${d.amount} ${d.currency ?? ''}` : null), f('warrantyUntil', iso(d.warrantyExpiryDate)),
        f('expires', iso(d.expiryDate)), f('tags', (d.tags ?? []).join(',')), f('added', iso(d.createdAt)), f('summary', summary));
      break;
    case 'assets':
      parts.push(f('name', d.name), f('area', d.area), f('category', d.category), f('brand', d.brand), f('model', d.model),
        f('purchased', iso(d.purchaseDate)), f('price', d.purchasePrice != null ? `${d.purchasePrice} ${d.currency ?? ''}` : null),
        f('vendor', d.vendor), f('warrantyUntil', iso(d.warrantyExpiryDate)), f('location', d.location));
      break;
    case 'vehicles':
      parts.push(f('vehicle', `${d.make ?? ''} ${d.model ?? ''}`.trim()), f('year', d.year), f('plate', d.registrationNumber), f('mileage', d.currentMileage));
      break;
    case 'vehicleRecords':
      parts.push(f('vehicleId', d.vehicleId), f('type', d.recordType), f('date', iso(d.date)),
        f('amount', d.amount != null ? `${d.amount} ${d.currency ?? ''}` : null), f('mileage', d.mileage), f('vendor', d.vendor),
        f('nextDue', iso(d.nextDueDate)), f('desc', d.description));
      break;
    case 'reminders':
      parts.push(f('title', d.title), f('due', iso(d.dueAt)), f('repeat', d.repeatRule), f('status', d.status));
      break;
    case 'walletCards':
      parts.push(f('card', d.name), f('kind', d.kind), f('issuer', d.issuer), f('discount', d.discountText), f('expires', iso(d.expiryDate)));
      break;
    case 'businessCards':
      parts.push(f('name', d.fullName), f('company', d.company), f('title', d.jobTitle), f('metWhere', d.metWhere), f('tags', (d.tags ?? []).join(',')));
      break;
  }
  return `[${r.id}] ${r.collection} | ${parts.filter(Boolean).join(' | ')}`;
}

export function searchableText(r: CatalogRecord, summary?: string | null): string {
  return normalize(recordLine(r, summary));
}

/** Lexical relevance pre-filter so we never send the whole archive. */
export function selectRelevant(question: string, records: CatalogRecord[], summaries: Map<string, string>, limit = 40): CatalogRecord[] {
  const q = tokens(question);
  const scored = records.map((r) => {
    const text = searchableText(r, summaries.get(r.id));
    let score = 0;
    for (const t of q) {
      if (text.includes(t)) score += 3;
      else if (t.length >= 5 && text.includes(t.slice(0, t.length - 2))) score += 1; // crude stemming for Serbian cases
    }
    return { r, score };
  });
  const hits = scored.filter((s) => s.score > 0).sort((a, b) => b.score - a.score);
  if (hits.length >= limit) return hits.slice(0, limit).map((h) => h.r);
  // Fill with most recent records so date/aggregate questions still have context.
  const recent = scored.filter((s) => s.score === 0)
    .sort((a, b) => Number(b.r.data.updatedAt?.toMillis?.() ?? 0) - Number(a.r.data.updatedAt?.toMillis?.() ?? 0));
  return [...hits, ...recent].slice(0, limit).map((h) => h.r);
}

/** Deterministic cost aggregates — the model is given numbers, not asked to add them up. */
export function vehicleCostSummary(records: CatalogRecord[], now = new Date()): string[] {
  const vehicles = new Map(records.filter((r) => r.collection === 'vehicles').map((r) => [r.id, `${r.data.make ?? ''} ${r.data.model ?? ''}`.trim()]));
  const totals = new Map<string, number>();
  const year = now.getUTCFullYear();
  for (const r of records) {
    if (r.collection !== 'vehicleRecords' || r.data.amount == null) continue;
    const ms = r.data.date?.toMillis?.() ?? null;
    const y = ms ? new Date(ms).getUTCFullYear() : null;
    const cur = r.data.currency ?? '?';
    const keyAll = `${r.data.vehicleId}|all|${cur}`;
    totals.set(keyAll, (totals.get(keyAll) ?? 0) + Number(r.data.amount));
    if (y != null) {
      const keyY = `${r.data.vehicleId}|${y}|${cur}`;
      totals.set(keyY, (totals.get(keyY) ?? 0) + Number(r.data.amount));
    }
  }
  const lines: string[] = [];
  for (const [k, v] of totals) {
    const [vid, period, cur] = k.split('|');
    if (period !== 'all' && Number(period) < year - 2) continue;
    lines.push(`[${vid}] vehicleCosts | vehicle=${vehicles.get(vid) ?? vid} | period=${period} | total=${Math.round(v * 100) / 100} ${cur}`);
  }
  return lines;
}
