import { defineConfig } from 'prisma/config';

// Load a local .env if present (Node >= 20.12). CI/production set real env vars instead.
try {
  process.loadEnvFile();
} catch {
  // no .env file: rely on the process environment
}

export default defineConfig({
  schema: 'prisma/schema.prisma',
  migrations: {
    path: 'prisma/migrations',
    seed: 'ts-node prisma/seed.ts',
  },
  // Used by the Prisma CLI only (migrate, validate). The app connects with DATABASE_URL via the pg adapter.
  // Poolers such as Neon's "-pooler" endpoint are not suitable for migrations; set DIRECT_DATABASE_URL to the
  // direct (non-pooled) connection string when running `prisma migrate deploy`.
  datasource: {
    url: process.env['DIRECT_DATABASE_URL'] || process.env['DATABASE_URL'],
  },
});
