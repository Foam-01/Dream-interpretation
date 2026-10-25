import { readFileSync } from 'node:fs';
import { join } from 'node:path';
import { IMPORT_FORMAT, validateImportFile, type ValidationResult } from './dream-import';
import { planImport, type Snapshot } from './dream-import.db';
import { allCategories } from '../seed-data';
import { checkTarget, parseArgs, UsageError } from './import-dreams';

const categoryIds = new Set(['animal', 'body', 'nature', 'person', 'object']);
const source = { id: 'real-book', title: 'ตำราทำนายฝัน (ตัวอย่างชื่อในการทดสอบ)', year: 2510 };

function dream(over: Record<string, unknown> = {}): Record<string, unknown> {
  return {
    id: 'snake-real',
    name: 'งู',
    categoryId: 'animal',
    short: 'สรุป',
    meaning: 'คำทำนาย',
    numbers: { twoDigit: ['08'], threeDigit: ['098'] },
    source: { id: 'real-book', locator: 'หน้า 1' },
    contentStatus: 'DRAFT',
    ...over,
  };
}

function validate(dreams: unknown[], extra: Record<string, unknown> = {}): ValidationResult {
  return validateImportFile({ format: IMPORT_FORMAT, sources: [source], dreams, ...extra }, { categoryIds });
}

const errors = (v: ValidationResult) =>
  v.issues.filter((i) => i.severity === 'error').map((i) => `${i.path}: ${i.message}`);

