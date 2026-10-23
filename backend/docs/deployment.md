# Deploying the DreamApp API

Status: **prepared, not deployed.** No hosting service has been created. Every command below is meant for
whoever runs the deployment, with their own platform account.

## What gets deployed

- **Process:** a stateless Node.js (24.x) HTTP server. It is read-only towards PostgreSQL (Neon).
- **Build:** the [Dockerfile](../Dockerfile) in `backend/`, or the commands below on a Node buildpack.
- **Runtime:** the image contains no secrets. Configuration comes from environment variables.

| Step | Command (from `backend/`) |
|---|---|
| Install | `npm ci` (also runs `prisma generate`) |
| Build | `npm run build` → `dist/src/main.js` |
| Start | `npm start` (`node dist/src/main.js`) |
| Container | `docker build -t dreamapp-api .` then `docker run -p 3000:3000 -e DATABASE_URL=... dreamapp-api` |

The server listens on `PORT` (default 3000) on all interfaces. Platforms that inject `PORT` (often 8080) work
without changes. The Docker `HEALTHCHECK` follows `PORT` as well.

## Environment variables (set in the platform's secret store)

| Variable | Required | Notes |
|---|---|---|
| `DATABASE_URL` | yes | Neon connection string (pooled endpoint is fine for the app). **Secret.** |
| `NODE_ENV` | yes in production | `production` turns off Swagger UI. The Docker image sets it already |
| `PORT` | no | usually injected by the platform |
| `CORS_ORIGINS` | no | comma-separated browser origins; empty for the mobile app (see CORS below) |
| `DIRECT_DATABASE_URL` | no, migrations only | direct (non-pooled) Neon URL for `prisma migrate deploy`; not read by the server. **Secret.** |

- The server validates these at startup. On a bad value it exits with a message that names the variable,
  never its value.
- Never put any of these values in the Flutter app, the Docker image, Git, README files or CI logs.

## Health checks

| Path | Purpose | Database | Responses |
|---|---|---|---|
| `/api/v1/health` | liveness: restart the process if this fails | not touched | `200 {"status":"ok"}` |
| `/api/v1/health/ready` | readiness: route traffic only when this passes | `SELECT 1` | `200 {"status":"ok","database":"up"}` / `503 {"status":"unavailable","database":"down"}` |

- Point the platform's health check at `/api/v1/health`. Use `/health/ready` for readiness or a
  post-deploy check if the platform supports it.
- Do not use readiness for liveness: a Neon outage would otherwise restart healthy containers in a loop.
- While the database is down, data endpoints answer `503 SERVICE_UNAVAILABLE`, which is retryable. The
  app shows its retry state.

## Database migrations (Prisma)

Migrations are **never** run by the image or at container start. Seeds are never run in production. Neon
already holds the reviewed `20261023062740_init` migration and the SAMPLE catalogue.

For a future release that adds a migration:

1. **Protect the data.** Create a Neon branch or snapshot of the production branch before migrating, so it
   can be restored.
2. **Check the target.** Confirm the Neon project and branch, and that the release contains only reviewed
   migrations (`prisma/migrations/`). Run `npx prisma migrate status` first.
3. **Apply.** From a trusted machine or a manually approved CI job:
   `DIRECT_DATABASE_URL=<direct URL> npm run db:migrate:deploy`. Use the direct (non-pooled) endpoint;
   connection poolers are not suitable for migrations.
4. **Start.** Deploy the new application version.
5. **Verify.** Check `GET /api/v1/health/ready`, then `GET /api/v1/dreams?limit=1` and
   `GET /api/v1/dreams/tooth-falling-out` (numbers must still read `"08"`, `"098"`).
6. **Roll back.**
   - Application: redeploy the previous image or revision.
   - Schema: write migrations to be backward compatible (add, then remove in a later release) so the
     previous version keeps working. If data must be restored, use the Neon branch or snapshot from step 1.
   - Never run `prisma migrate reset` or `db push` against Neon.

