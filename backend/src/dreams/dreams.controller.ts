import { Controller, Get, Param, Query } from '@nestjs/common';
import { ApiBadRequestResponse, ApiNotFoundResponse, ApiOkResponse, ApiParam, ApiTags } from '@nestjs/swagger';
import { CategoryListResponseDto, DreamDetailResponseDto, DreamListResponseDto } from './dto/dream-response.dto';
import { ListDreamsQueryDto } from './dto/list-dreams-query.dto';
import { DreamIdPipe } from './dream-id.pipe';
import { DreamsService } from './dreams.service';

@ApiTags('dreams')
@Controller()
export class DreamsController {
  constructor(private readonly dreams: DreamsService) {}

  @Get('dreams')
  @ApiOkResponse({ type: DreamListResponseDto })
  @ApiBadRequestResponse({ description: 'VALIDATION_ERROR' })
  list(@Query() query: ListDreamsQueryDto) {
    return this.dreams.list(query);
  }

  @Get('dreams/:id')
  @ApiParam({ name: 'id', example: 'tooth-falling-out' })
  @ApiOkResponse({ type: DreamDetailResponseDto })
  @ApiNotFoundResponse({ description: 'DREAM_NOT_FOUND' })
  detail(@Param('id', DreamIdPipe) id: string) {
    return this.dreams.getById(id);
  }

  @Get('dream-categories')
  @ApiOkResponse({ type: CategoryListResponseDto })
  categories() {
    return this.dreams.categories();
  }
}
