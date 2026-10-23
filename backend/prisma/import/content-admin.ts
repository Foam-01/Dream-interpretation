// Content administration commands (CLI). Dry run by default; --write applies; same database guards as the
// importer (DATABASE_URL from the shell only, --allow-remote-host=<host> for a non-local database).
//
//   npm run content:publish -- --category letter-k [--write]
//       DRAFT → VERIFIED for every dream of the category (the content owner's approval to publish).
//   npm run content:remove-sample -- [--write]
//       Deletes the SAMPLE design dreams and the sample categories that are left empty.
//       Never touches DRAFT or VERIFIED rows.
import { PrismaPg } from '@prisma/adapter-pg';
import { PrismaClient } from '../../generated/prisma/client';
import { seedCategories } from '../seed-data';
import { checkTarget, UsageError } from './import-dreams';

interface AdminArgs {
  command: 'publish' | 'remove-sample';
  category: string | null;
  write: boolean;
  allowRemoteHost: string | null;
}

export function parseAdminArgs(argv: string[]): AdminArgs {
  const [command, ...rest] = argv;
  if (command !== 'publish' && command !== 'remove-sample')
    throw new UsageError('command must be publish or remove-sample');
  const args: AdminArgs = { command, category: null, write: false, allowRemoteHost: null };
  for (let i = 0; i < rest.length; i++) {
    const a = rest[i];
    if (a === '--category') args.category = rest[++i] ?? null;
    else if (a === '--write') args.write = true;
    else if (a.startsWith('--allow-remote-host=')) args.allowRemoteHost = a.slice('--allow-remote-host='.length);
    else throw new UsageError(`unknown argument ${a}`);
  }
  if (command === 'publish' && !args.category) throw new UsageError('publish needs --category <id>');
  return args;
}

/** DRAFT dreams of a category that would be (or were) published. */
export async function publishCategory(
  prisma: PrismaClient,
  categoryId: string,
  write: boolean,
): Promise<{ ids: string[]; published: number }> {
  const drafts = await prisma.dream.findMany({
    where: { categoryId, contentStatus: 'DRAFT' },
    select: { id: true },
    orderBy: { sortOrder: 'asc' },
  });
  const ids = drafts.map((d) => d.id);
  if (!write || ids.length === 0) return { ids, published: 0 };
  const res = await prisma.dream.updateMany({
    where: { id: { in: ids }, contentStatus: 'DRAFT' },
    data: { contentStatus: 'VERIFIED' },
  });
  return { ids, published: res.count };
}

/** SAMPLE dreams and the sample categories that would be empty afterwards. */
export async function removeSample(
  prisma: PrismaClient,
  write: boolean,
): Promise<{ dreamIds: string[]; categoryIds: string[] }> {
  const sample = await prisma.dream.findMany({
    where: { contentStatus: 'SAMPLE' },
    select: { id: true },
    orderBy: { sortOrder: 'asc' },
  });
  const sampleCategoryIds = seedCategories.map((c) => c.id);
  const stillUsed = await prisma.dream.findMany({
    where: { categoryId: { in: sampleCategoryIds }, contentStatus: { not: 'SAMPLE' } },
    select: { categoryId: true },
    distinct: ['categoryId'],
  });
  const used = new Set(stillUsed.map((d) => d.categoryId));
  const existing = await prisma.dreamCategory.findMany({
    where: { id: { in: sampleCategoryIds } },
    select: { id: true },
  });
  const categoryIds = existing.map((c) => c.id).filter((id) => !used.has(id));
  const dreamIds = sample.map((d) => d.id);
  if (write) {
    await prisma.$transaction([
      prisma.dream.deleteMany({ where: { id: { in: dreamIds }, contentStatus: 'SAMPLE' } }),
      prisma.dreamCategory.deleteMany({ where: { id: { in: categoryIds }, dreams: { none: {} } } }),
    ]);
  }
  return { dreamIds, categoryIds };
}

export async function runAdmin(argv: string[], env: NodeJS.ProcessEnv = process.env): Promise<number> {
  let args: AdminArgs;
  let target: { host: string; remote: boolean };
  try {
    args = parseAdminArgs(argv);
    target = checkTarget(env['DATABASE_URL'], args);
  } catch (e) {
    console.error(`Refused: ${(e as Error).message}`);
    return 3;
  }
  console.log(`Database: ${target.remote ? 'REMOTE' : 'local'} host ${target.host}`);
  const prisma = new PrismaClient({ adapter: new PrismaPg({ connectionString: env['DATABASE_URL']! }) });
  try {
    if (args.command === 'publish') {
      const res = await publishCategory(prisma, args.category!, args.write);
      console.log(
        `DRAFT dreams in category ${args.category}: ${res.ids.length}${res.ids.length ? ` (${res.ids.join(', ')})` : ''}`,
      );
      console.log(args.write ? `Published (VERIFIED): ${res.published}` : 'Dry run. Re-run with --write to publish.');
    } else {
      const res = await removeSample(prisma, args.write);
      console.log(`SAMPLE dreams: ${res.dreamIds.length}${res.dreamIds.length ? ` (${res.dreamIds.join(', ')})` : ''}`);
      console.log(
        `Empty sample categories: ${res.categoryIds.length}${res.categoryIds.length ? ` (${res.categoryIds.join(', ')})` : ''}`,
      );
      console.log(
        args.write ? 'Deleted. DRAFT and VERIFIED rows were not touched.' : 'Dry run. Re-run with --write to delete.',
      );
    }
    return 0;
  } finally {
    await prisma.$disconnect();
  }
}

if (require.main === module) {
  runAdmin(process.argv.slice(2)).then(
    (code) => process.exit(code),
    (err: unknown) => {
      console.error(err instanceof Error ? err.message : err);
      process.exit(1);
    },
  );
}
