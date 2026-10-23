import { Injectable } from '@nestjs/common';
import type { DreamCategory, Prisma } from '../../generated/prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import type { DreamWithCategory } from './mappers/dream.mapper';

export interface DreamListFilter {
  q?: string;
  categoryId?: string;
  skip: number;
  take: number;
}

/** All Prisma access for dreams lives here so the service can be unit-tested without a database. */
@Injectable()
export class DreamsRepository {
  constructor(private readonly prisma: PrismaService) {}

  async findPage(filter: DreamListFilter): Promise<{ items: DreamWithCategory[]; total: number }> {
    const where: Prisma.DreamWhereInput = {
      ...(filter.categoryId ? { categoryId: filter.categoryId } : {}),
      // Parameterised substring match on name OR short (case-sensitive), mirroring the app's search.
      ...(filter.q ? { OR: [{ name: { contains: filter.q } }, { short: { contains: filter.q } }] } : {}),
    };
    const [items, total] = await this.prisma.$transaction([
      this.prisma.dream.findMany({
        where,
        include: { category: true },
        orderBy: [{ sortOrder: 'asc' }, { id: 'asc' }],
        skip: filter.skip,
        take: filter.take,
      }),
      this.prisma.dream.count({ where }),
    ]);
    return { items, total };
  }

  findById(id: string): Promise<DreamWithCategory | null> {
    return this.prisma.dream.findUnique({ where: { id }, include: { category: true } });
  }

  findCategories(): Promise<DreamCategory[]> {
    return this.prisma.dreamCategory.findMany({ orderBy: [{ sortOrder: 'asc' }, { id: 'asc' }] });
  }

  async categoryExists(id: string): Promise<boolean> {
    return (await this.prisma.dreamCategory.count({ where: { id } })) > 0;
  }
}
