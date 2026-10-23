import { HttpStatus, Injectable } from '@nestjs/common';
import { ApiException } from '../common/errors/api-error';
import { CategoryListResponseDto, DreamDetailResponseDto, DreamListResponseDto } from './dto/dream-response.dto';
import { ListDreamsQueryDto } from './dto/list-dreams-query.dto';
import { DreamsRepository } from './dreams.repository';
import { toCategoryDto, toDreamDetail, toDreamSummary } from './mappers/dream.mapper';

export function totalPages(total: number, limit: number): number {
  return total === 0 ? 0 : Math.ceil(total / limit);
}

@Injectable()
export class DreamsService {
  constructor(private readonly repo: DreamsRepository) {}

  async list(query: ListDreamsQueryDto): Promise<DreamListResponseDto> {
    const { page, limit } = query;
    if (query.category && !(await this.repo.categoryExists(query.category))) {
      throw new ApiException(HttpStatus.BAD_REQUEST, 'VALIDATION_ERROR', 'Invalid request', [
        `category "${query.category}" does not exist`,
      ]);
    }
    const { items, total } = await this.repo.findPage({
      q: query.q || undefined,
      categoryId: query.category,
      skip: (page - 1) * limit,
      take: limit,
    });
    return { data: items.map(toDreamSummary), meta: { page, limit, total, totalPages: totalPages(total, limit) } };
  }

  async getById(id: string): Promise<DreamDetailResponseDto> {
    const dream = await this.repo.findById(id);
    if (!dream) throw new ApiException(HttpStatus.NOT_FOUND, 'DREAM_NOT_FOUND', `Dream "${id}" not found`);
    return { data: toDreamDetail(dream) };
  }

  async categories(): Promise<CategoryListResponseDto> {
    return { data: (await this.repo.findCategories()).map(toCategoryDto) };
  }
}
