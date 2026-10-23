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

export class ImageDto {
  @ApiProperty({ example: 'https://images.example.org/snake.jpg', description: 'https only' }) url: string;
  @ApiProperty({ type: String, nullable: true, description: 'Alternative text for accessibility' }) alt: string | null;
  @ApiProperty({ description: 'Photographer/artist or owner to credit' }) credit: string;
  @ApiProperty({ example: 'CC BY 4.0' }) license: string;
  @ApiProperty({ type: String, nullable: true, description: 'Page the image was obtained from' })
  sourceUrl: string | null;
}

export class SourceDto {
  @ApiProperty({ example: 'tamra-example' }) id: string;
  @ApiProperty() title: string;
  @ApiProperty({ type: String, nullable: true }) author: string | null;
  @ApiProperty({ type: String, nullable: true }) publisher: string | null;
  @ApiProperty({ type: String, nullable: true }) edition: string | null;
  @ApiProperty({ type: Number, nullable: true }) year: number | null;
  @ApiProperty({ type: String, nullable: true }) url: string | null;
  @ApiProperty({ type: String, nullable: true, description: 'Page or section within the source' })
  locator: string | null;
}

export class DreamSummaryDto {
  @ApiProperty({ example: 'tooth-falling-out', description: 'Stable public id (slug)' }) id: string;
  @ApiProperty() name: string;
  @ApiProperty({ type: CategoryDto }) category: CategoryDto;
  @ApiProperty() short: string;
  @ApiProperty({ type: Boolean, nullable: true, description: 'null when the source does not say' })
  isGoodOmen: boolean | null;
  @ApiProperty({ type: LuckyNumbersDto }) numbers: LuckyNumbersDto;
  @ApiProperty({ description: 'true = the source says "ไม่ควรเสี่ยง"; numbers are then empty' })
  noLuckyNumbers: boolean;
  @ApiProperty({ type: ImageDto, nullable: true, description: 'null = no image' }) image: ImageDto | null;

  @ApiProperty({
    enum: ['SAMPLE', 'VERIFIED'],
    description: 'SAMPLE = demo content, not verified; DRAFT is never served',
  })
  contentStatus: 'SAMPLE' | 'VERIFIED';
}

export class DreamDetailDto extends DreamSummaryDto {
  @ApiProperty() meaning: string;
  @ApiProperty({ type: String, nullable: true }) advice: string | null;

  @ApiProperty({
    type: [String],
    example: ['0', '8'],
    description: 'Single lucky digits in display order; may be empty',
  })
  digits: string[];

  @ApiProperty({ type: LuckForecastDto, nullable: true, description: 'SAMPLE scores; null for sourced content' })
  luckForecast: LuckForecastDto | null;

  @ApiProperty({ type: [String], description: 'Extra search keywords (exact match)' }) aliases: string[];

  @ApiProperty({ type: SourceDto, nullable: true, description: 'Citation of the interpretation text' })
  source: SourceDto | null;
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
