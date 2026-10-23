import type { DreamWithRelations } from './dream.mapper';
import { toDreamDetail, toDreamSummary } from './dream.mapper';

const base: DreamWithRelations = {
  id: 'example-dream',
  name: 'ตัวอย่าง',
  categoryId: 'animal',
  category: { id: 'animal', name: 'สัตว์', sortOrder: 1, createdAt: new Date(0), updatedAt: new Date(0) },
  short: 's',
  meaning: 'm',
  advice: null,
  isGoodOmen: null,
  digits: [],
  twoDigit: ['01'],
  threeDigit: ['001'],
  noLuckyNumbers: false,
  luckMoney: null,
  luckLove: null,
  luckHealth: null,
  aliases: ['ตัวอย่างอื่น'],
  sourceId: null,
  source: null,
  sourceLocator: null,
  imageUrl: null,
  imageAlt: null,
  imageCredit: null,
  imageLicense: null,
  imageSourceUrl: null,
  contentStatus: 'VERIFIED',
  sortOrder: 11,
  createdAt: new Date(0),
  updatedAt: new Date(0),
};

describe('dream mapper', () => {
  it('maps sourced content without optional fields to nulls (never invented values)', () => {
    const d = toDreamDetail(base);
    expect(d).toMatchObject({
      advice: null,
      isGoodOmen: null,
      digits: [],
      luckForecast: null,
      image: null,
      source: null,
      aliases: ['ตัวอย่างอื่น'],
      numbers: { twoDigit: ['01'], threeDigit: ['001'] },
    });
  });

  it('maps an image with its attribution', () => {
    const s = toDreamSummary({
      ...base,
      imageUrl: 'https://img.example/x.jpg',
      imageAlt: 'alt',
      imageCredit: 'ช่างภาพ',
      imageLicense: 'CC BY 4.0',
      imageSourceUrl: 'https://img.example/page',
    });
    expect(s.image).toEqual({
      url: 'https://img.example/x.jpg',
      alt: 'alt',
      credit: 'ช่างภาพ',
      license: 'CC BY 4.0',
      sourceUrl: 'https://img.example/page',
    });
  });

  it('maps the source citation with the page locator', () => {
    const d = toDreamDetail({
      ...base,
      sourceId: 'src',
      sourceLocator: 'หน้า 12',
      source: {
        id: 'src',
        title: 'ชื่อตำรา',
        author: null,
        publisher: null,
        edition: null,
        year: 2510,
        url: null,
        note: 'internal note',
        createdAt: new Date(0),
        updatedAt: new Date(0),
      },
    });
    expect(d.source).toEqual({
      id: 'src',
      title: 'ชื่อตำรา',
      author: null,
      publisher: null,
      edition: null,
      year: 2510,
      url: null,
      locator: 'หน้า 12',
    });
  });

  it('keeps forecast scores when all three are present', () => {
    expect(toDreamDetail({ ...base, luckMoney: 1, luckLove: 0, luckHealth: 100 }).luckForecast).toEqual({
      money: 1,
      love: 0,
      health: 100,
    });
  });

  it('refuses to map DRAFT content', () => {
    expect(() => toDreamSummary({ ...base, contentStatus: 'DRAFT' })).toThrow(/DRAFT/);
  });
});
