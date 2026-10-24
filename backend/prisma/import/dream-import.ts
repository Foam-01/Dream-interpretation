// Validation of a dream content file (format "dreamapp-dreams/v1"). Pure: no database, no network.
// Every rule here exists so that an import can never silently publish invented, mis-typed or
// unattributed content. See docs/content-import.md.

export const IMPORT_FORMAT = 'dreamapp-dreams/v1';

/** Statuses an import may write. VERIFIED is a separate, reviewed step and never comes from a file. */
export type ImportStatus = 'SAMPLE' | 'DRAFT';

export interface ImportSource {
  id: string;
  title: string;
  author: string | null;
  publisher: string | null;
  edition: string | null;
  year: number | null;
  url: string | null;
  note: string | null;
}

export interface ImportImage {
  url: string;
  alt: string | null;
  credit: string;
  license: string;
  sourceUrl: string | null;
}

export interface ImportDream {
  id: string;
  name: string;
  categoryId: string;
  aliases: string[];
  short: string;
  meaning: string;
  twoDigit: string[];
  threeDigit: string[];
  digits: string[];
  /** The source says "ไม่ควรเสี่ยง": no lucky numbers at all (both lists empty). */
  noLuckyNumbers: boolean;
  advice: string | null;
  isGoodOmen: boolean | null;
  sourceId: string | null;
  sourceLocator: string | null;
  image: ImportImage | null;
  contentStatus: ImportStatus;
  /** True when a text field still holds a template placeholder (only allowed for SAMPLE). */
  hasPlaceholder: boolean;
}

export interface Issue {
  severity: 'error' | 'warning';
  /** JSON path, e.g. dreams[3].numbers.twoDigit[0] */
  path: string;
  message: string;
}

export interface ValidationResult {
  sources: ImportSource[];
  dreams: ImportDream[];
  issues: Issue[];
  stats: {
    sourcesInFile: number;
    dreamsInFile: number;
    validDreams: number;
    invalidDreams: number;
    duplicateIds: number;
    warnings: number;
  };
}

export interface ValidationOptions {
  /** Category ids that exist (from the database in plan/write mode, else the seeded list). */
  categoryIds: ReadonlySet<string>;
  /** Source ids that already exist in the database (may be referenced without being in the file). */
  existingSourceIds?: ReadonlySet<string>;
}

const SLUG = /^[a-z0-9-]{1,64}$/;
const HTTPS_URL = /^https:\/\/[^\s]+$/;
// Zero-width characters break search and sorting while being invisible in editors.
const ZERO_WIDTH = /[​-‍⁠﻿]/;
// NIKHAHIT + SARA AA typed instead of SARA AM (ำ): looks identical, never matches a search for "ำ".
const DECOMPOSED_SARA_AM = /ํา/;
// Template markers: <<...>>, TODO, PLACEHOLDER.
const PLACEHOLDER = /<<[^>]*>>|\bTODO\b|\bPLACEHOLDER\b/i;

const DREAM_KEYS = new Set([
  'id',
  'name',
  'categoryId',
  'aliases',
  'short',
  'meaning',
  'numbers',
  'noLuckyNumbers',
  'digits',
  'advice',
  'isGoodOmen',
  'source',
  'image',
  'contentStatus',
]);
const SOURCE_KEYS = new Set(['id', 'title', 'author', 'publisher', 'edition', 'year', 'url', 'note']);
const IMAGE_KEYS = new Set(['url', 'alt', 'credit', 'license', 'sourceUrl']);

type Obj = Record<string, unknown>;
const isObj = (v: unknown): v is Obj => typeof v === 'object' && v !== null && !Array.isArray(v);

class Checker {
  readonly issues: Issue[] = [];
  error(path: string, message: string): void {
    this.issues.push({ severity: 'error', path, message });
  }
  warn(path: string, message: string): void {
    this.issues.push({ severity: 'warning', path, message });
  }

  unknownKeys(o: Obj, allowed: Set<string>, path: string): void {
    for (const k of Object.keys(o)) {
      if (!allowed.has(k)) this.error(`${path}.${k}`, 'unknown field (check the spelling; see docs/content-import.md)');
    }
  }

  /** Thai-safe text: trimmed, NFC, no zero-width characters, no decomposed SARA AM. */
  text(v: unknown, path: string, { required, max }: { required: boolean; max: number }): string | null {
    if (v === undefined || v === null) {
      if (required) this.error(path, 'is required');
      return null;
    }
    if (typeof v !== 'string') {
      this.error(path, 'must be a string');
      return null;
    }
    if (v.trim().length === 0) {
      this.error(path, required ? 'is required (empty)' : 'must not be empty; omit the field instead');
      return null;
    }
    if (v !== v.trim()) this.error(path, 'has leading or trailing spaces');
    if (v.length > max) this.error(path, `is longer than ${max} characters`);
    if (ZERO_WIDTH.test(v)) this.error(path, 'contains an invisible zero-width character');
    if (DECOMPOSED_SARA_AM.test(v)) this.error(path, 'contains "ํา" (nikhahit + sara aa); type sara am "ำ" instead');
    if (v !== v.normalize('NFC')) this.error(path, 'is not Unicode NFC-normalised');
    return v;
  }

