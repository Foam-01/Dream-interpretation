import { NestExpressApplication } from '@nestjs/platform-express';
import { PrismaPg } from '@prisma/adapter-pg';
import request from 'supertest';
import { PrismaClient } from '../generated/prisma/client';
import { IMPORT_FORMAT, validateImportFile } from '../prisma/import/dream-import';
import { publishCategory, removeSample } from '../prisma/import/content-admin';
import { applyImport, loadSnapshot, planImport } from '../prisma/import/dream-import.db';
import { isLocalDatabase, seedSampleFixtures } from '../prisma/seed';
import { createApp } from './helpers';

// Content metadata (sources, images, aliases, DRAFT), Thai ordering and the importer against real PostgreSQL.
// Data here is test data only.

const categoryIds = new Set(['animal', 'body', 'nature', 'person', 'object']);
const importFile = {
  format: IMPORT_FORMAT,
  sources: [{ id: 'e2e-source', title: 'แหล่งทดสอบ e2e', year: 2500, note: 'test data' }],
  dreams: [
    {
      id: 'e2e-cat-draft',
      name: 'แมว',
      categoryId: 'animal',
      short: 'ทดสอบ',
      meaning: 'ข้อมูลทดสอบ',
      numbers: { twoDigit: ['03'], threeDigit: ['003'] },
      source: { id: 'e2e-source', locator: 'หน้า 3' },
      contentStatus: 'DRAFT',
    },
  ],
};

