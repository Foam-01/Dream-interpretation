import { ApiPropertyOptional } from '@nestjs/swagger';
import { Transform, Type } from 'class-transformer';
import { IsInt, IsOptional, IsString, Matches, Max, MaxLength, Min } from 'class-validator';

export const MAX_PAGE_SIZE = 100;
export const DEFAULT_PAGE_SIZE = 20;

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
}
