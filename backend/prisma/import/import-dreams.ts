// Dream content importer (CLI). Safe by default:
//   npm run content:import -- --file <file.json>            validate only (no database)
//   npm run content:import -- --file <file.json> --plan     + compare with the database (read-only)
//   npm run content:import -- --file <file.json> --write    + apply creates/updates in one transaction
// The database is taken ONLY from a DATABASE_URL set in the shell (backend/.env is deliberately not read).
// A non-local database additionally needs --allow-remote-host=<exact host name>.
// Never deletes rows, never writes VERIFIED, never changes VERIFIED or seed SAMPLE rows.
import { readFileSync } from 'node:fs';
import { PrismaPg } from '@prisma/adapter-pg';
import { PrismaClient } from '../../generated/prisma/client';
import { allCategories } from '../seed-data';
import { isLocalDatabase } from '../seed';
import { validateImportFile, type Issue, type ValidationResult } from './dream-import';
import { applyImport, loadCategoryIds, loadSnapshot, planImport, summarise, type PlanItem } from './dream-import.db';

export interface CliArgs {
  file: string;
  plan: boolean;
  write: boolean;
  update: boolean;
  allowRemoteHost: string | null;
}

export class UsageError extends Error {}

export function parseArgs(argv: string[]): CliArgs {
  const args: CliArgs = { file: '', plan: false, write: false, update: false, allowRemoteHost: null };
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    if (a === '--file') args.file = argv[++i] ?? '';
    else if (a.startsWith('--file=')) args.file = a.slice('--file='.length);
    else if (a === '--plan') args.plan = true;
    else if (a === '--write') args.write = true;
    else if (a === '--update') args.update = true;
    else if (a.startsWith('--allow-remote-host=')) args.allowRemoteHost = a.slice('--allow-remote-host='.length);
    else throw new UsageError(`unknown argument ${a}`);
  }
  if (!args.file) throw new UsageError('--file <path> is required');
  if (args.update && !args.write && !args.plan)
    throw new UsageError('--update only makes sense with --plan or --write');
  return args;
}

/** Decides whether a database may be used, without ever printing credentials. */
export function checkTarget(
  url: string | undefined,
  args: Pick<CliArgs, 'allowRemoteHost' | 'write'>,
): { host: string; remote: boolean } {
  if (!url) {
    throw new UsageError(
      'DATABASE_URL is not set in this shell. The importer never reads backend/.env; set it explicitly for this command.',
    );
  }
  let host: string;
  try {
    host = new URL(url).hostname;
  } catch {
    throw new UsageError('DATABASE_URL is not a valid URL');
  }
  const remote = !isLocalDatabase(url);
  if (remote && args.allowRemoteHost !== host) {
    throw new UsageError(
      `refusing to use non-local database host "${host}". If this is intended, pass --allow-remote-host=${host}`,
    );
  }
  return { host, remote };
}

function printIssues(issues: Issue[]): void {
  for (const i of issues) console.log(`  ${i.severity === 'error' ? 'ERROR' : 'warn '}  ${i.path}: ${i.message}`);
}

function printValidation(v: ValidationResult): void {
  const s = v.stats;
  console.log(
    `Validation: ${s.dreamsInFile} dreams in file → ${s.validDreams} valid, ${s.invalidDreams} invalid` +
      ` (${s.duplicateIds} with duplicate ids); ${s.sourcesInFile} sources; ${s.warnings} warnings`,
  );
  printIssues(v.issues);
}

function printPlan(plan: PlanItem[]): void {
  const sum = summarise(plan);
  for (const kind of ['source', 'dream'] as const) {
    const c = sum[kind];
    console.log(
      `Plan (${kind}s): create ${c.create}, update ${c.update}, unchanged ${c.unchanged}, conflict ${c.conflict}, protected ${c.protected}`,
    );
  }
  for (const p of plan) {
    if (p.action === 'unchanged') continue;
    const detail = [p.changed?.length ? `fields: ${p.changed.join(', ')}` : '', p.reason ?? ''].filter(Boolean);
    console.log(`  ${p.action.padEnd(9)} ${p.kind} ${p.id}${detail.length ? ` (${detail.join('; ')})` : ''}`);
  }
}

