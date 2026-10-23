export default async function globalTeardown(): Promise<void> {
  const child = globalThis.__E2E_PG__;
  if (!child || child.exitCode !== null) return;
  await new Promise<void>((resolve) => {
    const timer = setTimeout(() => {
      child.kill();
      resolve();
    }, 15_000);
    child.on('exit', () => {
      clearTimeout(timer);
      resolve();
    });
    child.stdin!.write('stop\n');
  });
}
