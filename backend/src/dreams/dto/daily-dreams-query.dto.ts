import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsInt, IsString, Matches, Max, Min } from 'class-validator';

export const MAX_DAILY = 20;
export const DEFAULT_DAILY = 10;

/** Query contract for GET /dreams/daily. Unknown query parameters are rejected (400). */
export class DailyDreamsQueryDto {
  /** The caller's pick day (the app's day turns over at 04:00 Thai time), so every caller of a day agrees. */
  @ApiProperty({ example: '2026-11-08', description: 'Calendar date YYYY-MM-DD' })
  @IsString()
  @Matches(/^\d{4}-\d{2}-\d{2}$/, { message: 'date must be YYYY-MM-DD' })
  date: string;

  @ApiPropertyOptional({ minimum: 1, maximum: MAX_DAILY, default: DEFAULT_DAILY })
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(MAX_DAILY)
  limit = DEFAULT_DAILY;
}
