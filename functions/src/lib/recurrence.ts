/**
 * Timezone-aware reminder recurrence. A reminder's dueAt is an absolute
 * instant; repeats keep the same local wall-clock time in the reminder's IANA
 * timezone (so a 09:00 Belgrade reminder stays 09:00 across DST changes).
 */

export type RepeatRule = 'none' | 'daily' | 'weekly' | 'monthly' | 'yearly';

interface Parts { y: number; mo: number; d: number; h: number; mi: number; s: number }

function partsInZone(instant: number, timeZone: string): Parts {
  const f = new Intl.DateTimeFormat('en-US', {
    timeZone, hourCycle: 'h23', year: 'numeric', month: '2-digit', day: '2-digit',
    hour: '2-digit', minute: '2-digit', second: '2-digit',
  });
  const p: Record<string, number> = {};
  for (const x of f.formatToParts(new Date(instant))) {
    if (x.type !== 'literal') p[x.type] = Number(x.value);
  }
  return { y: p.year, mo: p.month, d: p.day, h: p.hour, mi: p.minute, s: p.second };
}

/** Offset (ms) of `timeZone` from UTC at a given instant. */
function offsetAt(instant: number, timeZone: string): number {
  const p = partsInZone(instant, timeZone);
  const asUtc = Date.UTC(p.y, p.mo - 1, p.d, p.h, p.mi, p.s);
  return asUtc - Math.floor(instant / 1000) * 1000;
}

/** Converts a local wall-clock time in `timeZone` to an absolute instant. */
export function zonedTimeToInstant(p: Parts, timeZone: string): number {
  const guess = Date.UTC(p.y, p.mo - 1, p.d, p.h, p.mi, p.s);
  let instant = guess - offsetAt(guess, timeZone);
  // Second pass handles instants close to a DST transition.
  instant = guess - offsetAt(instant, timeZone);
  return instant;
}

function daysInMonth(y: number, mo: number): number {
  return new Date(Date.UTC(y, mo, 0)).getUTCDate();
}

function addPeriod(p: Parts, rule: RepeatRule, n: number): Parts {
  const out = { ...p };
  switch (rule) {
    case 'daily': {
      const t = new Date(Date.UTC(p.y, p.mo - 1, p.d + n));
      return { ...out, y: t.getUTCFullYear(), mo: t.getUTCMonth() + 1, d: t.getUTCDate() };
    }
    case 'weekly': {
      const t = new Date(Date.UTC(p.y, p.mo - 1, p.d + 7 * n));
      return { ...out, y: t.getUTCFullYear(), mo: t.getUTCMonth() + 1, d: t.getUTCDate() };
    }
    case 'monthly': {
      const total = p.y * 12 + (p.mo - 1) + n;
      const y = Math.floor(total / 12);
      const mo = (total % 12) + 1;
      // Clamp e.g. Jan 31 -> Feb 28/29.
      return { ...out, y, mo, d: Math.min(p.d, daysInMonth(y, mo)) };
    }
    case 'yearly': {
      const y = p.y + n;
      return { ...out, y, d: Math.min(p.d, daysInMonth(y, p.mo)) };
    }
    default:
      return out;
  }
}

/**
 * Next occurrence strictly after `after` (epoch ms), anchored at `dueAt`.
 * Returns null for non-repeating reminders.
 */
export function nextOccurrence(dueAt: number, rule: RepeatRule, timeZone: string, after: number): number | null {
  if (rule === 'none') return null;
  const base = partsInZone(dueAt, timeZone);
  for (let n = 1; n < 100000; n++) {
    const candidate = zonedTimeToInstant(addPeriod(base, rule, n), timeZone);
    if (candidate > after) return candidate;
  }
  return null;
}

export function isValidTimeZone(tz: string): boolean {
  try {
    new Intl.DateTimeFormat('en-US', { timeZone: tz });
    return true;
  } catch {
    return false;
  }
}