## CORS

- **Native Flutter app (Android/iOS):** CORS does not apply. It is a browser rule, and native HTTP clients
  send no `Origin` checks. Leave `CORS_ORIGINS` empty, and the server sends no CORS headers.
- **A future browser client** (Flutter web, admin page): list its exact origins, e.g.
  `CORS_ORIGINS=https://app.example.com`.
  - The server accepts only `http(s)://host[:port]` entries and refuses to start on `*`, paths or credentials.
  - Only `GET` is allowed. The API uses no cookies or credentials, so there is never a reason for a wildcard
    with credentials.
- Do not open CORS to make emulator or device tests pass: they do not need it.

## HTTPS

- Serve the API only over HTTPS. The platform terminates TLS.
- Release builds of the Flutter app refuse a non-`https://` `API_BASE_URL`. `dart:io` does not apply
  Android's cleartext policy, so this check is what enforces encryption.
- The server itself speaks plain HTTP behind the platform's TLS proxy. Do not expose the container port
  directly to the internet.

## Logging

- Startup logs list routes and the port. Request bodies, headers and query strings are not logged.
- Unexpected errors are logged server-side with a stack trace. Database outages log one warning line with
  the error code only. Responses never contain messages, stack traces or connection details.
- Prisma error messages can contain the database host name, but never the password. Keep platform logs
  private.
- There is no request-level rate limiting in the app. If abuse becomes a concern, use the platform's or a
  CDN's rate limiting before adding application middleware.

## Choosing a platform

- Any platform that runs a Docker image or a Node 24 process, injects secrets as environment variables,
  terminates HTTPS and supports an HTTP health check will work, for example Google Cloud Run, Render or
  Fly.io.
- Pick a region close to the Neon project's region: every request makes 1–2 database round trips.
- **Recommended default: a managed container service running the existing Dockerfile.** It uses one build
  definition that is already tested locally, avoids provider-specific build configuration, and keeps the
  same image portable between providers. [INFERENCE: verify the chosen provider's current docs for port
  injection and health-check settings.]
- Scale-to-zero platforms add a cold start (Node start plus first Neon connection, which may also be
  waking from suspend). The app's 10 s receive timeout covers this, but the first request after idle can
  be slow.

No provider-specific config file (e.g. `render.yaml`, `fly.toml`, `app.yaml`) is committed. Add one when a
provider is chosen, with that provider's real service name. Never commit placeholder service IDs or URLs.

## Post-deploy verification (read-only)

```bash
API=https://<your-api-host>/api/v1
curl -fsS "$API/health"
curl -fsS "$API/health/ready"
curl -fsS "$API/dream-categories"
curl -fsS "$API/dreams/tooth-falling-out"     # numbers "08", "098"
curl -s -o /dev/null -w '%{http_code}\n' "$API/docs"   # 404 in production
LIVE_API_BASE_URL=$API flutter test test/live_api_contract_test.dart   # from the repository root
```

## Troubleshooting

| Symptom | Likely cause |
|---|---|
| Exits at start with `Invalid environment configuration -> DATABASE_URL ...` | missing secret or not a `postgresql://` URL |
| Exits with `CORS_ORIGINS: each entry must be an origin ...` | `*`, a path or a typo in `CORS_ORIGINS` |
| `/health` 200 but `/health/ready` 503 | Neon unreachable, wrong credentials, or the Neon compute is suspended and still waking |
| Data endpoints return 503 | same as above; check the platform logs for `Database unavailable (<code>)` |
| `migrate deploy` hangs or errors through the pooler | use `DIRECT_DATABASE_URL` with the direct endpoint |
| App shows "เชื่อมต่อเซิร์ฟเวอร์ไม่ได้" | wrong `API_BASE_URL` (must end in `/api/v1`), DNS, or the service is down |
