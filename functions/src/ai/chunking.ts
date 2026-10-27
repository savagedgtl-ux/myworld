/**
 * Full-text search building blocks: splitting document text into passages
 * and choosing which passages go into a question's context. Pure functions —
 * unit tested.
 */
import { normalize, tokens } from './catalog';

export const CHUNK_CHARS = 1200;
export const CHUNK_OVERLAP = 200;
export const MAX_CHUNKS_PER_DOCUMENT = 250;

/** Collapses whitespace but keeps paragraph breaks, which help the model. */
export function cleanText(text: string): string {
  return text
    .replace(/\r\n?/g, '\n')
    .replace(/[ \t\f\v ]+/g, ' ')
    .replace(/ *\n */g, '\n')
    .replace(/\n{3,}/g, '\n\n')
    .trim();
}

/**
 * Splits text into ~CHUNK_CHARS passages that overlap by CHUNK_OVERLAP, cutting
 * at a paragraph, sentence or word boundary when one is near the limit.
 */
export function chunkText(text: string, size = CHUNK_CHARS, overlap = CHUNK_OVERLAP, maxChunks = MAX_CHUNKS_PER_DOCUMENT): string[] {
  const t = cleanText(text);
  if (!t) return [];
  const out: string[] = [];
  let start = 0;
  while (start < t.length && out.length < maxChunks) {
    let end = Math.min(t.length, start + size);
    if (end < t.length) {
      const window = t.slice(start + Math.floor(size * 0.6), end);
      const cut = Math.max(window.lastIndexOf('\n\n'), window.lastIndexOf('. '), window.lastIndexOf('\n'));
      if (cut > 0) end = start + Math.floor(size * 0.6) + cut + 1;
      else {
        const space = t.lastIndexOf(' ', end);
        if (space > start + size / 2) end = space;
      }
    }
    const piece = t.slice(start, end).trim();
    if (piece) out.push(piece);
    if (end >= t.length) break;
    start = Math.max(end - overlap, start + 1);
    // Don't start a passage mid-word.
    const space = t.indexOf(' ', start);
    if (space !== -1 && space - start < 30) start = space + 1;
  }
  return out;
}

/** How many question terms (with crude Serbian case stemming) appear in a text. */
export function lexicalScore(questionTokens: string[], text: string): number {
  const n = normalize(text);
  let score = 0;
  for (const tok of questionTokens) {
    if (n.includes(tok)) score += 3;
    else if (tok.length >= 5 && n.includes(tok.slice(0, tok.length - 2))) score += 1;
  }
  return score;
}

export interface Passage {
  id: string;
  documentId: string;
  chunkIndex: number;
  text: string;
  /** Cosine distance from the question; lower is closer. Absent for lexical picks. */
  distance?: number;
}

/**
 * Merges lexical picks (exact names, e.g. a doctor's surname) with semantic
 * hits, keeping the strongest passages within a character budget and a
 * per-document cap so one long contract can't crowd out everything else.
 */
export function selectPassages(args: {
  question: string;
  lexical: Passage[];
  semantic: Passage[];
  allowedDocumentIds: ReadonlySet<string>;
  maxPassages?: number;
  maxChars?: number;
  maxPerDocument?: number;
}): Passage[] {
  const { maxPassages = 12, maxChars = 28_000, maxPerDocument = 4 } = args;
  const q = tokens(args.question);
  const scored = new Map<string, { p: Passage; score: number }>();
  const add = (p: Passage, base: number) => {
    if (!args.allowedDocumentIds.has(p.documentId)) return;
    const lex = lexicalScore(q, p.text);
    const sem = p.distance == null ? 0 : Math.max(0, 1 - p.distance) * 10;
    const score = base + lex + sem;
    const prev = scored.get(p.id);
    if (!prev || prev.score < score) scored.set(p.id, { p, score });
  };
  for (const p of args.lexical) add(p, 4);
  for (const p of args.semantic) add(p, 0);

  const ranked = [...scored.values()].sort((a, b) => b.score - a.score);
  const perDoc = new Map<string, number>();
  const out: Passage[] = [];
  let chars = 0;
  for (const { p } of ranked) {
    if (out.length >= maxPassages) break;
    const n = perDoc.get(p.documentId) ?? 0;
    if (n >= maxPerDocument) continue;
    if (chars + p.text.length > maxChars) continue;
    out.push(p);
    perDoc.set(p.documentId, n + 1);
    chars += p.text.length;
  }
  // Present passages of the same document together and in reading order.
  const docOrder = [...new Set(out.map((p) => p.documentId))];
  return out.sort((a, b) => docOrder.indexOf(a.documentId) - docOrder.indexOf(b.documentId) || a.chunkIndex - b.chunkIndex);
}

/** Last few turns of the conversation, clipped, so follow-ups like "zašto?" work. */
export function sanitizeHistory(raw: unknown, maxTurns = 4, maxChars = 600): { q: string; a: string }[] {
  if (!Array.isArray(raw)) return [];
  return raw.slice(-maxTurns).flatMap((t) => {
    if (!t || typeof t !== 'object') return [];
    const q = typeof (t as any).q === 'string' ? (t as any).q.trim().slice(0, maxChars) : '';
    const a = typeof (t as any).a === 'string' ? (t as any).a.trim().slice(0, maxChars) : '';
    return q ? [{ q, a }] : [];
  });
}
