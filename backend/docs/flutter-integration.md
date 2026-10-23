# Flutter integration contract

Status: **connected.** The Flutter app uses this API when built with `--dart-define=API_BASE_URL=...`
and the bundled sample data otherwise. See [docs/api-mode.md](../../docs/api-mode.md) for app-side behaviour.

## Base URL

| Where the app runs | Base URL |
|---|---|
| Android emulator → API on the dev machine | `http://10.0.2.2:3000/api/v1` (`localhost` inside the emulator is the emulator itself) |
| Physical phone on the same Wi-Fi | `http://<dev-machine-LAN-IP>:3000/api/v1` |
| Production | `https://<api-host>/api/v1` (HTTPS only) |

Provide it at build time, e.g. `--dart-define=API_BASE_URL=...`. Android blocks cleartext HTTP by default
for release builds; only debug builds may use `http://`. No secrets belong in the app.

## Endpoints

### `GET /dreams`

Query: `page` (≥1, default 1), `limit` (1–100, default 20), `q` (≤50 chars), `category` (id from `/dream-categories`).
`sort`: `catalogue` (default, curated order) or `name` (Thai dictionary order ก–ฮ, computed with ICU collation).
`q` also matches an exact alias.
Unknown parameters → 400.

Search semantics match the app today: `q` is trimmed, then matched as a **case-sensitive substring** of the
dream `name` **or** `short`. It does not search `meaning` or numbers. Empty `q` = no text filter.
`category` absent = all categories (the app's "ทั้งหมด" maps to *no* `category` parameter).
Order is stable: the app's current list order.

```json
{
  "data": [
    {
      "id": "tooth-falling-out",
      "name": "ฟันหลุด",
      "category": { "id": "body", "name": "ร่างกาย" },
      "short": "ระวังเรื่องญาติผู้ใหญ่ สุขภาพ",
      "isGoodOmen": false,
      "numbers": { "twoDigit": ["08", "80"], "threeDigit": ["098", "809"] },
      "contentStatus": "SAMPLE"
    }
  ],
  "meta": { "page": 1, "limit": 20, "total": 10, "totalPages": 1 }
}
```

### `GET /dreams/:id`

```json
{
  "data": {
    "id": "tooth-falling-out",
    "name": "ฟันหลุด",
    "category": { "id": "body", "name": "ร่างกาย" },
    "short": "ระวังเรื่องญาติผู้ใหญ่ สุขภาพ",
    "isGoodOmen": false,
    "numbers": { "twoDigit": ["08", "80"], "threeDigit": ["098", "809"] },
    "contentStatus": "SAMPLE",
    "meaning": "ฝันว่าฟันหลุด ตำราว่าเป็นลางเตือนเรื่องญาติผู้ใหญ่หรือคนในบ้าน ควรดูแลสุขภาพและระมัดระวังการเดินทาง",
    "advice": "ตื่นเช้าให้บ้วนน้ำลายลงดิน กล่าว \"ขอให้ฝันร้ายกลายเป็นดี\" แล้วกรวดน้ำให้เจ้ากรรมนายเวร",
    "digits": ["0", "8"],
    "luckForecast": { "money": 45, "love": 40, "health": 58 }
  }
}
```

Unknown id → `404 {"error":{"code":"DREAM_NOT_FOUND","message":"Dream \"x\" not found"}}`.
Malformed id (not a lowercase slug) → 400 `VALIDATION_ERROR`.

### `GET /dream-categories`

`{"data":[{"id":"animal","name":"สัตว์"},{"id":"body","name":"ร่างกาย"},{"id":"nature","name":"ธรรมชาติ"},{"id":"person","name":"บุคคล"},{"id":"object","name":"สิ่งของ"}]}`

### Content metadata (added with migration `0002_content_metadata`)

These changes are additive and backward compatible: the existing fields keep their meaning.

| Field | Where | Type | Notes |
|---|---|---|---|
| `image` | list + detail | object or `null` | `{url (https), alt?, credit, license, sourceUrl?}`; credit and license are always present with an image |
| `source` | detail | object or `null` | `{id, title, author?, publisher?, edition?, year?, url?, locator?}`: citation of the text |
| `aliases` | detail | string[] | extra search keywords |
| `isGoodOmen` | list + detail | boolean or **`null`** | null when the source does not say |
| `noLuckyNumbers` | list + detail | boolean | `true` = the source says "ไม่ควรเสี่ยง"; both number lists are then empty (absent in the first API version = false) |
| `advice` | detail | string or **`null`** | |
| `luckForecast` | detail | object or **`null`** | scores exist only in SAMPLE data |
| `digits` | detail | string[] (**may be empty**) | |

- The app's offline (bundled) data is the real หมวด ก content, not sample data any more.
- `contentStatus` is still `SAMPLE` or `VERIFIED` in responses. `DRAFT` rows are never served (list, search,
  count and detail all exclude them).
- The Flutter parser accepts responses without `image`/`source`/`aliases` (the first API version).
- The Flutter parser requires `advice`, `isGoodOmen` and `luckForecast` to be present, with `null` allowed.
- Older app builds without these changes still parse SAMPLE-only responses unchanged. A record with
  `null` advice/forecast/omen or empty digits would fail in those builds. No such build was released.
- How content gets in: [content-import.md](content-import.md).

## Mapping to the current Flutter model (`lib/data/design_data.dart`)

| Flutter | API | Notes |
|---|---|---|
| `DreamSummary` | list item | `GET /dreams` items; `Dream` is built only from the detail |
| `Dream.id` | `id` | Same stable slugs |
| `name` | `name` | |
| `cat` (Thai name) | `category.name` (+ `category.id`) | Filter by `category.id` |
| `short`, `meaning`, `advice` | same | |
| `good` | `isGoodOmen` | |
| `digits` | `digits` | Detail only |
| `numbers.twoDigit` / `threeDigit` | `numbers.twoDigit` / `threeDigit` | **Strings**. Build with `LuckyNumbers.copy(...)` and call `validate()` |
| `two` / `three` / `firstTwo` | derived | `join(' · ')` / first element — same as the app's getters |
| `luckForecast.money/love/health` | `luckForecast.*` | Detail only. Check with `LuckForecast.check` (assertions are off in release) |
| – | `contentStatus` | New: show/handle `SAMPLE` vs `VERIFIED` |

Rules for the client parser:
- Never parse lucky numbers as `int` (`"08"` would become `8`). Reject non-string values instead of converting.
- Ignore unknown JSON fields (forward compatible). Treat missing required fields as a format error.
- List items do not contain `meaning`, `advice`, `digits` or `luckForecast`; fetch the detail for those.

## Errors, timeouts and offline

- Error body: `{"error":{"code","message","details?"}}`. Show a friendly Thai message; do not display `message` verbatim.
- 5xx/timeouts/no network: keep the current sample data as the offline fallback, or show the existing empty-state
  style with a retry action — decide in the integration milestone.
- Suggested client timeouts: connect 5 s, receive 10 s. Retry idempotent GETs with backoff on network errors/503 only.
- Debounce search input (e.g. 300 ms) and ignore out-of-order responses.

## What stays in the app (not in the API)

Day-based formulas (`dayData`), draw dates and draw-card sample content, Pae Kong generation (`paeOf`),
digit lore, animals, remedies/prayers, menus/tabs/navigation, saved dreams (in-memory, local only).
