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
  datasource: {
    url: process.env['DATABASE_URL'],
  },
});
