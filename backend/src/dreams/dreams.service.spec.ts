import { ApiException } from '../common/errors/api-error';
import { ListDreamsQueryDto } from './dto/list-dreams-query.dto';
import { DreamsRepository } from './dreams.repository';
import { DreamsService, totalPages } from './dreams.service';
import type { DreamWithRelations } from './mappers/dream.mapper';

const category = { id: 'body', name: 'ร่างกาย', sortOrder: 2, createdAt: new Date(0), updatedAt: new Date(0) };
const tooth: DreamWithRelations = {
  id: 'tooth-falling-out',
  name: 'ฟันหลุด',
  categoryId: 'body',
  category,
  short: 'ระวังเรื่องญาติผู้ใหญ่ สุขภาพ',
  meaning: 'm',
  advice: 'a',
  isGoodOmen: false,
  digits: ['0', '8'],
  twoDigit: ['08', '80'],
  threeDigit: ['098', '809'],
  noLuckyNumbers: false,
  luckMoney: 45,
  luckLove: 40,
  luckHealth: 58,
  aliases: [],
  sourceId: null,
  source: null,
  sourceLocator: null,
  imageUrl: null,
  imageAlt: null,
  imageCredit: null,
  imageLicense: null,
  imageSourceUrl: null,
  contentStatus: 'SAMPLE',
  sortOrder: 3,
  createdAt: new Date(0),
  updatedAt: new Date(0),
};

function query(over: Partial<ListDreamsQueryDto> = {}): ListDreamsQueryDto {
  return Object.assign(new ListDreamsQueryDto(), over);
}

describe('DreamsService', () => {
  let repo: jest.Mocked<Pick<DreamsRepository, 'findPage' | 'findById' | 'findCategories' | 'categoryExists'>>;
  let service: DreamsService;

  beforeEach(() => {
    repo = {
      findPage: jest.fn().mockResolvedValue({ items: [tooth], total: 1 }),
      findById: jest.fn(),
      findCategories: jest.fn().mockResolvedValue([category]),
      categoryExists: jest.fn().mockResolvedValue(true),
    };
    service = new DreamsService(repo as unknown as DreamsRepository);
  });

  it('translates page/limit into skip/take', async () => {
    await service.list(query({ page: 3, limit: 5 }));
    expect(repo.findPage).toHaveBeenCalledWith({
      q: undefined,
      categoryId: undefined,
      skip: 10,
      take: 5,
      sort: 'catalogue',
    });
  });

  it('returns pagination metadata', async () => {
    repo.findPage.mockResolvedValue({ items: [tooth], total: 41 });
    const res = await service.list(query({ page: 2, limit: 20 }));
    expect(res.meta).toEqual({ page: 2, limit: 20, total: 41, totalPages: 3 });
  });

  it('treats an empty search string as no filter and passes text and category through', async () => {
    await service.list(query({ q: '' }));
    expect(repo.findPage).toHaveBeenLastCalledWith(expect.objectContaining({ q: undefined }));
    await service.list(query({ q: 'งู', category: 'animal' }));
    expect(repo.findPage).toHaveBeenLastCalledWith(expect.objectContaining({ q: 'งู', categoryId: 'animal' }));
  });

  it('rejects an unknown category with VALIDATION_ERROR (400) without querying dreams', async () => {
    repo.categoryExists.mockResolvedValue(false);
    await expect(service.list(query({ category: 'nope' }))).rejects.toMatchObject({
      status: 400,
      code: 'VALIDATION_ERROR',
    });
    expect(repo.findPage).not.toHaveBeenCalled();
  });

  it('maps list items to summaries with string numbers and leading zeros', async () => {
    const res = await service.list(query());
    expect(res.data[0]).toEqual({
      id: 'tooth-falling-out',
      name: 'ฟันหลุด',
      category: { id: 'body', name: 'ร่างกาย' },
      short: 'ระวังเรื่องญาติผู้ใหญ่ สุขภาพ',
      isGoodOmen: false,
      numbers: { twoDigit: ['08', '80'], threeDigit: ['098', '809'] },
      noLuckyNumbers: false,
      image: null,
      contentStatus: 'SAMPLE',
    });
    expect(res.data[0]).not.toHaveProperty('luckMoney');
  });

  it('returns the detail of a known id', async () => {
    repo.findById.mockResolvedValue(tooth);
    const res = await service.getById('tooth-falling-out');
    expect(res.data.luckForecast).toEqual({ money: 45, love: 40, health: 58 });
    expect(res.data.digits).toEqual(['0', '8']);
  });

  it('throws DREAM_NOT_FOUND (404) for an unknown id', async () => {
    repo.findById.mockResolvedValue(null);
    const err = await service.getById('missing').catch((e: unknown) => e);
    expect(err).toBeInstanceOf(ApiException);
    expect(err).toMatchObject({ status: 404, code: 'DREAM_NOT_FOUND' });
  });

  it('lists categories in repository order', async () => {
    expect(await service.categories()).toEqual({ data: [{ id: 'body', name: 'ร่างกาย' }] });
  });
});

describe('totalPages', () => {
  it.each([
    [0, 20, 0],
    [1, 20, 1],
    [20, 20, 1],
    [21, 20, 2],
    [10, 3, 4],
  ])('total=%i limit=%i -> %i', (total, limit, expected) => {
    expect(totalPages(total, limit)).toBe(expected);
  });
});
