import { ChildProcess, execFileSync, spawn } from 'node:child_process';
import { mkdtempSync } from 'node:fs';
import { createServer } from 'node:net';
import { tmpdir } from 'node:os';
import { join } from 'node:path';

// Starts an isolated, ephemeral PostgreSQL for the e2e suite, applies the real migrations and
// exposes its URL as process.env.DATABASE_URL. Never uses the developer's .env database.

declare global {
  var __E2E_PG__: ChildProcess | undefined;
}

function freePort(): Promise<number> {
  return new Promise((resolve, reject) => {
    const srv = createServer();
    srv.listen(0, '127.0.0.1', () => {
      const { port } = srv.address() as { port: number };
      srv.close(() => resolve(port));
    });
    srv.on('error', reject);
  });
}

export default async function globalSetup(): Promise<void> {
  const root = join(__dirname, '..', '..');
  const port = await freePort();
  const dir = join(mkdtempSync(join(tmpdir(), 'dreamapp-e2e-')), 'data');
  const child = spawn(process.execPath, [join(root, 'scripts', 'local-postgres.mjs')], {
    env: {
      ...process.env,
      LOCAL_PG_PORT: String(port),
      LOCAL_PG_DIR: dir,
      LOCAL_PG_DB: 'dreamapp_e2e',
      LOCAL_PG_EPHEMERAL: '1',
    },
    stdio: ['pipe', 'pipe', 'inherit'],
  });
  globalThis.__E2E_PG__ = child;

  await new Promise<void>((resolve, reject) => {
    const timer = setTimeout(() => reject(new Error('local PostgreSQL did not start within 90s')), 90_000);
    child.stdout!.on('data', (buf: Buffer) => {
      if (buf.toString().includes('Local PostgreSQL ready')) {
        clearTimeout(timer);
        resolve();
      }
    });
    child.on('exit', (code) => reject(new Error(`local PostgreSQL exited early (code ${code})`)));
  });

  const url = `postgresql://dreamapp:dreamapp@localhost:${port}/dreamapp_e2e?schema=public`;
  process.env.DATABASE_URL = url;
  process.env.NODE_ENV = 'test';
  // Apply the committed migrations exactly as production would (migrate deploy, not db push).
  execFileSync(process.execPath, [join(root, 'node_modules', 'prisma', 'build', 'index.js'), 'migrate', 'deploy'], {
    cwd: root,
    env: { ...process.env, DATABASE_URL: url },
    stdio: 'ignore',
  });
}
