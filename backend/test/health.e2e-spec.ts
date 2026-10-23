import { NestExpressApplication } from '@nestjs/platform-express';
import request from 'supertest';
import { createApp } from './helpers';

describe('Health (e2e)', () => {
  describe('with the database up', () => {
    let app: NestExpressApplication;
    beforeAll(async () => (app = await createApp()));
    afterAll(async () => app.close());

    it('GET /health is live', async () => {
      await request(app.getHttpServer()).get('/api/v1/health').expect(200, { status: 'ok' });
    });

    it('GET /health/ready reports the database', async () => {
      await request(app.getHttpServer()).get('/api/v1/health/ready').expect(200, { status: 'ok', database: 'up' });
    });
  });

  describe('with the database unreachable', () => {
    let app: NestExpressApplication;

    beforeAll(async () => {
      // Port 1 on localhost: nothing listens, so connections fail fast.
      app = await createApp({ databaseUrl: 'postgresql://nobody:nothing@127.0.0.1:1/none?connect_timeout=2' });
    });
    afterAll(async () => app.close());

    it('liveness still passes (does not depend on the database)', async () => {
      await request(app.getHttpServer()).get('/api/v1/health').expect(200, { status: 'ok' });
    });

    it('readiness returns 503', async () => {
      await request(app.getHttpServer())
        .get('/api/v1/health/ready')
        .expect(503, { status: 'unavailable', database: 'down' });
    });

    it('data endpoints return 503 (retryable) without leaking connection details', async () => {
      const res = await request(app.getHttpServer()).get('/api/v1/dreams').expect(503);
      expect(res.body).toEqual({ error: { code: 'SERVICE_UNAVAILABLE', message: 'Service unavailable' } });
      expect(JSON.stringify(res.body)).not.toMatch(/nobody|nothing|127\.0\.0\.1|ECONNREFUSED/);
    });
  });
});
