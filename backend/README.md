# DreamApp API (backend)

Read-only REST API that serves the dream catalogue of the ทำนายฝัน Flutter app.

- NestJS 12 · TypeScript 6 · Prisma 7 (node-postgres driver adapter) · PostgreSQL
- All current content is **SAMPLE** (design/demo data copied from the app), not verified traditional knowledge.
  Every dream carries `contentStatus: "SAMPLE"`.

## Requirements

- Node.js ≥ 20.19 (developed on 24.x), npm
- A PostgreSQL database. Two local options that need no cloud access:
  - `npm run db:local` — embedded PostgreSQL, no Docker needed (data in `backend/.local-pg`, git-ignored)
  - `docker compose up -d db` — PostgreSQL 18 on `127.0.0.1:5433` (volume `dreamapp-pg`)

## Setup

```bash
cd backend
npm install            # also runs `prisma generate`
cp .env.example .env   # then edit DATABASE_URL (never commit .env)
```

Environment variables (validated at startup; the app exits with a message naming the bad variable, never its value):

| Variable | Required | Default | Notes |
|---|---|---|---|
| `DATABASE_URL` | yes | – | `postgresql://…`. Real environment variables override `.env`. |
| `PORT` | no | `3000` | 1–65535 |
| `NODE_ENV` | no | `development` | `development` \| `test` \| `production`. Swagger UI is disabled in production. |
| `CORS_ORIGINS` | no | empty | Comma-separated browser origins. Empty disables CORS (the mobile app does not need it). |

## Database

```bash
# 1. start a local database (keep this terminal open)
npm run db:local
# prints: DATABASE_URL=postgresql://dreamapp:dreamapp@localhost:5433/dreamapp_dev?schema=public

# 2. apply migrations
npm run db:migrate:deploy

# 3. seed the app's sample data (idempotent upsert; never deletes rows)
npm run db:seed
```

- Schema: `prisma/schema.prisma`; migrations: `prisma/migrations/` (use `prisma migrate`, not `db push`).
- The init migration adds CHECK constraints Prisma cannot express: slug ids, non-empty digit-string
  arrays with fixed width (`'08'`, `'098'`), scores 0–100.
- To change the schema in development: edit `schema.prisma`, then `npm run db:migrate:dev -- --name <change>`
  against a **local** database.
- Seed safety: `prisma/seed.ts` refuses non-local hosts unless `SEED_ALLOW_REMOTE=true` is set explicitly.
  Do not seed production with sample data.

### Neon (managed PostgreSQL)

Put the Neon connection string in `DATABASE_URL` (in `.env` locally, or the deployment's secret store).
The pooled endpoint works for the app. Before running `npm run db:migrate:deploy` against Neon, confirm
the branch is the intended one (use a dedicated dev branch for development). Never run
`prisma migrate reset` against Neon.

## Run

```bash
npm run start:dev      # watch mode
npm run build && npm start
```

- API base: `http://localhost:3000/api/v1`
- OpenAPI UI (non-production): `http://localhost:3000/api/v1/docs`

## Endpoints

| Method | Path | Description |
|---|---|---|
| GET | `/api/v1/health` | Liveness: `{"status":"ok"}`; never touches the database |
| GET | `/api/v1/health/ready` | Readiness: 200 `{"status":"ok","database":"up"}` or 503 `{"status":"unavailable","database":"down"}` |
| GET | `/api/v1/dreams` | Paginated list (`page`, `limit` ≤ 100, `q`, `category`) |
| GET | `/api/v1/dreams/:id` | Detail by stable slug id; 404 `DREAM_NOT_FOUND` |
| GET | `/api/v1/dream-categories` | Categories in app order |

Errors always use `{"error":{"code","message","details?"}}` with codes
`VALIDATION_ERROR` (400), `NOT_FOUND`/`DREAM_NOT_FOUND` (404), `SERVICE_UNAVAILABLE` (503), `INTERNAL_ERROR` (500).
Unknown query parameters are rejected. 500 responses never include messages, stack traces or connection details.

See [docs/flutter-integration.md](docs/flutter-integration.md) for the full contract and app mapping.

## Tests

```bash
npm test               # unit tests (no database)
npm run test:e2e       # starts an isolated, throwaway PostgreSQL, applies migrations, runs HTTP tests
npm run lint           # TypeScript type check
npm run format:check
npx prisma validate
```

The e2e suite never uses `.env`'s database: it starts its own PostgreSQL on a free port and refuses to run
against a non-local host.

## Docker

```bash
docker compose up -d db                      # local PostgreSQL only
docker build -t dreamapp-api .
docker run --rm -p 3000:3000 -e DATABASE_URL=... dreamapp-api
docker compose down                          # stops; the dreamapp-pg volume is kept
```

The image contains no secrets; `DATABASE_URL` is supplied at runtime. Migrations are run from a machine
with the dev dependencies (`npm run db:migrate:deploy`), not from the runtime image.

## Scope

Read-only catalogue. Not implemented on purpose (no requirement yet): authentication, user accounts,
saved-dream sync, admin/content editing, write endpoints. Day/draw formulas and Pae Kong stay in the app.
