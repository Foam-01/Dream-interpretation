import { dailyPick, dailySeed, mulberry32 } from './daily-pick';

const ids = Array.from({ length: 114 }, (_, i) => `d${String(i).padStart(3, '0')}`);

describe('dailySeed', () => {
  it('turns a calendar date into yyyymmdd', () => {
    expect(dailySeed('2026-10-30')).toBe(20261030);
  });

  it.each(['2026-02-30', '2026-13-01', '26-10-30', '2026-10-30T00:00', ''])('rejects %p', (date) => {
    expect(dailySeed(date)).toBeNull();
  });
});

describe('dailyPick', () => {
  // Same pin as the app (test/daily_pick_test.dart): both sides must draw the same ids for the same day.
  it('matches the app draw for 2026-10-30', () => {
    expect(dailyPick(ids, 20261030, 3)).toEqual(['d001', 'd016', 'd062']);
  });

  it('is the same for any source order', () => {
    expect(dailyPick([...ids].reverse(), 20261030, 10)).toEqual(dailyPick(ids, 20261030, 10));
  });

  it('gives distinct ids, and a different draw on another day', () => {
    const a = dailyPick(ids, 20261030, 10);
    expect(new Set(a).size).toBe(10);
    expect(dailyPick(ids, 20261031, 10)).not.toEqual(a);
  });

  it('returns everything when there are fewer ids than asked', () => {
    expect(new Set(dailyPick(['a', 'b', 'c'], 20261030, 10))).toEqual(new Set(['a', 'b', 'c']));
  });

  it('produces unsigned 32-bit numbers', () => {
    const next = mulberry32(20261030);
    for (let i = 0; i < 100; i++) {
      const v = next();
      expect(Number.isInteger(v) && v >= 0 && v <= 0xffffffff).toBe(true);
    }
  });
});
