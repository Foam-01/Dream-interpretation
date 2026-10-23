// Database side of the dream import: read a snapshot, compute a plan, apply it.
// Nothing is ever deleted. Rows that are VERIFIED or owned by the seed (SAMPLE) are never changed.
import type { PrismaClient } from '../../generated/prisma/client';
import type { ImportDream, ImportSource, ValidationResult } from './dream-import';

export type Action = 'create' | 'update' | 'unchanged' | 'conflict' | 'protected';

export interface PlanItem {
  kind: 'source' | 'dream';
  id: string;
  action: Action;
  /** Fields that differ from the database (update/conflict). */
  changed?: string[];
  reason?: string;
}

export interface Snapshot {
  categoryIds: Set<string>;
  sources: Map<string, ImportSource>;
  dreams: Map<string, Omit<ImportDream, 'contentStatus'> & { contentStatus: 'SAMPLE' | 'DRAFT' | 'VERIFIED' }>;
}

export interface PlanOptions {
  /** Allow changing existing DRAFT dreams and existing sources whose fields differ. Default: report a conflict. */
  update: boolean;
}

type ExistingDream = Snapshot['dreams'] extends Map<string, infer V> ? V : never;

export async function loadCategoryIds(prisma: PrismaClient): Promise<Set<string>> {
  return new Set((await prisma.dreamCategory.findMany({ select: { id: true } })).map((c) => c.id));
}

/** Reads only the rows the file mentions (read-only). */
export async function loadSnapshot(prisma: PrismaClient, sourceIds: string[], dreamIds: string[]): Promise<Snapshot> {
  const [categoryIds, sources, dreams] = await Promise.all([
    loadCategoryIds(prisma),
    prisma.contentSource.findMany({ where: { id: { in: sourceIds } } }),
    prisma.dream.findMany({ where: { id: { in: dreamIds } } }),
  ]);
  return {
    categoryIds,
    sources: new Map(
      sources.map((s) => [
        s.id,
        {
          id: s.id,
          title: s.title,
          author: s.author,
          publisher: s.publisher,
          edition: s.edition,
          year: s.year,
          url: s.url,
          note: s.note,
        },
      ]),
    ),
    dreams: new Map(
      dreams.map((d) => [
        d.id,
        {
          id: d.id,
          name: d.name,
          categoryId: d.categoryId,
          aliases: d.aliases,
          short: d.short,
          meaning: d.meaning,
          twoDigit: d.twoDigit,
          threeDigit: d.threeDigit,
          digits: d.digits,
          noLuckyNumbers: d.noLuckyNumbers,
          advice: d.advice,
          isGoodOmen: d.isGoodOmen,
          sourceId: d.sourceId,
          sourceLocator: d.sourceLocator,
          image: d.imageUrl
            ? {
                url: d.imageUrl,
                alt: d.imageAlt,
                credit: d.imageCredit ?? '',
                license: d.imageLicense ?? '',
                sourceUrl: d.imageSourceUrl,
              }
            : null,
          contentStatus: d.contentStatus,
          hasPlaceholder: false,
        } satisfies ExistingDream,
      ]),
    ),
  };
}

const DREAM_FIELDS = [
  'name',
  'categoryId',
  'aliases',
  'short',
  'meaning',
  'twoDigit',
  'threeDigit',
  'digits',
  'noLuckyNumbers',
  'advice',
  'isGoodOmen',
  'sourceId',
  'sourceLocator',
  'image',
  'contentStatus',
] as const;
const SOURCE_FIELDS = ['title', 'author', 'publisher', 'edition', 'year', 'url', 'note'] as const;

function diff(a: object, b: object, fields: readonly string[]): string[] {
  const x = a as Record<string, unknown>;
  const y = b as Record<string, unknown>;
  return fields.filter((f) => JSON.stringify(x[f]) !== JSON.stringify(y[f]));
}

