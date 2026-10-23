import { ApiProperty } from '@nestjs/swagger';

export class CategoryDto {
  @ApiProperty({ example: 'animal' }) id: string;
  @ApiProperty({ example: 'สัตว์' }) name: string;
}

export class LuckyNumbersDto {
  @ApiProperty({ type: [String], example: ['08', '80'], description: 'Two-digit strings; leading zeros preserved' })
  twoDigit: string[];

  @ApiProperty({ type: [String], example: ['098', '809'], description: 'Three-digit strings; leading zeros preserved' })
  threeDigit: string[];
}

export class LuckForecastDto {
  @ApiProperty({ minimum: 0, maximum: 100 }) money: number;
  @ApiProperty({ minimum: 0, maximum: 100 }) love: number;
  @ApiProperty({ minimum: 0, maximum: 100 }) health: number;
}

export class DreamSummaryDto {
  @ApiProperty({ example: 'tooth-falling-out', description: 'Stable public id (slug)' }) id: string;
  @ApiProperty() name: string;
  @ApiProperty({ type: CategoryDto }) category: CategoryDto;
  @ApiProperty() short: string;
  @ApiProperty() isGoodOmen: boolean;
  @ApiProperty({ type: LuckyNumbersDto }) numbers: LuckyNumbersDto;

  @ApiProperty({ enum: ['SAMPLE', 'VERIFIED'], description: 'SAMPLE = demo content, not verified' })
  contentStatus: 'SAMPLE' | 'VERIFIED';
}

export class DreamDetailDto extends DreamSummaryDto {
  @ApiProperty() meaning: string;
  @ApiProperty() advice: string;

  @ApiProperty({ type: [String], example: ['0', '8'], description: 'Single lucky digits in display order' })
  digits: string[];

  @ApiProperty({ type: LuckForecastDto }) luckForecast: LuckForecastDto;
}

export class PageMetaDto {
  @ApiProperty() page: number;
  @ApiProperty() limit: number;
  @ApiProperty() total: number;
  @ApiProperty() totalPages: number;
}

export class DreamListResponseDto {
  @ApiProperty({ type: [DreamSummaryDto] }) data: DreamSummaryDto[];
  @ApiProperty({ type: PageMetaDto }) meta: PageMetaDto;
}

export class DreamDetailResponseDto {
  @ApiProperty({ type: DreamDetailDto }) data: DreamDetailDto;
}

export class CategoryListResponseDto {
  @ApiProperty({ type: [CategoryDto] }) data: CategoryDto[];
}
