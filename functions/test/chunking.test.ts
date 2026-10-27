import { describe, expect, it } from 'vitest';
import { chunkText, cleanText, lexicalScore, Passage, sanitizeHistory, selectPassages } from '../src/ai/chunking';
import { tokens } from '../src/ai/catalog';

const para = (n: number) => Array.from({ length: n }, (_, i) => `Rečenica broj ${i} opisuje nalaz pacijenta.`).join(' ');

describe('chunking', () => {
  it('keeps short text as one passage', () => {
    expect(chunkText('Kratak tekst.')).toEqual(['Kratak tekst.']);
    expect(chunkText('   \n  ')).toEqual([]);
  });

  it('splits long text into overlapping passages that cover everything', () => {
    const text = para(200);
    const chunks = chunkText(text, 1200, 200);
    expect(chunks.length).toBeGreaterThan(5);
    for (const c of chunks) expect(c.length).toBeLessThanOrEqual(1200);
    // Every sentence survives in some passage.
    for (let i = 0; i < 200; i += 17) expect(chunks.some((c) => c.includes(`broj ${i} `))).toBe(true);
    // Neighbouring passages overlap so a sentence on the boundary isn't cut in half everywhere.
    expect(chunks[1].slice(0, 40).split(' ').slice(1, 3).every((w) => chunks[0].includes(w))).toBe(true);
  });

  it('caps the number of passages per document', () => {
    expect(chunkText(para(5000), 1200, 200, 10)).toHaveLength(10);
  });

  it('cleans whitespace but keeps paragraphs', () => {
    expect(cleanText('a \t b\r\n\r\n\r\n\r\nc')).toBe('a b\n\nc');
  });
});

describe('passage selection', () => {
  const p = (documentId: string, chunkIndex: number, text: string, distance?: number): Passage =>
    ({ id: `${documentId}_${chunkIndex}`, documentId, chunkIndex, text, distance });

  it('finds a passage by a name in Serbian case forms', () => {
    const q = tokens('Zašto je Sergej došao kod doktora Doronjskog?');
    expect(lexicalScore(q, 'Pregled: dr Doronjski. Pacijent Sergej, 7 god.')).toBeGreaterThan(0);
  });

  it('never returns passages from documents the user may not read', () => {
    const out = selectPassages({
      question: 'zašto je došao',
      lexical: [p('mine', 0, 'Anamneza: kašalj tri dana')],
      semantic: [p('private-of-other', 0, 'Anamneza: temperatura', 0.1)],
      allowedDocumentIds: new Set(['mine']),
    });
    expect(out.map((x) => x.documentId)).toEqual(['mine']);
  });

  it('prefers name matches, limits per document and keeps reading order', () => {
    const semantic = Array.from({ length: 10 }, (_, i) => p('long', i, `ugovor član ${i}`, 0.3));
    const out = selectPassages({
      question: 'Doronjski anamneza',
      lexical: [p('report', 1, 'Doronjski: anamneza — kašalj i temperatura'), p('report', 0, 'Izveštaj lekara specijaliste')],
      semantic,
      allowedDocumentIds: new Set(['report', 'long']),
      maxPerDocument: 4,
    });
    expect(out[0].documentId).toBe('report');
    expect(out.filter((x) => x.documentId === 'report').map((x) => x.chunkIndex)).toEqual([0, 1]);
    expect(out.filter((x) => x.documentId === 'long')).toHaveLength(4);
  });

  it('respects the character budget', () => {
    const big = 'x'.repeat(10_000);
    const out = selectPassages({
      question: 'x', lexical: [], semantic: [p('a', 0, big, 0.1), p('b', 0, big, 0.2), p('c', 0, big, 0.3)],
      allowedDocumentIds: new Set(['a', 'b', 'c']), maxChars: 25_000,
    });
    expect(out).toHaveLength(2);
  });
});

describe('conversation history', () => {
  it('keeps the last turns, clipped, and drops junk', () => {
    const h = sanitizeHistory([{ q: 'prvo', a: 'x' }, null, { q: '', a: 'y' }, { q: 'zašto?', a: 'a'.repeat(2000) }, 5], 5, 600);
    expect(h).toEqual([{ q: 'prvo', a: 'x' }, { q: 'zašto?', a: 'a'.repeat(600) }]);
    expect(sanitizeHistory('nope')).toEqual([]);
  });
});
