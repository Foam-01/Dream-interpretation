import { ArgumentsHost, BadRequestException, NotFoundException, ServiceUnavailableException } from '@nestjs/common';
import { ApiException } from '../errors/api-error';
import { ApiExceptionFilter } from './api-exception.filter';

function run(exception: unknown) {
  const res = { status: jest.fn().mockReturnThis(), json: jest.fn() };
  const host = { switchToHttp: () => ({ getResponse: () => res }) } as unknown as ArgumentsHost;
  const filter = new ApiExceptionFilter();
  jest.spyOn((filter as unknown as { logger: { error: () => void } }).logger, 'error').mockImplementation(() => {});
  filter.catch(exception, host);
  return { status: res.status.mock.calls[0][0] as number, body: res.json.mock.calls[0][0] as unknown };
}

describe('ApiExceptionFilter', () => {
  it('keeps the code and details of an ApiException', () => {
    expect(run(new ApiException(404, 'DREAM_NOT_FOUND', 'Dream "x" not found'))).toEqual({
      status: 404,
      body: { error: { code: 'DREAM_NOT_FOUND', message: 'Dream "x" not found' } },
    });
  });

  it('maps validation errors to VALIDATION_ERROR with details', () => {
    const { status, body } = run(new BadRequestException(['limit must not be greater than 100']));
    expect(status).toBe(400);
    expect(body).toEqual({
      error: { code: 'VALIDATION_ERROR', message: 'Invalid request', details: ['limit must not be greater than 100'] },
    });
  });

  it('maps unknown routes to NOT_FOUND', () => {
    expect(run(new NotFoundException('Cannot GET /secret/path')).body).toEqual({
      error: { code: 'NOT_FOUND', message: 'Route not found' },
    });
  });

  it('maps 503 to SERVICE_UNAVAILABLE', () => {
    expect(run(new ServiceUnavailableException()).status).toBe(503);
  });

  it('hides internals of unexpected errors', () => {
    const { status, body } = run(new Error('connect ECONNREFUSED postgresql://user:pw@db.internal:5432'));
    expect(status).toBe(500);
    expect(body).toEqual({ error: { code: 'INTERNAL_ERROR', message: 'Internal server error' } });
    expect(JSON.stringify(body)).not.toMatch(/ECONNREFUSED|pw@|postgresql/);
  });
});
