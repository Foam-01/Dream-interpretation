/**
 * "ฝันยอดฮิตวันนี้": a fixed random draw per day, the same for every caller.
 *
 * Must stay identical to the app's `lib/state/daily_pick.dart` (`dailyPick`): ids in plain code-unit order,
 * Mulberry32 seeded with yyyymmdd, partial Fisher–Yates over the first `count` slots. Both sides pin the
 * same expected draw in their tests, so a change on one side fails there.
 */

/** `2026-11-08` → 20261108; null when the text is not a real calendar date. */
export function dailySeed(date: string): number | null {
  const m = /^(\d{4})-(\d{2})-(\d{2})$/.exec(date);
  if (!m) return null;
  const [y, mo, d] = [Number(m[1]), Number(m[2]), Number(m[3])];
  const check = new Date(Date.UTC(y, mo - 1, d));
  if (check.getUTCFullYear() !== y || check.getUTCMonth() !== mo - 1 || check.getUTCDate() !== d) return null;
  return y * 10000 + mo * 100 + d;
}

/** Mulberry32: unsigned 32-bit results, the same sequence as the app's Dart port. */
export function mulberry32(seed: number): () => number {
  let s = seed >>> 0;
  return () => {
    s = (s + 0x6d2b79f5) >>> 0;
    let t = Math.imul(s ^ (s >>> 15), s | 1);
    t = (t ^ (t + Math.imul(t ^ (t >>> 7), t | 61))) >>> 0;
    return (t ^ (t >>> 14)) >>> 0;
  };
}

/** `count` ids drawn for the day with this seed; source order does not matter. */
export function dailyPick(ids: readonly string[], seed: number, count: number): string[] {
  const next = mulberry32(seed);
  // Code-unit order, as Dart's String.compareTo (not locale or database collation).
  const pool = [...ids].sort((a, b) => (a < b ? -1 : a > b ? 1 : 0));
  const n = Math.min(count, pool.length);
  for (let i = 0; i < n; i++) {
    const j = i + (next() % (pool.length - i));
    [pool[i], pool[j]] = [pool[j], pool[i]];
  }
  return pool.slice(0, n);
}