describe('validateImportFile', () => {
  it('accepts a minimal DRAFT record and keeps numbers as strings', () => {
    const v = validate([dream()]);
    expect(errors(v)).toEqual([]);
    expect(v.dreams[0]).toMatchObject({
      twoDigit: ['08'],
      threeDigit: ['098'],
      digits: [],
      advice: null,
      isGoodOmen: null,
      image: null,
      aliases: [],
      sourceId: 'real-book',
      sourceLocator: 'หน้า 1',
      contentStatus: 'DRAFT',
    });
    expect(v.stats).toMatchObject({ dreamsInFile: 1, validDreams: 1, invalidDreams: 0, duplicateIds: 0 });
  });

  it('validates the committed template file', () => {
    const raw = JSON.parse(
      readFileSync(join(__dirname, '..', '..', 'content', 'templates', 'dreams.template.json'), 'utf8'),
    );
    const v = validateImportFile(raw, { categoryIds });
    expect(errors(v)).toEqual([]);
    expect(v.dreams.every((d) => d.contentStatus === 'SAMPLE' && d.id.startsWith('template-test-'))).toBe(true);
  });

  it('rejects numbers given as JSON numbers (leading zero would be lost)', () => {
    const v = validate([dream({ numbers: { twoDigit: [8], threeDigit: ['098'] } })]);
    expect(errors(v)).toEqual([
      'dreams[0].numbers.twoDigit[0]: must be a string such as "08", not the number 8 (leading zeros)',
    ]);
  });

  it.each([
    [{ twoDigit: ['8'], threeDigit: ['098'] }, 'numbers.twoDigit[0]'],
    [{ twoDigit: ['080'], threeDigit: ['098'] }, 'numbers.twoDigit[0]'],
    [{ twoDigit: ['08'], threeDigit: ['98'] }, 'numbers.threeDigit[0]'],
    [{ twoDigit: ['๐๘'], threeDigit: ['098'] }, 'numbers.twoDigit[0]'],
    [{ twoDigit: [], threeDigit: ['098'] }, 'numbers.twoDigit'],
    [{ twoDigit: ['08', '08'], threeDigit: ['098'] }, 'numbers.twoDigit[1]'],
    [{ twoDigit: ['08'] }, 'numbers.threeDigit'],
  ])('rejects bad numbers %j', (numbers, path) => {
    expect(errors(validate([dream({ numbers })])).join('\n')).toContain(`dreams[0].${path}`);
  });

  it('rejects duplicate ids (every copy) and counts them', () => {
    const v = validate([dream(), dream({ name: 'งูใหญ่' })]);
    expect(v.stats).toMatchObject({ validDreams: 0, invalidDreams: 2, duplicateIds: 2 });
  });

  it('warns about the same name twice', () => {
    const v = validate([dream(), dream({ id: 'snake-2' })]);
    expect(errors(v)).toEqual([]);
    expect(v.issues.filter((i) => i.severity === 'warning').map((i) => i.path)).toEqual(['dreams[1].name']);
  });

  it('never imports VERIFIED', () => {
    expect(errors(validate([dream({ contentStatus: 'VERIFIED' })]))[0]).toMatch(/VERIFIED cannot be imported/);
  });

  it('allows content without a cited source (warning), but rejects an unknown source id', () => {
    const v = validate([dream({ source: undefined })]);
    expect(errors(v)).toEqual([]);
    expect(v.issues).toContainEqual({ severity: 'warning', path: 'dreams[0].source', message: 'no source cited' });
    expect(errors(validate([dream({ source: { id: 'missing' } })]))[0]).toMatch(/unknown source "missing"/);
  });

  it('accepts "ไม่ควรเสี่ยง" only as noLuckyNumbers with no numbers at all', () => {
    const none = validate([dream({ noLuckyNumbers: true, numbers: { twoDigit: [], threeDigit: [] } })]);
    expect(errors(none)).toEqual([]);
    expect(none.dreams[0]).toMatchObject({ noLuckyNumbers: true, twoDigit: [], threeDigit: [] });
    expect(errors(validate([dream({ noLuckyNumbers: true, numbers: undefined })]))).toEqual([]);
    expect(errors(validate([dream({ noLuckyNumbers: true })]))[0]).toMatch(/must be empty when noLuckyNumbers/);
    expect(errors(validate([dream({ noLuckyNumbers: true, numbers: undefined, digits: ['1'] })]))[0]).toMatch(/digits/);
    expect(errors(validate([dream({ noLuckyNumbers: 'yes' })]))[0]).toMatch(/noLuckyNumbers: must be true/);
    expect(validate([dream()]).dreams[0].noLuckyNumbers).toBe(false);
  });

  it('accepts two-digit-only numbers but never an empty two-digit list', () => {
    const twoOnly = validate([dream({ numbers: { twoDigit: ['33'], threeDigit: [] } })]);
    expect(errors(twoOnly)).toEqual([]);
    expect(twoOnly.dreams[0]).toMatchObject({ noLuckyNumbers: false, twoDigit: ['33'], threeDigit: [] });
    expect(errors(validate([dream({ numbers: { twoDigit: [], threeDigit: ['123'] } })]))[0]).toMatch(
      /twoDigit: must not be empty/,
    );
  });

  it('accepts a source that already exists in the database', () => {
    const v = validateImportFile(
      { format: IMPORT_FORMAT, dreams: [dream({ source: { id: 'in-db' } })] },
      { categoryIds, existingSourceIds: new Set(['in-db']) },
    );
    expect(errors(v)).toEqual([]);
  });

  it('rejects template placeholders in DRAFT content (allowed only for SAMPLE)', () => {
    expect(errors(validate([dream({ meaning: '<<คำทำนาย>>' })])).join('\n')).toMatch(/placeholders/);
    expect(errors(validate([dream({ meaning: '<<คำทำนาย>>', contentStatus: 'SAMPLE' })]))).toEqual([]);
    const placeholderSource = { id: 'real-book', title: '<<ชื่อหนังสือ>>' };
    expect(errors(validate([dream()], { sources: [placeholderSource] })).join('\n')).toMatch(/template placeholders/);
  });

  it('checks the category against known ids', () => {
    expect(errors(validate([dream({ categoryId: 'plant' })]))[0]).toMatch(/unknown category "plant"/);
  });

  it.each([
    ['leading space', ' งู', /leading or trailing spaces/],
    ['zero-width space', 'งู​', /zero-width/],
    ['decomposed sara am', 'นํา', /sara am/],
    ['empty', '', /required/],
    ['number', 5, /must be a string/],
  ])('rejects a name with %s', (_label, name, message) => {
    expect(errors(validate([dream({ name })])).join('\n')).toMatch(message);
  });

  it('rejects unknown fields (typos) and forecast scores', () => {
    const v = validate([dream({ meanign: 'x', luckForecast: { money: 1 } })]);
    expect(errors(v)).toEqual([
      'dreams[0].meanign: unknown field (check the spelling; see docs/content-import.md)',
      'dreams[0].luckForecast: unknown field (check the spelling; see docs/content-import.md)',
    ]);
  });

  it('requires https and attribution for images', () => {
    const ok = { url: 'https://img.example.org/a.jpg', credit: 'ช่างภาพ', license: 'CC BY 4.0' };
    expect(errors(validate([dream({ image: ok })]))).toEqual([]);
    expect(errors(validate([dream({ image: { ...ok, url: 'http://img.example.org/a.jpg' } })]))[0]).toMatch(/https/);
    expect(errors(validate([dream({ image: { ...ok, url: 'https://127.0.0.1/a.jpg' } })]))[0]).toMatch(/public host/);
    expect(errors(validate([dream({ image: { url: ok.url } })])).join('\n')).toMatch(
      /credit: is required[\s\S]*license/,
    );
  });

  it('validates aliases', () => {
    expect(errors(validate([dream({ aliases: ['อสรพิษ'] })]))).toEqual([]);
    expect(errors(validate([dream({ aliases: ['งู'] })]))[0]).toMatch(/repeats the name/);
    expect(errors(validate([dream({ aliases: ['ก', 'ก'] })]))[0]).toMatch(/duplicate alias/);
  });

  it('rejects a wrong format tag and a non-object file', () => {
    expect(errors(validateImportFile({ format: 'x', dreams: [dream()] }, { categoryIds }))[0]).toMatch(/format/);
    expect(errors(validateImportFile([], { categoryIds }))[0]).toMatch(/JSON object/);
  });
});

