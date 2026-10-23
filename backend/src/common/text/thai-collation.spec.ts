import { compareThai, hasThaiCollation } from './thai-collation';

const sortNames = (names: string[]) =>
  names
    .map((name, i) => ({ name, id: `id-${i}` }))
    .sort(compareThai)
    .map((x) => x.name);

describe('compareThai (ก–ฮ dictionary order)', () => {
  it('has Thai collation data in this runtime', () => {
    expect(hasThaiCollation()).toBe(true);
  });

  it('orders by initial consonant, ignoring leading vowels (เ แ โ ใ ไ)', () => {
    expect(sortNames(['เสือ', 'ไก่', 'แมว', 'งู', 'โลง', 'ฮิปโป', 'กา', 'อีกา'])).toEqual([
      'กา',
      'ไก่',
      'งู',
      'แมว',
      'โลง',
      'เสือ',
      'อีกา',
      'ฮิปโป',
    ]);
  });

  it('puts a following consonant before a following vowel and treats tone marks as secondary', () => {
    expect(sortNames(['กา', 'ก้อนหิน', 'กิ่งไม้', 'ขา', 'ข้าว'])).toEqual(['ก้อนหิน', 'กา', 'กิ่งไม้', 'ขา', 'ข้าว']);
  });

  it('is not code-point order', () => {
    const names = ['เสือ', 'ฮิปโป', 'กา'];
    expect(sortNames(names)).not.toEqual([...names].sort());
  });

  it('breaks ties between equal names by id', () => {
    const items = [
      { name: 'งู', id: 'b' },
      { name: 'งู', id: 'a' },
    ];
    expect(items.sort(compareThai).map((x) => x.id)).toEqual(['a', 'b']);
  });
});