  https(v: unknown, path: string): string | null {
    if (v === undefined || v === null) return null;
    if (typeof v !== 'string' || !HTTPS_URL.test(v)) {
      this.error(path, 'must be an https:// URL without spaces');
      return null;
    }
    try {
      const u = new URL(v);
      if (u.username || u.password) this.error(path, 'must not contain credentials');
      if (u.hostname === 'localhost' || /^\d+\.\d+\.\d+\.\d+$/.test(u.hostname)) {
        this.error(path, 'must use a public host name, not localhost or an IP address');
      }
    } catch {
      this.error(path, 'is not a valid URL');
      return null;
    }
    return v;
  }

  /** Digit strings of a fixed width. A JSON number is rejected: 08 would lose its leading zero. */
  digitStrings(v: unknown, path: string, width: number, { required }: { required: boolean }): string[] {
    if (v === undefined || v === null) {
      if (required) this.error(path, 'is required');
      return [];
    }
    if (!Array.isArray(v)) {
      this.error(path, 'must be an array of strings');
      return [];
    }
    if (required && v.length === 0) this.error(path, 'must not be empty');
    const out: string[] = [];
    v.forEach((n: unknown, i) => {
      const p = `${path}[${i}]`;
      if (typeof n === 'number') {
        this.error(
          p,
          `must be a string such as "${String(n).padStart(width, '0')}", not the number ${n} (leading zeros)`,
        );
      } else if (typeof n !== 'string' || !new RegExp(`^[0-9]{${width}}$`).test(n)) {
        this.error(
          p,
          `must be exactly ${width} ASCII digit${width > 1 ? 's' : ''} as a string (got ${JSON.stringify(n)})`,
        );
      } else if (out.includes(n)) {
        this.error(p, `duplicate number "${n}"`);
      } else {
        out.push(n);
      }
    });
    return out;
  }
}

function placeholderIn(values: Array<string | null | undefined>): boolean {
  return values.some((s) => typeof s === 'string' && PLACEHOLDER.test(s));
}

function validateSource(c: Checker, raw: unknown, path: string): ImportSource | null {
  if (!isObj(raw)) {
    c.error(path, 'must be an object');
    return null;
  }
  c.unknownKeys(raw, SOURCE_KEYS, path);
  const before = c.issues.length;
  const id = typeof raw.id === 'string' && SLUG.test(raw.id) ? raw.id : null;
  if (!id) c.error(`${path}.id`, 'must be a lowercase slug (a-z, 0-9, -)');
  const title = c.text(raw.title, `${path}.title`, { required: true, max: 300 });
  const year = raw.year;
  if (
    year !== undefined &&
    year !== null &&
    !(Number.isInteger(year) && (year as number) >= 1000 && (year as number) <= 3000)
  ) {
    c.error(`${path}.year`, 'must be an integer year between 1000 and 3000 (say in note whether it is B.E. or C.E.)');
  }
  const source: ImportSource = {
    id: id ?? '',
    title: title ?? '',
    author: c.text(raw.author, `${path}.author`, { required: false, max: 200 }),
    publisher: c.text(raw.publisher, `${path}.publisher`, { required: false, max: 200 }),
    edition: c.text(raw.edition, `${path}.edition`, { required: false, max: 100 }),
    year: typeof year === 'number' ? year : null,
    url: c.https(raw.url, `${path}.url`),
    note: c.text(raw.note, `${path}.note`, { required: false, max: 2000 }),
  };
  return c.issues.slice(before).some((i) => i.severity === 'error') ? null : source;
}

function validateImage(c: Checker, raw: unknown, path: string): ImportImage | null {
  if (raw === undefined || raw === null) return null;
  if (!isObj(raw)) {
    c.error(path, 'must be an object or omitted');
    return null;
  }
  c.unknownKeys(raw, IMAGE_KEYS, path);
  const url = c.https(raw.url, `${path}.url`);
  if (raw.url === undefined) c.error(`${path}.url`, 'is required when image is given');
  const credit = c.text(raw.credit, `${path}.credit`, { required: true, max: 300 });
  const license = c.text(raw.license, `${path}.license`, { required: true, max: 100 });
  return url && credit && license
    ? {
        url,
        alt: c.text(raw.alt, `${path}.alt`, { required: false, max: 300 }),
        credit,
        license,
        sourceUrl: c.https(raw.sourceUrl, `${path}.sourceUrl`),
      }
    : null;
}