export function planImport(valid: ValidationResult, snapshot: Snapshot, options: PlanOptions): PlanItem[] {
  const plan: PlanItem[] = [];
  for (const s of valid.sources) {
    const existing = snapshot.sources.get(s.id);
    if (!existing) plan.push({ kind: 'source', id: s.id, action: 'create' });
    else {
      const changed = diff(s, existing, SOURCE_FIELDS);
      if (changed.length === 0) plan.push({ kind: 'source', id: s.id, action: 'unchanged' });
      else if (options.update) plan.push({ kind: 'source', id: s.id, action: 'update', changed });
      else
        plan.push({ kind: 'source', id: s.id, action: 'conflict', changed, reason: 'differs; re-run with --update' });
    }
  }
  for (const d of valid.dreams) {
    const existing = snapshot.dreams.get(d.id);
    if (!existing) {
      plan.push({ kind: 'dream', id: d.id, action: 'create' });
      continue;
    }
    const changed = diff(d, existing, DREAM_FIELDS);
    if (existing.contentStatus === 'VERIFIED') {
      plan.push({
        kind: 'dream',
        id: d.id,
        action: changed.length === 0 ? 'unchanged' : 'protected',
        ...(changed.length ? { changed, reason: 'existing row is VERIFIED; the importer never changes it' } : {}),
      });
    } else if (changed.length === 0) {
      plan.push({ kind: 'dream', id: d.id, action: 'unchanged' });
    } else if (existing.contentStatus === 'SAMPLE') {
      plan.push({
        kind: 'dream',
        id: d.id,
        action: 'protected',
        changed,
        reason: 'existing row is seed SAMPLE data; use a different id',
      });
    } else if (options.update) {
      plan.push({ kind: 'dream', id: d.id, action: 'update', changed });
    } else {
      plan.push({
        kind: 'dream',
        id: d.id,
        action: 'conflict',
        changed,
        reason: 'existing DRAFT differs; re-run with --update',
      });
    }
  }
  return plan;
}

export function summarise(plan: PlanItem[]): Record<string, Record<Action, number>> {
  const empty = (): Record<Action, number> => ({ create: 0, update: 0, unchanged: 0, conflict: 0, protected: 0 });
  const out = { source: empty(), dream: empty() };
  for (const p of plan) out[p.kind][p.action]++;
  return out;
}

function dreamData(d: ImportDream) {
  return {
    name: d.name,
    categoryId: d.categoryId,
    aliases: d.aliases,
    short: d.short,
    meaning: d.meaning,
    twoDigit: d.twoDigit,
    threeDigit: d.threeDigit,
    digits: d.digits,
    noLuckyNumbers: d.noLuckyNumbers,
    advice: d.advice,
    isGoodOmen: d.isGoodOmen,
    sourceId: d.sourceId,
    sourceLocator: d.sourceLocator,
    imageUrl: d.image?.url ?? null,
    imageAlt: d.image?.alt ?? null,
    imageCredit: d.image?.credit ?? null,
    imageLicense: d.image?.license ?? null,
    imageSourceUrl: d.image?.sourceUrl ?? null,
    contentStatus: d.contentStatus,
  };
}

/**
 * Applies create/update actions in one transaction; any failure (e.g. a CHECK constraint) rolls everything
 * back. New dreams are appended after the current highest sortOrder, in file order.
 */
export async function applyImport(
  prisma: PrismaClient,
  valid: ValidationResult,
  plan: PlanItem[],
): Promise<{ created: number; updated: number }> {
  const action = (kind: PlanItem['kind'], id: string) => plan.find((p) => p.kind === kind && p.id === id)?.action;
  let created = 0;
  let updated = 0;
  await prisma.$transaction(
    async (tx) => {
      for (const s of valid.sources) {
        const { id, ...data } = s;
        const a = action('source', id);
        if (a === 'create') {
          await tx.contentSource.create({ data: s });
          created++;
        } else if (a === 'update') {
          await tx.contentSource.update({ where: { id }, data });
          updated++;
        }
      }
      let next = ((await tx.dream.aggregate({ _max: { sortOrder: true } }))._max.sortOrder ?? 0) + 1;
      for (const d of valid.dreams) {
        const a = action('dream', d.id);
        if (a === 'create') {
          await tx.dream.create({ data: { id: d.id, sortOrder: next++, ...dreamData(d) } });
          created++;
        } else if (a === 'update') {
          // Guard against a concurrent change since the plan was made: only DRAFT rows are updated.
          const res = await tx.dream.updateMany({ where: { id: d.id, contentStatus: 'DRAFT' }, data: dreamData(d) });
          if (res.count !== 1) throw new Error(`dream ${d.id} is no longer DRAFT; nothing was written`);
          updated++;
        }
      }
    },
    { maxWait: 15_000, timeout: 120_000 },
  );
  return { created, updated };
}
