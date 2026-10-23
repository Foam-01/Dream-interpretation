import 'reflect-metadata';
import { plainToInstance, Type } from 'class-transformer';
import { IsIn, IsInt, IsOptional, IsString, Matches, Max, Min, validateSync } from 'class-validator';

export const NODE_ENVS = ['development', 'test', 'production'] as const;
export type NodeEnv = (typeof NODE_ENVS)[number];

/** Environment contract. Values are validated at startup; the app refuses to start on invalid config. */
export class EnvironmentVariables {
  @IsIn(NODE_ENVS)
  NODE_ENV: NodeEnv = 'development';

  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(65535)
  PORT: number = 3000;

  // Only the scheme is checked so the value (which contains credentials) is never echoed in errors.
  @IsString()
  @Matches(/^postgres(ql)?:\/\//, { message: 'DATABASE_URL must be a postgresql:// connection string' })
  DATABASE_URL: string;

  /** Comma-separated allowed browser origins; empty disables CORS. */
  @IsOptional()
  @IsString()
  CORS_ORIGINS?: string;
}

export function validateEnv(config: Record<string, unknown>): EnvironmentVariables {
  const env = plainToInstance(EnvironmentVariables, config, { enableImplicitConversion: true });
  const errors = validateSync(env, { skipMissingProperties: false });
  // Report variable names and rules only, never the received values.
  const details = errors.map((e) => `${e.property}: ${Object.values(e.constraints ?? {}).join(', ')}`);
  const badOrigins = parseCorsOrigins(env.CORS_ORIGINS).filter((o) => !isOrigin(o));
  if (badOrigins.length > 0) {
    // Origins are not secret, so naming them helps fix the setting.
    details.push(
      `CORS_ORIGINS: each entry must be an origin like https://app.example.com (got ${badOrigins.join(', ')})`,
    );
  }
  if (details.length > 0) throw new Error(`Invalid environment configuration -> ${details.join('; ')}`);
  return env;
}

/**
 * A browser origin: http(s) scheme, host and optional port; no path, query,
 * credentials or wildcard. `*` is rejected so CORS can never be opened to every
 * site by accident.
 */
export function isOrigin(value: string): boolean {
  if (!/^https?:\/\/[^/?#*\s]+$/.test(value)) return false;
  try {
    const url = new URL(value);
    return url.origin === value && url.username === '' && url.password === '';
  } catch {
    return false;
  }
}

export function parseCorsOrigins(raw: string | undefined): string[] {
  return (raw ?? '')
    .split(',')
    .map((o) => o.trim())
    .filter((o) => o.length > 0);
}
