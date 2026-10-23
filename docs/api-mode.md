# Sample mode and API mode

The app reads the dream catalogue through `DreamRepository` (`lib/data/dream_repository.dart`).
Which implementation is used is decided once at startup from a compile-time setting.

| `API_BASE_URL` | Repository | Network |
|---|---|---|
| absent or empty (default) | `SampleDreamRepository`: bundled SAMPLE data | none |
| valid `http(s)` URL | `ApiDreamRepository`: the NestJS backend (`backend/`) | yes |
| invalid URL | startup fails with `FormatException` | never silently switches to sample data |
| `http://` URL in a **release** build | startup fails with `FormatException` | release builds require HTTPS |

`API_BASE_URL` is the **versioned API root**. The path must end with `/api/v1` and contain it exactly once
(`https://host/api/v1` or `https://host/prefix/api/v1`). The client appends `dreams`, `dreams/<id>` and
`dream-categories` to it. The URL must not contain a query, fragment or credentials. The app only talks to the HTTP API.
Never put a database connection string in a Flutter build.

## Running

```bash
# Sample mode (default; what the tests and goldens use)
flutter run

# API mode against a backend on the dev machine, from the Android emulator
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000/api/v1

# Physical phone on the same Wi-Fi
flutter run --dart-define=API_BASE_URL=http://<dev-machine-LAN-IP>:3000/api/v1

# Release build against a deployed backend (HTTPS only)
flutter build apk --release --dart-define=API_BASE_URL=https://<api-host>/api/v1
```

Inside the Android emulator `localhost` is the emulator itself. `10.0.2.2` reaches the host machine.

Starting the local backend (see `backend/README.md`):

```bash
cd backend
npm run db:local                 # local PostgreSQL on 127.0.0.1:5433 (keep running)
npm run build
npm start                        # API on http://localhost:3000/api/v1
```

`npm start` reads `DATABASE_URL` from `backend/.env` unless a real environment variable overrides it.

### Android networking

- `INTERNET` permission is declared in `android/app/src/main/AndroidManifest.xml`. The debug and profile
  manifests already had it, but release builds did not.
- No cleartext (`http://`) exception was added. In a debug build on the emulator (Android 16,
  targetSdk 36), `dart:io` reached `http://10.0.2.2:3000` without one, because `dart:io` sockets do not go
  through Android's network security config.
- That means the Android cleartext policy cannot protect release builds. The app enforces this itself:
  `repositoryFromEnvironment` rejects non-HTTPS URLs when `kReleaseMode` is true. Plain HTTP stays
  available for debug/profile builds against a local backend.

## Release builds

```bash
# Sample-data release (no network use)
flutter build apk --release

# API release: YOUR-API-HOST is a placeholder for the deployed HTTPS backend
flutter build apk --release --dart-define=API_BASE_URL=https://YOUR-API-HOST/api/v1
```

**Signing (not set up yet).**
- `android/app/build.gradle.kts` still signs `release` with the **debug** key (Flutter template default).
  That is fine for local testing, but such an APK cannot be published or updated on Google Play.
- Before publishing:
  1. Create an upload keystore outside the repository.
  2. Add `android/key.properties` (git-ignore it) and a `release` signing config that reads it.
  3. Keep the keystore and passwords in a password manager or CI secret store.
- Do not change `applicationId` (`com.mahadream.maha_dream`) after the first store upload.

**What ends up in the APK.** Only the `API_BASE_URL` string. No database URL, password or API key belongs
in a `--dart-define`, because anything compiled into the app can be extracted. The read-only catalogue API
needs no client secret.

**Release smoke checklist** (device or emulator):

1. Home shows "ฝันยอดฮิตวันนี้" cards from the API.
2. Search lists 10 dreams, the "สัตว์" chip shows 4, and nonsense text shows "ไม่พบความฝันนี้ ลองคำอื่น".
3. ฟันหลุด shows `08 · 80` / `098 · 809`, and คนตาย shows `09 · 90` / `090 · 900`.
4. With flight mode on, the screens show "เชื่อมต่อเซิร์ฟเวอร์ไม่ได้ …" and "ลองใหม่", never sample cards.
   With it off again, "ลองใหม่" loads the data.
