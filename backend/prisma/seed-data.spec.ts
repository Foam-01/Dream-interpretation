import { readFileSync } from 'node:fs';
import { join } from 'node:path';
import { isLocalDatabase } from './seed';
import { seedCategories, seedDreams } from './seed-data';

// The seed must stay identical to the Flutter app's sample data (lib/data/design_data.dart).
// This re-parses the Dart source instead of trusting the hand-maintained TypeScript copy.
const dart = readFileSync(join(__dirname, '..', '..', 'lib', 'data', 'design_data.dart'), 'utf8');

function list(raw: string): string[] {
  return raw.split(',').map((v) => v.trim().replace(/^'|'$/g, ''));
}

const dreamPattern = new RegExp(
  String.raw`Dream\('([a-z-]+)', '([^']*)', '([^']*)', LuckyNumbers\(twoDigit: \[([^\]]*)\], threeDigit: \[([^\]]*)\]\), ` +
    String.raw`\[([^\]]*)\], '([^']*)',\s*'([^']*)',\s*LuckForecast\(money: (\d+), love: (\d+), health: (\d+)\), (true|false), '([^']*)'\)`,
  'g',
);
const dartDreams = [...dart.matchAll(dreamPattern)].map((m) => ({
  id: m[1],
  name: m[2],
  categoryName: m[3],
  twoDigit: list(m[4]),
  threeDigit: list(m[5]),
  digits: list(m[6]),
  short: m[7],
  meaning: m[8],
  luck: [Number(m[9]), Number(m[10]), Number(m[11])],
  isGoodOmen: m[12] === 'true',
  advice: m[13],
}));

describe('seed data vs Flutter source', () => {
  it('parses all 10 dreams from the Dart file', () => {
    expect(dartDreams).toHaveLength(10);
  });

  it('has the same dreams, in the same order, with identical fields', () => {
    const byCategoryId = new Map(seedCategories.map((c) => [c.id, c.name]));
    expect(seedDreams.map((d) => d.id)).toEqual(dartDreams.map((d) => d.id));
    seedDreams.forEach((s, i) => {
      const d = dartDreams[i];
      expect({
        name: s.name,
        categoryName: byCategoryId.get(s.categoryId),
        twoDigit: s.twoDigit,
        threeDigit: s.threeDigit,
        digits: s.digits,
        short: s.short,
        meaning: s.meaning,
        luck: [s.luckMoney, s.luckLove, s.luckHealth],
        isGoodOmen: s.isGoodOmen,
        advice: s.advice,
        sortOrder: s.sortOrder,
      }).toEqual({ ...d, id: undefined, sortOrder: i + 1 });
    });
  });

  it('matches the app category list (excluding the "all" filter value)', () => {
    const cats = /const dreamCats = \[([^\]]*)\]/.exec(dart)![1];
    expect(seedCategories.map((c) => c.name)).toEqual(list(cats).slice(1));
  });
});

describe('seed data integrity', () => {
  it('keeps numbers as fixed-width digit strings (leading zeros preserved)', () => {
    for (const d of seedDreams) {
      for (const n of d.twoDigit) expect(n).toMatch(/^\d{2}$/);
      for (const n of d.threeDigit) expect(n).toMatch(/^\d{3}$/);
      for (const n of d.digits) expect(n).toMatch(/^\d$/);
    }
    const tooth = seedDreams.find((d) => d.id === 'tooth-falling-out')!;
    expect(tooth.twoDigit).toEqual(['08', '80']);
    expect(tooth.threeDigit).toEqual(['098', '809']);
    const dead = seedDreams.find((d) => d.id === 'dead-person')!;
    expect(dead.twoDigit).toEqual(['09', '90']);
    expect(dead.threeDigit).toEqual(['090', '900']);
  });

  it('keeps scores within 0-100 and ids/sort orders unique', () => {
    for (const d of seedDreams) {
      for (const v of [d.luckMoney, d.luckLove, d.luckHealth]) expect(v >= 0 && v <= 100).toBe(true);
    }
    expect(new Set(seedDreams.map((d) => d.id)).size).toBe(seedDreams.length);
    expect(new Set(seedDreams.map((d) => d.sortOrder)).size).toBe(seedDreams.length);
    const catIds = new Set(seedCategories.map((c) => c.id));
    for (const d of seedDreams) expect(catIds.has(d.categoryId)).toBe(true);
  });
});

describe('isLocalDatabase (seed safety guard)', () => {
  it.each([
    ['postgresql://u:p@localhost:5433/db', true],
    ['postgresql://u:p@127.0.0.1/db', true],
    ['postgresql://u:p@ep-x.us-east-2.aws.neon.tech/db?sslmode=require', false],
    ['not a url', false],
  ])('%s -> %s', (url, expected) => {
    expect(isLocalDatabase(url)).toBe(expected);
  });
});
