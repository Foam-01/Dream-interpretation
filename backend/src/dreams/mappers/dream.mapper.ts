import type { Dream, DreamCategory } from '../../../generated/prisma/client';
import { CategoryDto, DreamDetailDto, DreamSummaryDto } from '../dto/dream-response.dto';

export type DreamWithCategory = Dream & { category: DreamCategory };

// Explicit mapping keeps database column names out of the public contract.
// Number arrays are copied as-is: strings in, strings out (no numeric conversion).

export function toCategoryDto(c: DreamCategory): CategoryDto {
  return { id: c.id, name: c.name };
}

export function toDreamSummary(d: DreamWithCategory): DreamSummaryDto {
  return {
    id: d.id,
    name: d.name,
    category: toCategoryDto(d.category),
    short: d.short,
    isGoodOmen: d.isGoodOmen,
    numbers: { twoDigit: [...d.twoDigit], threeDigit: [...d.threeDigit] },
    contentStatus: d.contentStatus,
  };
}

export function toDreamDetail(d: DreamWithCategory): DreamDetailDto {
  return {
    ...toDreamSummary(d),
    meaning: d.meaning,
    advice: d.advice,
    digits: [...d.digits],
    luckForecast: { money: d.luckMoney, love: d.luckLove, health: d.luckHealth },
  };
}
