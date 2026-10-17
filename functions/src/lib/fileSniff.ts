/** Detects the real file type from magic bytes — never trust the extension or declared type. */

export type SniffedType = 'application/pdf' | 'image/jpeg' | 'image/png' | 'image/heic' | 'image/webp' | null;

export function sniffMime(head: Uint8Array): SniffedType {
  const b = head;
  if (b.length >= 5 && b[0] === 0x25 && b[1] === 0x50 && b[2] === 0x44 && b[3] === 0x46 && b[4] === 0x2d) {
    return 'application/pdf'; // %PDF-
  }
  if (b.length >= 3 && b[0] === 0xff && b[1] === 0xd8 && b[2] === 0xff) return 'image/jpeg';
  if (b.length >= 8 && b[0] === 0x89 && b[1] === 0x50 && b[2] === 0x4e && b[3] === 0x47
    && b[4] === 0x0d && b[5] === 0x0a && b[6] === 0x1a && b[7] === 0x0a) return 'image/png';
  if (b.length >= 12 && b[0] === 0x52 && b[1] === 0x49 && b[2] === 0x46 && b[3] === 0x46
    && b[8] === 0x57 && b[9] === 0x45 && b[10] === 0x42 && b[11] === 0x50) return 'image/webp';
  if (b.length >= 12 && b[4] === 0x66 && b[5] === 0x74 && b[6] === 0x79 && b[7] === 0x70) {
    const brand = String.fromCharCode(b[8], b[9], b[10], b[11]);
    if (['heic', 'heix', 'hevc', 'hevx', 'mif1', 'msf1', 'heim', 'heis'].includes(brand)) return 'image/heic';
  }
  return null;
}

/** Declared content types that are compatible with a sniffed type. */
export function isCompatible(declared: string | undefined, sniffed: SniffedType): boolean {
  if (!sniffed || !declared) return false;
  if (sniffed === 'image/heic') return declared === 'image/heic' || declared === 'image/heif';
  return declared === sniffed;
}