5. เลขเด็ด → สรุปเลขนำโชค 0–9 and the other local features still work. Back navigation returns
   feature → menu → home.

## What uses the API

| Screen | Request | Notes |
|---|---|---|
| Home "ฝันยอดฮิตวันนี้" | `GET /dreams?limit=5` | first five in catalogue order |
| Search list | `GET /dreams?q=&category=&limit=100` | `q` trimmed; case-sensitive substring of name or short summary; one page |
| Search category chips | `GET /dream-categories` | Thai labels from the API; filter sends the slug id; cached after the first success |
| Dream detail | `GET /dreams/<id>` | stable slug id; `DREAM_NOT_FOUND` shows "ไม่พบความฝันนี้" |

Category ids are `animal`, `body`, `nature`, `person` and `object`. The bundled list (`sampleCategories`) is
checked against `backend/prisma/seed-data.ts` by `test/dream_repository_test.dart`.

List items are `DreamSummary` (no meaning, advice, digits or forecast; the list endpoint does not return
them). The detail endpoint builds a full `Dream`. `contentStatus` (`SAMPLE`/`VERIFIED`) is parsed and kept on
`DreamSummary`. `Dream` has no field for it yet.

These features stay local in both modes: lucky digits 0–9 (the API list has no `digits`), the day/draw
formulas, Pae Kong, digit lore, animals, prayers/remedies and saved dreams (in memory). Tapping a dream from
the digit feature opens its detail by id, which in API mode is fetched from the API.

## Data rules

- Lucky numbers are strings end to end (`"08"`, `"098"`, `"09"`, `"090"`). The parser rejects numbers where
  strings are required, wrong widths, Thai digits and empty lists. It never converts or pads.
- Missing or malformed required fields, scores outside 0–100, a non-slug id, an unknown `contentStatus` or
  inconsistent paging metadata make the response invalid. Unknown extra fields are ignored.

## Loading, errors and retry (API mode)

- **Loading:** a centred gold `CircularProgressIndicator`.
- **Error:** a short Thai message and a gold "ลองใหม่" (retry) pill. Error messages never show server text,
  URLs or stack traces.
- **API down:** the app never falls back to sample data.
- **No results:** "ไม่พบความฝันนี้ ลองคำอื่น". This is distinct from a connection error.

| Failure | Message |
|---|---|
| no connection / DNS / TLS | เชื่อมต่อเซิร์ฟเวอร์ไม่ได้ กรุณาตรวจสอบอินเทอร์เน็ต |
| timeout (connect 5 s, response 10 s) | เซิร์ฟเวอร์ตอบช้าเกินไป |
| HTTP 5xx | เซิร์ฟเวอร์ขัดข้องชั่วคราว |
| HTTP 400 | คำค้นหาไม่ถูกต้อง |
| anything else (bad JSON, unexpected 404, …) | โหลดข้อมูลไม่สำเร็จ |

Search waits 300 ms after the last keystroke; a category tap searches at once. Each request carries a
generation number (`lib/state/load_request.dart`), so an older, slower response never replaces a newer one,
and responses that arrive after a screen is closed are ignored. A query longer than 50 characters (the API
limit) shows no results without a request.

In sample mode the repository answers synchronously. Screens therefore render on the first frame, as they did
before, with no loading flash and no debounce.

## Tests

```bash
flutter analyze
flutter test                     # includes the original golden tests (sample mode)
flutter test test/golden/

# Optional: check the client against a running backend (read-only GET requests)
LIVE_API_BASE_URL=http://localhost:3000/api/v1 flutter test test/live_api_contract_test.dart
```

| Test file | Covers |
|---|---|
| `test/api_dream_repository_test.dart` | URLs, parsing, rejection rules and HTTP errors with a fake transport; timeouts and refused connections with a loopback server |
| `test/app_config_test.dart` | sample/API selection, `/api/v1` rule, HTTPS required in release |
| `test/api_mode_screens_test.dart` | loading, error/retry, empty, debounce, stale responses and disposal on Home, Search and Result; sample mode makes no HTTP connections |
