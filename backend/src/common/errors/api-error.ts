/** Error envelope returned by every endpoint: `{ "error": { code, message, details? } }`. */
export interface ApiErrorBody {
  error: {
    code: ApiErrorCode;
    message: string;
    details?: string[];
  };
}

export type ApiErrorCode =
  'VALIDATION_ERROR' | 'NOT_FOUND' | 'DREAM_NOT_FOUND' | 'SERVICE_UNAVAILABLE' | 'INTERNAL_ERROR';

/** Thrown by services for domain-level errors with a stable code. */
export class ApiException extends Error {
  constructor(
    readonly status: number,
    readonly code: ApiErrorCode,
    message: string,
    readonly details?: string[],
  ) {
    super(message);
  }
}