describe('planImport', () => {
  const valid = validate([dream(), dream({ id: 'tiger-real', name: 'เสือ' })]);
  const existing = (status: 'SAMPLE' | 'DRAFT' | 'VERIFIED', over: Record<string, unknown> = {}) => ({
    ...valid.dreams[0],
    contentStatus: status,
    ...over,
  });
  const snap = (dreams: Snapshot['dreams']): Snapshot => ({ categoryIds, sources: new Map(), dreams });

  it('creates new rows and leaves identical rows unchanged', () => {
    const plan = planImport(valid, snap(new Map([['snake-real', existing('DRAFT')]])), { update: false });
    expect(plan.map((p) => `${p.kind}:${p.id}:${p.action}`)).toEqual([
      'source:real-book:create',
      'dream:snake-real:unchanged',
      'dream:tiger-real:create',
    ]);
  });

  it('reports a changed DRAFT as a conflict unless --update', () => {
    const s = snap(new Map([['snake-real', existing('DRAFT', { meaning: 'เดิม' })]]));
    expect(planImport(valid, s, { update: false })[1]).toMatchObject({ action: 'conflict', changed: ['meaning'] });
    expect(planImport(valid, s, { update: true })[1]).toMatchObject({ action: 'update', changed: ['meaning'] });
  });

  it('never changes VERIFIED or seed SAMPLE rows, even with --update', () => {
    for (const status of ['VERIFIED', 'SAMPLE'] as const) {
      const s = snap(new Map([['snake-real', existing(status, { meaning: 'เดิม' })]]));
      expect(planImport(valid, s, { update: true })[1].action).toBe('protected');
    }
  });
});

describe('importer CLI guards', () => {
  it('defaults to validate-only and requires --file', () => {
    expect(parseArgs(['--file', 'a.json'])).toEqual({
      file: 'a.json',
      plan: false,
      write: false,
      update: false,
      allowRemoteHost: null,
    });
    expect(() => parseArgs([])).toThrow(UsageError);
    expect(() => parseArgs(['--file', 'a.json', '--delete'])).toThrow(/unknown argument/);
  });

  it('refuses a missing DATABASE_URL and remote hosts unless named exactly', () => {
    expect(() => checkTarget(undefined, { allowRemoteHost: null, write: false })).toThrow(/never reads backend\/.env/);
    const remote = 'postgresql://u:secret@ep-x.neon.tech/db';
    expect(() => checkTarget(remote, { allowRemoteHost: null, write: true })).toThrow(
      /--allow-remote-host=ep-x.neon.tech/,
    );
    expect(() => checkTarget(remote, { allowRemoteHost: 'other.host', write: true })).toThrow(/refusing/);
    expect(checkTarget(remote, { allowRemoteHost: 'ep-x.neon.tech', write: true })).toEqual({
      host: 'ep-x.neon.tech',
      remote: true,
    });
    expect(checkTarget('postgresql://u:p@localhost:5433/db', { allowRemoteHost: null, write: true }).remote).toBe(
      false,
    );
  });

  it('never puts the password in guard messages', () => {
    try {
      checkTarget('postgresql://u:secret@ep-x.neon.tech/db', { allowRemoteHost: null, write: true });
    } catch (e) {
      expect((e as Error).message).not.toContain('secret');
    }
  });
});

describe('หมวด ก import file (backend/content/incoming/category-01-k/dreams.json)', () => {
  const raw = JSON.parse(
    readFileSync(join(__dirname, '..', '..', 'content', 'incoming', 'category-01-k', 'dreams.json'), 'utf8'),
  );
  const v = validateImportFile(raw, { categoryIds: new Set(allCategories.map((c) => c.id)) });

  it('has 33 records in the letter-k category and no images', () => {
    expect(v.stats.dreamsInFile).toBe(33);
    expect((raw.dreams as Array<Record<string, unknown>>).every((d) => d.categoryId === 'letter-k')).toBe(true);
    expect((raw.dreams as Array<Record<string, unknown>>).some((d) => 'image' in d)).toBe(false);
  });

  it('validates: 4 "ไม่ควรเสี่ยง" entries, no source cited (warnings only)', () => {
    expect(v.issues.filter((i) => i.severity === 'error')).toEqual([]);
    expect(v.dreams.filter((d) => d.noLuckyNumbers).map((d) => d.id)).toEqual([
      'k-jaw',
      'k-lost-key',
      'k-cart-passing',
      'k-growing-old',
    ]);
    expect(v.issues.filter((i) => i.message === 'no source cited')).toHaveLength(33);
  });
});
