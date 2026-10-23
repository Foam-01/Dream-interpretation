import type { ContentSource, Dream, DreamCategory } from '../../../generated/prisma/client';
import { CategoryDto, DreamDetailDto, DreamSummaryDto, ImageDto, SourceDto } from '../dto/dream-response.dto';

export type DreamWithCategory = Dream & { category: DreamCategory };
export type DreamWithRelations = DreamWithCategory & { source: ContentSource | null };

/** Statuses the public API serves. DRAFT (imported, not reviewed) is never exposed. */
export const PUBLIC_STATUSES: Array<'SAMPLE' | 'VERIFIED'> = ['SAMPLE', 'VERIFIED'];

// Explicit mapping keeps database column names out of the public contract.
// Number arrays are copied as-is: strings in, strings out (no numeric conversion).

export function toCategoryDto(c: DreamCategory): CategoryDto {
  return { id: c.id, name: c.name };
}

function toImageDto(d: Dream): ImageDto | null {
  // The CHECK constraint guarantees credit and license whenever there is a URL.
  if (!d.imageUrl || !d.imageCredit || !d.imageLicense) return null;
  return {
    url: d.imageUrl,
    alt: d.imageAlt,
    credit: d.imageCredit,
    license: d.imageLicense,
    sourceUrl: d.imageSourceUrl,
  };
}

function toSourceDto(d: DreamWithRelations): SourceDto | null {
  const s = d.source;
  if (!s) return null;
  return {
    id: s.id,
    title: s.title,
    author: s.author,
    publisher: s.publisher,
    edition: s.edition,
    year: s.year,
    url: s.url,
    locator: d.sourceLocator,
  };
}

function publicStatus(d: Dream): 'SAMPLE' | 'VERIFIED' {
  // Repository queries filter DRAFT out; this guards against a future query forgetting to.
  if (d.contentStatus === 'DRAFT') throw new Error(`DRAFT dream ${d.id} reached the public mapper`);
  return d.contentStatus;
}

export function toDreamSummary(d: DreamWithCategory): DreamSummaryDto {
  return {
    id: d.id,
    name: d.name,
    category: toCategoryDto(d.category),
    short: d.short,
    isGoodOmen: d.isGoodOmen,
    numbers: { twoDigit: [...d.twoDigit], threeDigit: [...d.threeDigit] },
    noLuckyNumbers: d.noLuckyNumbers,
    image: toImageDto(d),
    contentStatus: publicStatus(d),
  };
}

export function toDreamDetail(d: DreamWithRelations): DreamDetailDto {
  const { luckMoney: money, luckLove: love, luckHealth: health } = d;
  return {
    ...toDreamSummary(d),
    meaning: d.meaning,
    advice: d.advice,
    digits: [...d.digits],
    luckForecast: money !== null && love !== null && health !== null ? { money, love, health } : null,
    aliases: [...d.aliases],
    source: toSourceDto(d),
  };
}
