import { NestExpressApplication } from '@nestjs/platform-express';
import { PrismaPg } from '@prisma/adapter-pg';
import request from 'supertest';
import { PrismaClient } from '../generated/prisma/client';
import { isLocalDatabase, seedSampleFixtures } from '../prisma/seed';
import { allCategories } from '../prisma/seed-data';
import { createApp } from './helpers';

// Runs against the isolated PostgreSQL started by test/setup/global-setup.ts (migrations applied).

describe('Dreams API (e2e, real PostgreSQL)', () => {
  let app: NestExpressApplication;
  let prisma: PrismaClient;
  const http = () => request(app.getHttpServer());

  beforeAll(async () => {
    // Safety net: this suite deletes rows, so it must only ever run against the local test database.
    if (!isLocalDatabase(process.env.DATABASE_URL ?? '')) throw new Error('e2e tests must use a local database');
    prisma = new PrismaClient({ adapter: new PrismaPg({ connectionString: process.env.DATABASE_URL! }) });
    await prisma.dream.deleteMany();
    await prisma.dreamCategory.deleteMany();
    app = await createApp();
  });

  afterAll(async () => {
    await app.close();
    await prisma.$disconnect();
  });

  describe('empty database', () => {
    it('lists nothing with zero pages', async () => {
      const res = await http().get('/api/v1/dreams').expect(200);
      expect(res.body).toEqual({ data: [], meta: { page: 1, limit: 20, total: 0, totalPages: 0 } });
    });
  });

  describe('seeded with the app sample data', () => {
    beforeAll(async () => {
      await seedSampleFixtures(prisma);
      await seedSampleFixtures(prisma); // idempotent: second run must not duplicate
    });

    it('seed is idempotent', async () => {
      expect(await prisma.dream.count()).toBe(10);
      expect(await prisma.dreamCategory.count()).toBe(allCategories.length); // sample + letter categories
    });

    it('GET /dreams returns all 10 in app order with default pagination', async () => {
      const res = await http().get('/api/v1/dreams').expect(200);
      expect(res.body.meta).toEqual({ page: 1, limit: 20, total: 10, totalPages: 1 });
      expect(res.body.data.map((d: { id: string }) => d.id)).toEqual([
        'snake',
        'elephant',
        'tooth-falling-out',
        'flood',
        'fish',
        'fire',
        'monk',
        'dead-person',
        'gold',
        'tiger',
      ]);
    });

    it('paginates with stable order', async () => {
      const p1 = await http().get('/api/v1/dreams?limit=4&page=1').expect(200);
      const p3 = await http().get('/api/v1/dreams?limit=4&page=3').expect(200);
      expect(p1.body.data.map((d: { id: string }) => d.id)).toEqual([
        'snake',
        'elephant',
        'tooth-falling-out',
        'flood',
      ]);
      expect(p3.body.data.map((d: { id: string }) => d.id)).toEqual(['gold', 'tiger']);
      expect(p3.body.meta).toEqual({ page: 3, limit: 4, total: 10, totalPages: 3 });
    });

    it('returns an empty page beyond the last page', async () => {
      const res = await http().get('/api/v1/dreams?page=99').expect(200);
      expect(res.body.data).toEqual([]);
      expect(res.body.meta.total).toBe(10);
    });

    it('searches name (Thai) like the app', async () => {
      const res = await http().get('/api/v1/dreams').query({ q: 'งู' }).expect(200);
      expect(res.body.data.map((d: { id: string }) => d.id)).toEqual(['snake']);
    });

    it('searches the short summary and trims the query', async () => {
      const res = await http().get('/api/v1/dreams').query({ q: '  ลาภก้อนเล็ก ' }).expect(200);
      expect(res.body.data.map((d: { id: string }) => d.id)).toEqual(['fish']);
    });

    it('does not search meaning or numbers (same as the app)', async () => {
      await http()
        .get('/api/v1/dreams')
        .query({ q: '08' })
        .expect(200)
        .expect((r) => expect(r.body.data).toEqual([]));
    });

    it('filters by category and combines with search', async () => {
      const animals = await http().get('/api/v1/dreams?category=animal').expect(200);
      expect(animals.body.meta.total).toBe(4);
      const both = await http().get('/api/v1/dreams').query({ category: 'animal', q: 'ไฟไหม้' }).expect(200);
      expect(both.body.data).toEqual([]);
    });

    it('GET /dreams/:id returns the detail with leading zeros preserved', async () => {
      const res = await http().get('/api/v1/dreams/tooth-falling-out').expect(200);
      expect(res.body.data).toMatchObject({
        id: 'tooth-falling-out',
        name: 'ฟันหลุด',
        category: { id: 'body', name: 'ร่างกาย' },
        isGoodOmen: false,
        digits: ['0', '8'],
        numbers: { twoDigit: ['08', '80'], threeDigit: ['098', '809'] },
        luckForecast: { money: 45, love: 40, health: 58 },
        contentStatus: 'SAMPLE',
      });
      const dead = await http().get('/api/v1/dreams/dead-person').expect(200);
      expect(dead.body.data.numbers).toEqual({ twoDigit: ['09', '90'], threeDigit: ['090', '900'] });
      expect(typeof dead.body.data.numbers.twoDigit[0]).toBe('string');
    });

    it('GET /dreams/:id returns 404 DREAM_NOT_FOUND for an unknown id', async () => {
      const res = await http().get('/api/v1/dreams/unicorn').expect(404);
      expect(res.body).toEqual({ error: { code: 'DREAM_NOT_FOUND', message: 'Dream "unicorn" not found' } });
    });

    it('GET /dream-categories lists categories in app order', async () => {
      const res = await http().get('/api/v1/dream-categories').expect(200);
      expect(res.body.data).toEqual([
        { id: 'animal', name: 'สัตว์' },
        { id: 'body', name: 'ร่างกาย' },
        { id: 'nature', name: 'ธรรมชาติ' },
        { id: 'person', name: 'บุคคล' },
        { id: 'object', name: 'สิ่งของ' },
        { id: 'letter-k', name: 'หมวด ก' },
        { id: 'letter-kh', name: 'หมวด ข' },
        { id: 'letter-khw', name: 'หมวด ค' },
        { id: 'letter-khr', name: 'หมวด ฆ' },
        { id: 'letter-ng', name: 'หมวด ง' },
        { id: 'letter-ch', name: 'หมวด จ' },
        { id: 'letter-chg', name: 'หมวด ฉ' },
        { id: 'letter-chc', name: 'หมวด ช' },
        { id: 'letter-s', name: 'หมวด ซ' },
        { id: 'letter-y', name: 'หมวด ญ' },
        { id: 'letter-d', name: 'หมวด ด' },
      ]);
    });

    it('database CHECK constraints reject malformed numbers and scores', async () => {
      const base = (await prisma.dream.findUniqueOrThrow({ where: { id: 'snake' } })) as Record<string, unknown>;
      await expect(prisma.dream.update({ where: { id: 'snake' }, data: { twoDigit: ['8'] } })).rejects.toThrow();
      // Numbers are required unless no_lucky_numbers; three-digit numbers alone may be empty (two-digit-only sources).
      await expect(prisma.dream.update({ where: { id: 'snake' }, data: { twoDigit: [] } })).rejects.toThrow();
      await expect(prisma.dream.update({ where: { id: 'snake' }, data: { luckMoney: 101 } })).rejects.toThrow();
      await expect(
        prisma.dream.create({ data: { ...(base as object), id: 'Bad Id', sortOrder: 999 } as never }),
      ).rejects.toThrow();
      const after = await prisma.dream.findUniqueOrThrow({ where: { id: 'snake' } });
      expect(after.twoDigit).toEqual(['56', '65']);
      expect(after.luckMoney).toBe(84);
    });
  });

  describe('validation', () => {
    it.each([
      ['/api/v1/dreams?limit=0', 'limit must not be less than 1'],
      ['/api/v1/dreams?limit=101', 'limit must not be greater than 100'],
      ['/api/v1/dreams?page=abc', 'page must be an integer number'],
      ['/api/v1/dreams?category=Animal', 'category must be a category id (lowercase slug)'],
      ['/api/v1/dreams?unknown=1', 'property unknown should not exist'],
      ['/api/v1/dreams?category=unknown-cat', 'category "unknown-cat" does not exist'],
      ['/api/v1/dreams/BAD_ID', 'id must be a lowercase slug (a-z, 0-9, -)'],
    ])('%s -> 400', async (url, detail) => {
      const res = await http().get(url).expect(400);
      expect(res.body.error.code).toBe('VALIDATION_ERROR');
      expect(res.body.error.details).toContain(detail);
    });

    it('rejects an over-long search query', async () => {
      const res = await http()
        .get('/api/v1/dreams')
        .query({ q: 'x'.repeat(51) })
        .expect(400);
      expect(res.body.error.code).toBe('VALIDATION_ERROR');
    });

    it('unknown routes use the error envelope', async () => {
      const res = await http().get('/api/v1/nothing-here').expect(404);
      expect(res.body).toEqual({ error: { code: 'NOT_FOUND', message: 'Route not found' } });
    });

    it('does not advertise the framework', async () => {
      const res = await http().get('/api/v1/health');
      expect(res.headers['x-powered-by']).toBeUndefined();
    });
  });
});
