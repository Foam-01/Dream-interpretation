// Thai dictionary order (ก–ฮ) via ICU, which Node ships in full (no extra dependency).
// PostgreSQL ordering is not used for this: the default/"C" collation sorts by code point
// (leading vowels such as เ แ โ ใ ไ land after ฮ), and ICU collations depend on how the
// database was created (e.g. unavailable for a WIN874 database).
const collator = new Intl.Collator('th', { usage: 'sort', sensitivity: 'variant' });

/** True when the runtime's ICU has Thai collation data. */
export function hasThaiCollation(): boolean {
  return Intl.Collator.supportedLocalesOf(['th']).length > 0;
}

/** Compares names in Thai dictionary order; equal names fall back to the stable id. */
export function compareThai(a: { name: string; id: string }, b: { name: string; id: string }): number {
  return collator.compare(a.name, b.name) || (a.id < b.id ? -1 : a.id > b.id ? 1 : 0);
}
