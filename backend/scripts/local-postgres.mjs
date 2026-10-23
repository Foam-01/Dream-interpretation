// Starts a local PostgreSQL (no Docker needed) for development and tests.
//
//   npm run db:local                 -> port 5433, data in backend/.local-pg (git-ignored), kept on stop
//   LOCAL_PG_PORT=5544 npm run db:local
//
// The e2e test setup runs this with LOCAL_PG_EPHEMERAL=1 and its own LOCAL_PG_DIR so tests never
// touch the development data. Stop with Ctrl+C (or SIGTERM).
import EmbeddedPostgres from 'embedded-postgres';
import { existsSync } from 'node:fs';
import { fileURLToPath } from 'node:url';

const port = Number(process.env.LOCAL_PG_PORT ?? 5433);
const dataDir = process.env.LOCAL_PG_DIR ?? fileURLToPath(new URL('../.local-pg/data', import.meta.url));
const database = process.env.LOCAL_PG_DB ?? 'dreamapp_dev';
const ephemeral = process.env.LOCAL_PG_EPHEMERAL === '1';

// Local-only credentials for a database bound to localhost. Never reuse them elsewhere.
const pg = new EmbeddedPostgres({
  databaseDir: dataDir,
  user: 'dreamapp',
  password: 'dreamapp',
  port,
  persistent: !ephemeral,
  onLog: () => {},
});

if (!existsSync(dataDir)) await pg.initialise();
await pg.start();
try {
  await pg.createDatabase(database);
} catch {
  // already exists
}
console.log(`Local PostgreSQL ready on port ${port}.`);
console.log(`DATABASE_URL=postgresql://dreamapp:dreamapp@localhost:${port}/${database}?schema=public`);

const stop = async () => {
  await pg.stop();
  process.exit(0);
};
process.on('SIGINT', stop);
process.on('SIGTERM', stop);
// Parent (e.g. the test runner) can ask us to stop through stdin.
process.stdin.on('data', (chunk) => {
  if (chunk.toString().includes('stop')) void stop();
});
