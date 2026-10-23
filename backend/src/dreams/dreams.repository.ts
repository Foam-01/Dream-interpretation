import { Injectable } from '@nestjs/common';
import type { DreamCategory, Prisma } from '../../generated/prisma/client';
import { compareThai } from '../common/text/thai-collation';
import { PrismaService } from '../prisma/prisma.service';
import type { DreamSort } from './dto/list-dreams-query.dto';
import { PUBLIC_STATUSES, type DreamWithCategory, type DreamWithRelations } from './mappers/dream.mapper';

export interface DreamListFilter {
  q?: string;
  categoryId?: string;
  skip: number;
  take: number;
  sort?: DreamSort;
}

/** All Prisma access for dreams lives here so the service can be unit-tested without a database. */
@Injectable()
export class DreamsRepository {
  constructor(private readonly prisma: PrismaService) {}

  async findPage(filter: DreamListFilter): Promise<{ items: DreamWithCategory[]; total: number }> {
    const where: Prisma.DreamWhereInput = {
      // DRAFT content (imported, not reviewed) is never public.
      contentStatus: { in: PUBLIC_STATUSES },
      ...(filter.categoryId ? { categoryId: filter.categoryId } : {}),
      // Parameterised substring match on name OR short (case-sensitive), mirroring the app's search,
      // plus an exact match on an alias.
      ...(filter.q
        ? { OR: [{ name: { contains: filter.q } }, { short: { contains: filter.q } }, { aliases: { has: filter.q } }] }
        : {}),
    };
    if (filter.sort === 'name') return this.findPageByThaiName(where, filter);
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

  /**
   * Thai dictionary order is computed in the application (see compareThai): all matching ids and names are
   * read (two short columns), sorted, and only the requested page is loaded in full. Fine for a catalogue of
   * thousands of rows; revisit with a stored sort key if it grows far beyond that.
   */
  private async findPageByThaiName(
    where: Prisma.DreamWhereInput,
    filter: DreamListFilter,
  ): Promise<{ items: DreamWithCategory[]; total: number }> {
    const keys = await this.prisma.dream.findMany({ where, select: { id: true, name: true } });
    keys.sort(compareThai);
    const pageIds = keys.slice(filter.skip, filter.skip + filter.take).map((k) => k.id);
    if (pageIds.length === 0) return { items: [], total: keys.length };
    const rows = await this.prisma.dream.findMany({ where: { id: { in: pageIds } }, include: { category: true } });
    const byId = new Map(rows.map((r) => [r.id, r]));
    // A row changed between the two reads simply drops out of this page.
    const items = pageIds.map((id) => byId.get(id)).filter((r): r is DreamWithCategory => r !== undefined);
    return { items, total: keys.length };
  }

  findById(id: string): Promise<DreamWithRelations | null> {
    return this.prisma.dream.findFirst({
      where: { id, contentStatus: { in: PUBLIC_STATUSES } },
      include: { category: true, source: true },
    });
  }

  findCategories(): Promise<DreamCategory[]> {
    return this.prisma.dreamCategory.findMany({ orderBy: [{ sortOrder: 'asc' }, { id: 'asc' }] });
  }

  async categoryExists(id: string): Promise<boolean> {
    return (await this.prisma.dreamCategory.count({ where: { id } })) > 0;
  }
}