/** Returns the process exit code: 0 ok, 1 invalid file, 2 refused (conflicts/guards), 3 usage error. */
export async function run(argv: string[], env: NodeJS.ProcessEnv = process.env): Promise<number> {
  let args: CliArgs;
  try {
    args = parseArgs(argv);
  } catch (e) {
    console.error(`Usage error: ${(e as Error).message}`);
    return 3;
  }
  let raw: unknown;
  try {
    raw = JSON.parse(readFileSync(args.file, 'utf8'));
  } catch (e) {
    console.error(`Cannot read ${args.file} as JSON: ${(e as Error).message}`);
    return 1;
  }

  if (!args.plan && !args.write) {
    const v = validateImportFile(raw, { categoryIds: new Set(allCategories.map((c) => c.id)) });
    printValidation(v);
    console.log('Mode: validate only (no database). Categories checked against the seeded list.');
    return v.issues.some((i) => i.severity === 'error') ? 1 : 0;
  }

  let target: { host: string; remote: boolean };
  try {
    target = checkTarget(env['DATABASE_URL'], args);
  } catch (e) {
    console.error(`Refused: ${(e as Error).message}`);
    return 3;
  }
  console.log(`Database: ${target.remote ? 'REMOTE' : 'local'} host ${target.host}`);
  const prisma = new PrismaClient({ adapter: new PrismaPg({ connectionString: env['DATABASE_URL']! }) });
  try {
    const categoryIds = await loadCategoryIds(prisma);
    const firstPass = validateImportFile(raw, { categoryIds });
    const fileSourceIds = firstPass.sources.map((s) => s.id);
    const referenced = [...new Set(firstPass.dreams.map((d) => d.sourceId).filter((x): x is string => !!x))];
    const dreamIds = Array.isArray((raw as { dreams?: unknown }).dreams)
      ? ((raw as { dreams: Array<{ id?: unknown }> }).dreams
          .map((d) => d?.id)
          .filter((x) => typeof x === 'string') as string[])
      : [];
    const snapshot = await loadSnapshot(prisma, [...new Set([...fileSourceIds, ...referenced])], dreamIds);
    // Second pass: sources that already exist in the database may be referenced without repeating them.
    const allSourceIds = new Set((await prisma.contentSource.findMany({ select: { id: true } })).map((s) => s.id));
    const v = validateImportFile(raw, { categoryIds, existingSourceIds: allSourceIds });
    printValidation(v);
    const plan = planImport(v, snapshot, { update: args.update });
    printPlan(plan);

    if (!args.write) {
      console.log('Mode: plan only (dry run). Nothing was written. Re-run with --write to apply.');
      return v.issues.some((i) => i.severity === 'error') ? 1 : 0;
    }
    if (v.issues.some((i) => i.severity === 'error')) {
      console.error('Refused: the file has errors. Nothing was written.');
      return 1;
    }
    if (plan.some((p) => p.action === 'conflict')) {
      console.error('Refused: conflicts above. Resolve them (or use --update for DRAFT rows). Nothing was written.');
      return 2;
    }
    if (target.remote && v.dreams.some((d) => d.contentStatus !== 'DRAFT' || d.hasPlaceholder)) {
      console.error('Refused: only DRAFT records without placeholders may be written to a remote database.');
      return 2;
    }
    const res = await applyImport(prisma, v, plan);
    console.log(`Written: ${res.created} created, ${res.updated} updated. No rows were deleted.`);
    return 0;
  } finally {
    await prisma.$disconnect();
  }
}

if (require.main === module) {
  run(process.argv.slice(2)).then(
    (code) => process.exit(code),
    (err: unknown) => {
      // Prisma errors may name the host but never the password; print the message only.
      console.error(err instanceof Error ? err.message : err);
      process.exit(1);
    },
  );
}
