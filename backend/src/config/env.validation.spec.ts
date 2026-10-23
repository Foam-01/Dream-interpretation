import { parseCorsOrigins, validateEnv } from './env.validation';

const SECRET_URL = 'postgresql://user:super-secret-password@db.example.com/app';

describe('validateEnv', () => {
  it('accepts a valid config and converts PORT to a number', () => {
    const env = validateEnv({ DATABASE_URL: SECRET_URL, PORT: '8080', NODE_ENV: 'production' });
    expect(env.PORT).toBe(8080);
    expect(env.NODE_ENV).toBe('production');
  });

  it('applies defaults for NODE_ENV and PORT', () => {
    const env = validateEnv({ DATABASE_URL: SECRET_URL });
    expect(env.NODE_ENV).toBe('development');
    expect(env.PORT).toBe(3000);
  });

  it('rejects a missing DATABASE_URL', () => {
    expect(() => validateEnv({})).toThrow(/DATABASE_URL/);
  });

  it('rejects a non-postgres DATABASE_URL without echoing the value', () => {
    const bad = 'mysql://user:another-secret@host/db';
    let message = '';
    try {
      validateEnv({ DATABASE_URL: bad });
    } catch (e) {
      message = (e as Error).message;
    }
    expect(message).toMatch(/DATABASE_URL/);
    expect(message).not.toContain('another-secret');
    expect(message).not.toContain(bad);
  });

  it.each([['0'], ['70000'], ['abc']])('rejects invalid PORT %s', (port) => {
    expect(() => validateEnv({ DATABASE_URL: SECRET_URL, PORT: port })).toThrow(/PORT/);
  });

  it('rejects an unknown NODE_ENV', () => {
    expect(() => validateEnv({ DATABASE_URL: SECRET_URL, NODE_ENV: 'staging' })).toThrow(/NODE_ENV/);
  });
});

describe('parseCorsOrigins', () => {
  it('splits, trims and drops empty entries', () => {
    expect(parseCorsOrigins(' https://a.example , ,https://b.example ')).toEqual([
      'https://a.example',
      'https://b.example',
    ]);
  });

  it('returns an empty list when unset (CORS disabled)', () => {
    expect(parseCorsOrigins(undefined)).toEqual([]);
    expect(parseCorsOrigins('')).toEqual([]);
  });
});