describe('Content metadata, Thai ordering and import (e2e)', () => {
  let app: NestExpressApplication;
  let prisma: PrismaClient;
  const http = () => request(app.getHttpServer());
  const ids = (body: { data: Array<{ id: string }> }) => body.data.map((d) => d.id);

  beforeAll(async () => {
    if (!isLocalDatabase(process.env.DATABASE_URL ?? '')) throw new Error('e2e tests must use a local database');
    prisma = new PrismaClient({ adapter: new PrismaPg({ connectionString: process.env.DATABASE_URL! }) });
    await prisma.dream.deleteMany();
    await prisma.contentSource.deleteMany();
    await prisma.dreamCategory.deleteMany();
    await seedSampleFixtures(prisma);

    const v = validateImportFile(importFile, { categoryIds });
    expect(v.issues).toEqual([]);
    const plan = planImport(v, await loadSnapshot(prisma, ['e2e-source'], ['e2e-cat-draft']), { update: false });
    await applyImport(prisma, v, plan);

    // A reviewed record (the verify step is outside the importer).
    await prisma.dream.create({
      data: {
        id: 'e2e-crow',
        name: 'กา',
        categoryId: 'animal',
        aliases: ['อีกา'],
        short: 'สรุปทดสอบ',
        meaning: 'คำทำนายทดสอบ',
        twoDigit: ['01'],
        threeDigit: ['001'],
        digits: [],
        sourceId: 'e2e-source',
        sourceLocator: 'หน้า 1',
        imageUrl: 'https://images.example.org/crow.jpg',
        imageAlt: 'ภาพกา',
        imageCredit: 'ผู้ทดสอบ',
        imageLicense: 'CC BY 4.0',
        contentStatus: 'VERIFIED',
        sortOrder: 100,
      },
    });
    app = await createApp();
  });

  afterAll(async () => {
    await app.close();
    await prisma.$disconnect();
  });

  describe('public API', () => {
    it('never serves DRAFT content (list, search, count, detail)', async () => {
      const all = await http().get('/api/v1/dreams').expect(200);
      expect(ids(all.body)).not.toContain('e2e-cat-draft');
      expect(all.body.meta.total).toBe(11);
      expect((await http().get('/api/v1/dreams').query({ q: 'แมว' })).body.data).toEqual([]);
      await http().get('/api/v1/dreams/e2e-cat-draft').expect(404);
    });

    it('default order is unchanged (catalogue order, new rows appended)', async () => {
      const res = await http().get('/api/v1/dreams').expect(200);
      expect(ids(res.body)).toEqual([
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
        'e2e-crow',
      ]);
    });

    it('sort=name gives Thai dictionary order ก–ฮ across pages (leading vowels ignored)', async () => {
      const names: string[] = [];
      for (let page = 1; page <= 3; page++) {
        const res = await http().get('/api/v1/dreams').query({ sort: 'name', limit: 4, page }).expect(200);
        expect(res.body.meta).toEqual({ page, limit: 4, total: 11, totalPages: 3 });
        names.push(...res.body.data.map((d: { name: string }) => d.name));
      }
      expect(names).toEqual([
        'กา',
        'คนตาย',
        'งู',
        'ช้าง',
        'ทองคำ',
        'น้ำท่วม',
        'ปลา',
        'พระ',
        'ฟันหลุด',
        'ไฟไหม้',
        'เสือ',
      ]);
    });

    it('sort=name combines with category filter, search and empty results', async () => {
      const animals = await http().get('/api/v1/dreams').query({ sort: 'name', category: 'animal' }).expect(200);
      expect(animals.body.data.map((d: { name: string }) => d.name)).toEqual(['กา', 'งู', 'ช้าง', 'ปลา', 'เสือ']);
      const none = await http().get('/api/v1/dreams').query({ sort: 'name', q: 'ไม่มีคำนี้' }).expect(200);
      expect(none.body).toEqual({ data: [], meta: { page: 1, limit: 20, total: 0, totalPages: 0 } });
      const beyond = await http().get('/api/v1/dreams').query({ sort: 'name', page: 9 }).expect(200);
      expect(beyond.body.data).toEqual([]);
      expect(beyond.body.meta.total).toBe(11);
    });

    it('rejects an unknown sort', async () => {
      const res = await http().get('/api/v1/dreams').query({ sort: 'random' }).expect(400);
      expect(res.body.error.details).toContain('sort must be one of: catalogue, name');
    });

    it('finds a dream by an exact alias', async () => {
      expect(ids((await http().get('/api/v1/dreams').query({ q: 'อีกา' })).body)).toEqual(['e2e-crow']);
    });

    it('serves image attribution, source citation and nulls for absent optional fields', async () => {
      const res = await http().get('/api/v1/dreams/e2e-crow').expect(200);
      expect(res.body.data).toMatchObject({
        contentStatus: 'VERIFIED',
        numbers: { twoDigit: ['01'], threeDigit: ['001'] },
        digits: [],
        advice: null,
        isGoodOmen: null,
        luckForecast: null,
        aliases: ['อีกา'],
        image: {
          url: 'https://images.example.org/crow.jpg',
          alt: 'ภาพกา',
          credit: 'ผู้ทดสอบ',
          license: 'CC BY 4.0',
          sourceUrl: null,
        },
        source: {
          id: 'e2e-source',
          title: 'แหล่งทดสอบ e2e',
          author: null,
          publisher: null,
          edition: null,
          year: 2500,
          url: null,
          locator: 'หน้า 1',
        },
      });
      expect(res.body.data.source).not.toHaveProperty('note');
      const list = await http().get('/api/v1/dreams').query({ q: 'กา' }).expect(200);
      expect(list.body.data[0].image.url).toBe('https://images.example.org/crow.jpg');
      const sample = await http().get('/api/v1/dreams/snake').expect(200);
      expect(sample.body.data).toMatchObject({ image: null, source: null, aliases: [] });
      expect(sample.body.data.luckForecast).toEqual({ money: 84, love: 90, health: 62 });
    });
  });

  describe('database constraints for the new fields', () => {
    const base = {
      categoryId: 'animal',
      short: 's',
      meaning: 'm',
      twoDigit: ['01'],
      threeDigit: ['001'],
      digits: [],
    };
    let n = 200;
    const create = (data: Record<string, unknown>) =>
      prisma.dream.create({ data: { ...base, id: `e2e-bad-${n}`, name: 'x', sortOrder: n++, ...data } as never });

    it.each([
      ['image without credit/license', { imageUrl: 'https://i.example.org/a.jpg' }],
      ['http image', { imageUrl: 'http://i.example.org/a.jpg', imageCredit: 'c', imageLicense: 'l' }],
      ['image metadata without image', { imageCredit: 'c' }],
      ['partial forecast', { luckMoney: 10 }],
      ['blank alias', { aliases: [''] }],
      ['locator without source', { sourceLocator: 'หน้า 1' }],
    ])('rejects %s', async (_label, data) => {
      await expect(create(data)).rejects.toThrow();
    });

    it('accepts VERIFIED content without a source (the owner approves publication)', async () => {
      await expect(create({ contentStatus: 'VERIFIED' })).resolves.toBeDefined();
    });

    it('accepts sourced content without digits, advice, omen or forecast', async () => {
      await expect(create({ contentStatus: 'DRAFT', sourceId: 'e2e-source' })).resolves.toBeDefined();
    });
  });

  describe('importer and seed never overwrite or delete', () => {
    it('a second import of the same file changes nothing', async () => {
      const v = validateImportFile(importFile, { categoryIds });
      const plan = planImport(v, await loadSnapshot(prisma, ['e2e-source'], ['e2e-cat-draft']), { update: false });
      expect(plan.map((p) => p.action)).toEqual(['unchanged', 'unchanged']);
      const before = await prisma.dream.count();
      expect(await applyImport(prisma, v, plan)).toEqual({ created: 0, updated: 0 });
      expect(await prisma.dream.count()).toBe(before);
    });

    it('an import that omits existing rows does not delete them', async () => {
      const other = {
        ...importFile,
        dreams: [{ ...importFile.dreams[0], id: 'e2e-other', name: 'นกทดสอบ' }],
      };
      const v = validateImportFile(other, { categoryIds });
      const plan = planImport(v, await loadSnapshot(prisma, ['e2e-source'], ['e2e-other']), { update: false });
      await applyImport(prisma, v, plan);
      expect(await prisma.dream.findUnique({ where: { id: 'e2e-cat-draft' } })).not.toBeNull();
    });

    it('re-seeding leaves non-SAMPLE rows untouched', async () => {
      await prisma.dream.update({ where: { id: 'snake' }, data: { contentStatus: 'DRAFT', meaning: 'แก้ด้วยมือ' } });
      const res = await seedSampleFixtures(prisma);
      expect(res.protectedIds).toEqual(['snake']);
      const snake = await prisma.dream.findUniqueOrThrow({ where: { id: 'snake' } });
      expect([snake.contentStatus, snake.meaning]).toEqual(['DRAFT', 'แก้ด้วยมือ']);
      // restore for other suites
      await prisma.dream.update({ where: { id: 'snake' }, data: { contentStatus: 'SAMPLE' } });
      await seedSampleFixtures(prisma);
    });
  });

  describe('"ไม่ควรเสี่ยง", publish and sample removal', () => {
    it('imports and serves a dream with noLuckyNumbers (no numbers at all)', async () => {
      const file = {
        format: IMPORT_FORMAT,
        dreams: [
          {
            id: 'e2e-no-numbers',
            name: 'กรามทดสอบ',
            categoryId: 'animal',
            short: 'ทดสอบ',
            meaning: 'ข้อมูลทดสอบ',
            numbers: { twoDigit: [], threeDigit: [] },
            noLuckyNumbers: true,
            contentStatus: 'DRAFT',
          },
        ],
      };
      const v = validateImportFile(file, { categoryIds });
      expect(v.issues.filter((i) => i.severity === 'error')).toEqual([]);
      await applyImport(
        prisma,
        v,
        planImport(v, await loadSnapshot(prisma, [], ['e2e-no-numbers']), { update: false }),
      );
      await expect(
        prisma.dream.update({ where: { id: 'e2e-no-numbers' }, data: { twoDigit: ['01'] } }),
      ).rejects.toThrow();
      await expect(prisma.dream.update({ where: { id: 'e2e-cat-draft' }, data: { twoDigit: [] } })).rejects.toThrow();
    });

    it('publish turns the DRAFT dreams of a category into VERIFIED, which the API then serves', async () => {
      await http().get('/api/v1/dreams/e2e-no-numbers').expect(404);
      const dry = await publishCategory(prisma, 'animal', false);
      expect(dry.ids).toEqual(expect.arrayContaining(['e2e-cat-draft', 'e2e-no-numbers']));
      expect((await prisma.dream.findUniqueOrThrow({ where: { id: 'e2e-cat-draft' } })).contentStatus).toBe('DRAFT');
      const res = await publishCategory(prisma, 'animal', true);
      expect(res.published).toBe(res.ids.length);
      const detail = await http().get('/api/v1/dreams/e2e-no-numbers').expect(200);
      expect(detail.body.data).toMatchObject({
        contentStatus: 'VERIFIED',
        noLuckyNumbers: true,
        numbers: { twoDigit: [], threeDigit: [] },
        digits: [],
        source: null,
      });
      const tooth = await http().get('/api/v1/dreams/tooth-falling-out').expect(200);
      expect(tooth.body.data.noLuckyNumbers).toBe(false);
    });

    it('remove-sample deletes only SAMPLE dreams and the sample categories left empty', async () => {
      const keep = await prisma.dream.count({ where: { contentStatus: { not: 'SAMPLE' } } });
      const dry = await removeSample(prisma, false);
      expect(dry.dreamIds).toHaveLength(10);
      expect(await prisma.dream.count({ where: { contentStatus: 'SAMPLE' } })).toBe(10);
      const res = await removeSample(prisma, true);
      expect(res.categoryIds).not.toContain('animal'); // still used by the e2e content
      expect(await prisma.dream.count({ where: { contentStatus: 'SAMPLE' } })).toBe(0);
      expect(await prisma.dream.count()).toBe(keep);
      expect(await prisma.dreamCategory.findUnique({ where: { id: 'animal' } })).not.toBeNull();
      expect(await prisma.dreamCategory.findUnique({ where: { id: 'body' } })).toBeNull();
      const list = await http().get('/api/v1/dreams').expect(200);
      expect(list.body.data.every((d: { contentStatus: string }) => d.contentStatus === 'VERIFIED')).toBe(true);
    });
  });
});
