// Idempotent seed of the app's existing SAMPLE dream data.
// - Upserts by stable id: running it twice creates no duplicates.
// - Never deletes rows.
// - Refuses non-local databases unless SEED_ALLOW_REMOTE=true is set explicitly.
import { PrismaPg } from '@prisma/adapter-pg';
import { ContentStatus, PrismaClient } from '../generated/prisma/client';
import { seedCategories, seedDreams } from './seed-data';

export function isLocalDatabase(url: string): boolean {
  try {
    const host = new URL(url).hostname;
    return host === 'localhost' || host === '127.0.0.1' || host === '::1' || host === '[::1]';
  } catch {
    return false;
  }
}

export async function seed(prisma: PrismaClient): Promise<{ categories: number; dreams: number }> {
  await prisma.$transaction(async (tx) => {
    for (const c of seedCategories) {
      await tx.dreamCategory.upsert({
        where: { id: c.id },
        create: c,
        update: { name: c.name, sortOrder: c.sortOrder },
      });
    }
    for (const d of seedDreams) {
      const data = { ...d, contentStatus: ContentStatus.SAMPLE };
      const { id, ...rest } = data;
      await tx.dream.upsert({ where: { id }, create: data, update: rest });
    }
  });
  return { categories: seedCategories.length, dreams: seedDreams.length };
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
    console.log(`Seeded ${result.categories} categories and ${result.dreams} SAMPLE dreams (upsert).`);
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
