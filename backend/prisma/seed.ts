// Idempotent seed.
// - `npm run db:seed` (seed): creates the content categories (e.g. หมวด ก) only. Real dreams come from the
//   importer (npm run content:import); the old SAMPLE design dreams are no longer seeded.
// - seedSampleFixtures: the SAMPLE design dreams and categories, for automated tests only.
// - Upserts by stable id; never deletes; DRAFT/VERIFIED rows are never overwritten by sample data.
// - Refuses non-local databases unless SEED_ALLOW_REMOTE=true is set explicitly.
import { PrismaPg } from '@prisma/adapter-pg';
import { ContentStatus, PrismaClient } from '../generated/prisma/client';
import { allCategories, contentCategories, seedDreams } from './seed-data';

export function isLocalDatabase(url: string): boolean {
  try {
    const host = new URL(url).hostname;
    return host === 'localhost' || host === '127.0.0.1' || host === '::1' || host === '[::1]';
  } catch {
    return false;
  }
}

/** Production seed: content categories only. */
export async function seed(prisma: PrismaClient): Promise<{ categories: number }> {
  for (const c of contentCategories) {
    await prisma.dreamCategory.upsert({
      where: { id: c.id },
      create: c,
      update: { name: c.name, sortOrder: c.sortOrder },
    });
  }
  return { categories: contentCategories.length };
}

/** Test fixtures: every category plus the 10 SAMPLE design dreams. */
export async function seedSampleFixtures(
  prisma: PrismaClient,
): Promise<{ categories: number; dreams: number; protectedIds: string[] }> {
  const protectedIds: string[] = [];
  await prisma.$transaction(
    async (tx) => {
      for (const c of allCategories) {
        await tx.dreamCategory.upsert({
          where: { id: c.id },
          create: c,
          update: { name: c.name, sortOrder: c.sortOrder },
        });
      }
      for (const d of seedDreams) {
        const data = { ...d, contentStatus: ContentStatus.SAMPLE };
        const { id, ...rest } = data;
        const existing = await tx.dream.findUnique({ where: { id }, select: { contentStatus: true } });
        if (!existing) {
          await tx.dream.create({ data });
        } else if (existing.contentStatus === ContentStatus.SAMPLE) {
          await tx.dream.update({ where: { id }, data: rest });
        } else {
          // A DRAFT/VERIFIED row with this id holds real content: sample data must never overwrite it.
          protectedIds.push(id);
        }
      }
      // Remote databases (e.g. Neon) add per-query latency; the 5s default is too short for ~15 upserts.
    },
    { maxWait: 15_000, timeout: 120_000 },
  );
  return { categories: allCategories.length, dreams: seedDreams.length - protectedIds.length, protectedIds };
}

async function main(): Promise<void> {
  try {
    process.loadEnvFile();
  } catch {
    // no .env file
  }
  const url = process.env['DATABASE_URL'];
  if (!url) throw new Error('DATABASE_URL is not set');
  if (!isLocalDatabase(url) && process.env['SEED_ALLOW_REMOTE'] !== 'true') {
    throw new Error(
      'Refusing to seed a non-local database. Set SEED_ALLOW_REMOTE=true only for a confirmed dev database.',
    );
  }
  const prisma = new PrismaClient({ adapter: new PrismaPg({ connectionString: url }) });
  try {
    const result = await seed(prisma);
    console.log(`Seeded ${result.categories} content categories (upsert). No dreams are seeded.`);
  } finally {
    await prisma.$disconnect();
  }
}

if (require.main === module) {
  main().catch((err: unknown) => {
    console.error(err instanceof Error ? err.message : err);
    process.exit(1);
  });
}
