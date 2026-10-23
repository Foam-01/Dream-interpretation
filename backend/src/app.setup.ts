import { INestApplication, ValidationPipe } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { NestExpressApplication } from '@nestjs/platform-express';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import { ApiExceptionFilter } from './common/filters/api-exception.filter';
import { parseCorsOrigins } from './config/env.validation';

export const API_PREFIX = 'api/v1';

/** Shared HTTP setup used by main.ts and the e2e tests so both exercise the same pipeline. */
export function configureApp(app: NestExpressApplication): void {
  const config = app.get(ConfigService);
  app.setGlobalPrefix(API_PREFIX);
  app.useBodyParser('json', { limit: '10kb' });
  app.disable('x-powered-by');
  app.useGlobalPipes(new ValidationPipe({ whitelist: true, forbidNonWhitelisted: true, transform: true }));
  app.useGlobalFilters(new ApiExceptionFilter());
  const origins = parseCorsOrigins(config.get<string>('CORS_ORIGINS'));
  if (origins.length > 0) app.enableCors({ origin: origins, methods: ['GET'] });
  app.enableShutdownHooks();
}

export function setupSwagger(app: INestApplication): void {
  const doc = new DocumentBuilder()
    .setTitle('DreamApp API')
    .setDescription('Read-only dream catalogue for the ทำนายฝัน app. Content marked SAMPLE is demo data, not verified.')
    .setVersion('1.0.0')
    .build();
  SwaggerModule.setup(`${API_PREFIX}/docs`, app, () => SwaggerModule.createDocument(app, doc));
}
