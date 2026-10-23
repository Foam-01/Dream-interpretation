import {
  ArgumentsHost,
  BadRequestException,
  Catch,
  ExceptionFilter,
  HttpException,
  HttpStatus,
  Logger,
} from '@nestjs/common';
import type { Response } from 'express';
import { ApiErrorBody, ApiErrorCode, ApiException } from '../errors/api-error';

/**
 * Prisma error codes meaning "the database cannot be reached right now" (a
 * temporary condition the client may retry), as opposed to a bug. Prisma 7 with
 * the pg adapter reports socket errors by their Node code (e.g. ECONNREFUSED).
 */
const DATABASE_UNAVAILABLE_CODES = new Set([
  'P1001', // can't reach database server
  'P1002', // database server timed out
  'P1008', // operation timed out
  'P1017', // server closed the connection
  'P2024', // connection pool timeout
  'ECONNREFUSED',
  'ECONNRESET',
  'ETIMEDOUT',
  'ENOTFOUND',
  'EAI_AGAIN',
]);

function isDatabaseUnavailable(exception: unknown): boolean {
  if (!(exception instanceof Error)) return false;
  if (exception.name === 'PrismaClientInitializationError') return true;
  const code = (exception as { code?: unknown }).code;
  return (
    exception.name === 'PrismaClientKnownRequestError' &&
    typeof code === 'string' &&
    DATABASE_UNAVAILABLE_CODES.has(code)
  );
}

/** Maps every error to the API error envelope. Unknown errors become a generic 500 without internals. */
@Catch()
export class ApiExceptionFilter implements ExceptionFilter {
  private readonly logger = new Logger(ApiExceptionFilter.name);

  catch(exception: unknown, host: ArgumentsHost): void {
    const res = host.switchToHttp().getResponse<Response>();
    const { status, body } = this.toBody(exception);
    res.status(status).json(body);
  }

  private toBody(exception: unknown): { status: number; body: ApiErrorBody } {
    if (exception instanceof ApiException) {
      return this.build(exception.status, exception.code, exception.message, exception.details);
    }
    if (exception instanceof BadRequestException) {
      const response = exception.getResponse() as { message?: string | string[] };
      const details = Array.isArray(response.message) ? response.message : undefined;
      return this.build(HttpStatus.BAD_REQUEST, 'VALIDATION_ERROR', 'Invalid request', details);
    }
    if (exception instanceof HttpException) {
      const status = exception.getStatus();
      if (status === HttpStatus.NOT_FOUND) return this.build(status, 'NOT_FOUND', 'Route not found');
      if (status === HttpStatus.SERVICE_UNAVAILABLE)
        return this.build(status, 'SERVICE_UNAVAILABLE', 'Service unavailable');
      if (status < 500) return this.build(status, 'VALIDATION_ERROR', 'Invalid request');
      return this.build(status, 'INTERNAL_ERROR', 'Internal server error');
    }
    if (isDatabaseUnavailable(exception)) {
      // Expected during outages: one line with the error code, no stack or connection details.
      const code = (exception as { code?: unknown }).code;
      this.logger.warn(`Database unavailable (${typeof code === 'string' ? code : (exception as Error).name})`);
      return this.build(HttpStatus.SERVICE_UNAVAILABLE, 'SERVICE_UNAVAILABLE', 'Service unavailable');
    }
    // Log server-side only; the response never contains messages, stack traces or connection details.
    this.logger.error(exception instanceof Error ? exception.stack : String(exception));
    return this.build(HttpStatus.INTERNAL_SERVER_ERROR, 'INTERNAL_ERROR', 'Internal server error');
  }

  private build(status: number, code: ApiErrorCode, message: string, details?: string[]) {
    return { status, body: { error: { code, message, ...(details ? { details } : {}) } } };
  }
}
