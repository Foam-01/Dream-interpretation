import 'reflect-metadata';
import { Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { NestFactory } from '@nestjs/core';
import { NestExpressApplication } from '@nestjs/platform-express';
import { AppModule } from './app.module';
import { configureApp, setupSwagger } from './app.setup';

async function bootstrap(): Promise<void> {
  const app = await NestFactory.create<NestExpressApplication>(AppModule, { bodyParser: false });
  configureApp(app);
  const config = app.get(ConfigService);
  if (config.get('NODE_ENV') !== 'production') setupSwagger(app);
  const port = config.get<number>('PORT', 3000);
  await app.listen(port);
  new Logger('Bootstrap').log(`DreamApp API listening on port ${port}`);
}

bootstrap().catch((err: unknown) => {
  // Config errors contain variable names only (see validateEnv), never secret values.
  console.error(err instanceof Error ? err.message : err);
  process.exit(1);
});
