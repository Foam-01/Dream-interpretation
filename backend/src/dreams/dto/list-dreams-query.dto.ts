import { ApiPropertyOptional } from '@nestjs/swagger';
import { Transform, Type } from 'class-transformer';
import { IsIn, IsInt, IsOptional, IsString, Matches, Max, MaxLength, Min } from 'class-validator';

export const MAX_PAGE_SIZE = 100;
export const DEFAULT_PAGE_SIZE = 20;

/** `catalogue` = curated app order (default, unchanged); `name` = Thai dictionary order (ก–ฮ). */
export const DREAM_SORTS = ['catalogue', 'name'] as const;
export type DreamSort = (typeof DREAM_SORTS)[number];

/** Query contract for GET /dreams. Unknown query parameters are rejected (400). */
export class ListDreamsQueryDto {
  @ApiPropertyOptional({ minimum: 1, default: 1 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  page = 1;

  @ApiPropertyOptional({ minimum: 1, maximum: MAX_PAGE_SIZE, default: DEFAULT_PAGE_SIZE })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(MAX_PAGE_SIZE)
  limit = DEFAULT_PAGE_SIZE;

  /** Trimmed; substring match on name or short text, like the app. Empty means no text filter. */
  @ApiPropertyOptional({
    maxLength: 50,
    description: 'Substring match on dream name or short summary (case-sensitive)',
  })
  @IsOptional()
  @Transform(({ value }: { value: unknown }) => (typeof value === 'string' ? value.trim() : value))
  @IsString()
  @MaxLength(50)
  q?: string;

  /** Category id from GET /dream-categories. */
  @ApiPropertyOptional({ example: 'animal' })
  @IsOptional()
  @IsString()
  @Matches(/^[a-z0-9-]{1,64}$/, { message: 'category must be a category id (lowercase slug)' })
  category?: string;

  @ApiPropertyOptional({ enum: DREAM_SORTS, default: 'catalogue' })
  @IsOptional()
  @IsIn(DREAM_SORTS, { message: 'sort must be one of: catalogue, name' })
  sort: DreamSort = 'catalogue';
}