export function validateImportFile(raw: unknown, options: ValidationOptions): ValidationResult {
  const c = new Checker();
  const sources: ImportSource[] = [];
  const dreams: ImportDream[] = [];
  let dreamsInFile = 0;
  let sourcesInFile = 0;
  let duplicateIds = 0;
  let invalidDreams = 0;

  if (!isObj(raw)) {
    c.error('$', 'the file must contain a JSON object');
  } else {
    c.unknownKeys(raw, new Set(['format', 'sources', 'dreams']), '$');
    if (raw.format !== IMPORT_FORMAT) c.error('$.format', `must be "${IMPORT_FORMAT}"`);

    // Sources
    const rawSources = raw.sources ?? [];
    if (!Array.isArray(rawSources)) c.error('$.sources', 'must be an array');
    const sourceIds = new Map<string, number>();
    (Array.isArray(rawSources) ? rawSources : []).forEach((s: unknown, i) => {
      sourcesInFile++;
      const v = validateSource(c, s, `sources[${i}]`);
      if (!v) return;
      if (sourceIds.has(v.id)) {
        c.error(`sources[${i}].id`, `duplicate source id "${v.id}" (also sources[${sourceIds.get(v.id)}])`);
        return;
      }
      sourceIds.set(v.id, i);
      sources.push(v);
    });
    const placeholderSources = new Set(
      sources.filter((s) => placeholderIn([s.title, s.author, s.publisher, s.edition, s.note])).map((s) => s.id),
    );

    // Dreams
    if (!Array.isArray(raw.dreams) || raw.dreams.length === 0) c.error('$.dreams', 'must be a non-empty array');
    const rawDreams: unknown[] = Array.isArray(raw.dreams) ? raw.dreams : [];
    dreamsInFile = rawDreams.length;
    const idCount = new Map<string, number>();
    for (const d of rawDreams)
      if (isObj(d) && typeof d.id === 'string') idCount.set(d.id, (idCount.get(d.id) ?? 0) + 1);
    const names = new Map<string, number>();

    rawDreams.forEach((d: unknown, i) => {
      const p = `dreams[${i}]`;
      const before = c.issues.length;
      if (!isObj(d)) {
        c.error(p, 'must be an object');
        invalidDreams++;
        return;
      }
      c.unknownKeys(d, DREAM_KEYS, p);

      const id = typeof d.id === 'string' && SLUG.test(d.id) ? d.id : null;
      if (!id) c.error(`${p}.id`, 'must be a stable lowercase slug (a-z, 0-9, -), e.g. "snake"');
      if (id && (idCount.get(id) ?? 0) > 1) {
        c.error(`${p}.id`, `duplicate id "${id}" appears ${idCount.get(id)} times in the file; every copy is rejected`);
        duplicateIds++;
      }

      const status = d.contentStatus;
      if (status === 'VERIFIED') {
        c.error(
          `${p}.contentStatus`,
          'VERIFIED cannot be imported; import as DRAFT and verify in a separate review step',
        );
      } else if (status !== 'DRAFT' && status !== 'SAMPLE') {
        c.error(`${p}.contentStatus`, 'must be "DRAFT" (real content awaiting review) or "SAMPLE" (test/demo data)');
      }

      const name = c.text(d.name, `${p}.name`, { required: true, max: 200 });
      if (name) {
        if (names.has(name)) c.warn(`${p}.name`, `same name as dreams[${names.get(name)}]; is this a duplicate entry?`);
        names.set(name, i);
      }
      const categoryId = typeof d.categoryId === 'string' ? d.categoryId : null;
      if (!categoryId || !SLUG.test(categoryId)) c.error(`${p}.categoryId`, 'must be a category id such as "animal"');
      else if (!options.categoryIds.has(categoryId)) {
        c.error(`${p}.categoryId`, `unknown category "${categoryId}" (known: ${[...options.categoryIds].join(', ')})`);
      }

      const aliases: string[] = [];
      if (d.aliases !== undefined) {
        if (!Array.isArray(d.aliases)) c.error(`${p}.aliases`, 'must be an array of strings');
        else
          d.aliases.forEach((a: unknown, j) => {
            const v = c.text(a, `${p}.aliases[${j}]`, { required: true, max: 200 });
            if (!v) return;
            if (v === name) c.error(`${p}.aliases[${j}]`, 'repeats the name');
            else if (aliases.includes(v)) c.error(`${p}.aliases[${j}]`, `duplicate alias "${v}"`);
            else aliases.push(v);
          });
      }

      // Real content uses the full verbatim meaning as short (no summary is written for it), so allow 500.
      const short = c.text(d.short, `${p}.short`, { required: true, max: 500 });
      const meaning = c.text(d.meaning, `${p}.meaning`, { required: true, max: 5000 });
      const advice = c.text(d.advice, `${p}.advice`, { required: false, max: 2000 });
      if (d.isGoodOmen !== undefined && d.isGoodOmen !== null && typeof d.isGoodOmen !== 'boolean') {
        c.error(`${p}.isGoodOmen`, 'must be true, false or omitted');
      }

      let twoDigit: string[] = [];
      let threeDigit: string[] = [];
      if (d.noLuckyNumbers !== undefined && typeof d.noLuckyNumbers !== 'boolean') {
        c.error(`${p}.noLuckyNumbers`, 'must be true, false or omitted');
      }
      const noLuckyNumbers = d.noLuckyNumbers === true;
      if (noLuckyNumbers) {
        // "ไม่ควรเสี่ยง": the source gives no numbers, so none may be listed (never invented).
        if (d.numbers !== undefined && d.numbers !== null) {
          if (!isObj(d.numbers)) c.error(`${p}.numbers`, 'must be omitted or empty when noLuckyNumbers is true');
          else {
            c.unknownKeys(d.numbers, new Set(['twoDigit', 'threeDigit']), `${p}.numbers`);
            for (const key of ['twoDigit', 'threeDigit'] as const) {
              const v = d.numbers[key];
              if (v !== undefined && !(Array.isArray(v) && v.length === 0)) {
                c.error(`${p}.numbers.${key}`, 'must be empty when noLuckyNumbers is true ("ไม่ควรเสี่ยง")');
              }
            }
          }
        }
      } else if (!isObj(d.numbers)) {
        c.error(`${p}.numbers`, 'must be an object with twoDigit and threeDigit (or set noLuckyNumbers: true)');
      } else {
        c.unknownKeys(d.numbers, new Set(['twoDigit', 'threeDigit']), `${p}.numbers`);
        twoDigit = c.digitStrings(d.numbers.twoDigit, `${p}.numbers.twoDigit`, 2, { required: true });
        threeDigit = c.digitStrings(d.numbers.threeDigit, `${p}.numbers.threeDigit`, 3, { required: true });
      }
      const digits = c.digitStrings(d.digits, `${p}.digits`, 1, { required: false });
      if (noLuckyNumbers && digits.length > 0) c.error(`${p}.digits`, 'must be empty when noLuckyNumbers is true');

      let sourceId: string | null = null;
      let sourceLocator: string | null = null;
      if (d.source === undefined || d.source === null) {
        // Allowed: the content owner decides whether to publish without a citation. Reported so it stays visible.
        if (status === 'DRAFT') c.warn(`${p}.source`, 'no source cited');
      } else if (!isObj(d.source)) {
        c.error(`${p}.source`, 'must be an object { "id": "...", "locator": "..." }');
      } else {
        c.unknownKeys(d.source, new Set(['id', 'locator']), `${p}.source`);
        const sid = d.source.id;
        if (typeof sid !== 'string' || !SLUG.test(sid)) c.error(`${p}.source.id`, 'must be a source id');
        else if (!sourceIds.has(sid) && !options.existingSourceIds?.has(sid)) {
          c.error(`${p}.source.id`, `unknown source "${sid}": add it to "sources" or create it first`);
        } else {
          sourceId = sid;
          if (status === 'DRAFT' && placeholderSources.has(sid)) {
            c.error(`${p}.source.id`, `source "${sid}" still contains template placeholders`);
          }
        }
        sourceLocator = c.text(d.source.locator, `${p}.source.locator`, { required: false, max: 200 });
      }

      const image = validateImage(c, d.image, `${p}.image`);
      const hasPlaceholder =
        placeholderIn([name, short, meaning, advice, ...aliases]) ||
        (image !== null && placeholderIn([image.alt, image.credit, image.license]));
      if (hasPlaceholder && status !== 'SAMPLE') {
        c.error(p, 'contains template placeholders (<<...>>, TODO, PLACEHOLDER); only SAMPLE test data may');
      }

      const ok = !c.issues.slice(before).some((x) => x.severity === 'error');
      if (!ok) {
        invalidDreams++;
        return;
      }
      dreams.push({
        id: id!,
        name: name!,
        categoryId: categoryId!,
        aliases,
        short: short!,
        meaning: meaning!,
        twoDigit,
        threeDigit,
        digits,
        noLuckyNumbers,
        advice,
        isGoodOmen: typeof d.isGoodOmen === 'boolean' ? d.isGoodOmen : null,
        sourceId,
        sourceLocator,
        image,
        contentStatus: status as ImportStatus,
        hasPlaceholder,
      });
    });
  }

  return {
    sources,
    dreams,
    issues: c.issues,
    stats: {
      sourcesInFile,
      dreamsInFile,
      validDreams: dreams.length,
      invalidDreams,
      duplicateIds,
      warnings: c.issues.filter((i) => i.severity === 'warning').length,
    },
  };
}
