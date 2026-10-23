import { ConfigService } from '@nestjs/config';
import { NestExpressApplication } from '@nestjs/platform-express';
import { Test } from '@nestjs/testing';
import { AppModule } from '../src/app.module';
import { configureApp } from '../src/app.setup';
import { PrismaService } from '../src/prisma/prisma.service';

/**
 * Boots the real AppModule with the same HTTP pipeline as main.ts.
 * `databaseUrl` swaps only the Prisma connection (e.g. to simulate an unreachable database).
 */
export async function createApp(options: { databaseUrl?: string } = {}): Promise<NestExpressApplication> {
  let builder = Test.createTestingModule({ imports: [AppModule] });
  if (options.databaseUrl) {
    const config = { getOrThrow: () => options.databaseUrl } as unknown as ConfigService;
    builder = builder.overrideProvider(PrismaService).useValue(new PrismaService(config));
  }
  const moduleRef = await builder.compile();
  const app = moduleRef.createNestApplication<NestExpressApplication>({ bodyParser: false, logger: false });
  configureApp(app);
  await app.init();
  return app;
}
