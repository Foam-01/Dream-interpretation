# Importing dream content (Category 1: dream predictions)

The importer checks a JSON file and, only when explicitly asked, writes it to a database. It is meant for real
content transcribed from a citable source. Nothing in the repository is real content yet. The 10 bundled dreams are
`SAMPLE` design data, and [content/templates/dreams.template.json](../content/templates/dreams.template.json) holds
placeholder test records only.

## Current state (หมวด ก)

- The app and the local database now carry the **real หมวด ก content (33 predictions)**. The former 10 SAMPLE
  design dreams were removed (`content:remove-sample`). They survive only as test fixtures.
- The content owner approved publication without a cited source. Records have `source: null`, and the app names no
  source (no "ตำราโบราณ" claim).
- `ไม่ควรเสี่ยง` entries use `"noLuckyNumbers": true` with empty numbers. API and app show "ไม่ควรเสี่ยง".
- The bundled app data `lib/data/dreams_k.dart` is generated from the import file:
  `node scripts/generate-flutter-content.mjs`. A test fails if the two differ.

## Status workflow

| Status | Meaning | Public API |
|---|---|---|
| `SAMPLE` | demo/test data, not from a source | served (as today) |
| `DRAFT` | transcribed from a cited source, **not yet reviewed** | **never served** |
| `VERIFIED` | reviewed against the source | served |

- The importer writes only `SAMPLE` or `DRAFT`. A file containing `VERIFIED` is rejected.
- Publishing is a separate, explicit step: `npm run content:publish -- --category letter-k [--write]` sets
  DRAFT → VERIFIED (the content owner's approval). A source is recommended but optional; a missing one is
  reported as a warning.

## File format (`dreamapp-dreams/v1`)

```jsonc
{
  "format": "dreamapp-dreams/v1",
  "sources": [                          // text sources, cited by id
    { "id": "slug", "title": "required", "author": "", "publisher": "", "edition": "",
      "year": 2510,                     // integer as printed; say B.E./C.E. in "note"
      "url": "https://… (optional)", "note": "" }
  ],
  "dreams": [
    {
      "id": "stable-slug",              // never reused, never a list position
      "name": "งู",                     // the dream keyword as shown (ก–ฮ sorting uses it)
      "categoryId": "animal",           // animal | body | nature | person | object
      "aliases": ["อสรพิษ"],             // optional extra search words (exact match)
      "short": "one-line summary of the source's text",
      "meaning": "the interpretation as written in the source",
      "numbers": { "twoDigit": ["08"], "threeDigit": ["098"] },   // STRINGS, never numbers
      "noLuckyNumbers": false,          // true = source says "ไม่ควรเสี่ยง"; numbers must then be empty
      "digits": ["0", "8"],             // optional single digits
      "advice": "…",                    // optional, only if the source gives it
      "isGoodOmen": true,               // optional, only if the source says so
      "source": { "id": "slug", "locator": "หน้า 12" },           // optional (warning when missing)
      "image": {                        // optional; attribution required with it
        "url": "https://…", "alt": "…", "credit": "owner/artist", "license": "CC BY 4.0",
        "sourceUrl": "https://… (page the image came from)" },
      "contentStatus": "DRAFT"          // DRAFT for real content; SAMPLE only for test data
    }
  ]
}
```

There are no forecast scores (`luckForecast`) in the format. They exist only in the SAMPLE design data, and real
records must not invent them. The app hides any section the record does not have: digits, forecast or advice.

## What the validator rejects

- **The file:** a wrong `format`, unknown fields (typos), or a missing `dreams` array.
- **Ids:** non-slug ids, and **duplicate ids (every copy is rejected)**. Duplicate source ids.
- **Numbers:**
  - empty numbers without `"noLuckyNumbers": true`, or any number with it
  - a JSON number such as `8` instead of `"08"`
  - the wrong width, empty lists, Thai digits, or duplicate numbers
- **Text:**
  - empty or untrimmed text, zero-width characters, or non-NFC text
  - `ํา` typed instead of `ำ`, which looks the same but breaks search
- **Categories:** unknown category ids. Validate-only mode checks the seeded list; plan/write mode checks the
  database.
- **Status and sources:**
  - `VERIFIED` is never imported
  - citing an unknown source (a missing source is only a warning)
- **Images:**
  - non-https URLs, localhost or IP hosts, or credentials in the URL
  - an image without `credit` or `license`
- **Placeholders:** `<<…>>`, `TODO` and `PLACEHOLDER` are allowed only in `SAMPLE` records.
- **Warning only:** the same `name` used twice.

## Commands (from `backend/`)

```bash
# 1. Validate only: no database is touched
npm run content:import -- --file content/my-batch.json

# 2. Dry run against a LOCAL database: read-only comparison
npm run db:local                                  # in another terminal
DATABASE_URL='postgresql://dreamapp:dreamapp@localhost:5433/dreamapp_dev?schema=public' \
  npm run content:import -- --file content/my-batch.json --plan

# 3. Write to the local database (one transaction; all or nothing)
DATABASE_URL='…localhost…' npm run content:import -- --file content/my-batch.json --write

# 4. Publish (DRAFT → VERIFIED) — dry run first
DATABASE_URL='…localhost…' npm run content:publish -- --category letter-k
DATABASE_URL='…localhost…' npm run content:publish -- --category letter-k --write

# One-off: delete the old SAMPLE design dreams (never DRAFT/VERIFIED) — dry run first
DATABASE_URL='…localhost…' npm run content:remove-sample [-- --write]
```

`npm run db:seed` now creates the content categories only (หมวด ก); it no longer adds sample dreams.

**Guards:**
- The importer never reads `backend/.env`. `DATABASE_URL` must be set in the shell for that one command.
- A non-local host needs `--allow-remote-host=<exact host>`.
- Remote writes accept only `DRAFT` records without placeholders.
- Exit codes: `0` ok, `1` invalid file, `2` refused (conflicts or guards), `3` usage or target error.

**Plan rules (no deletes, ever):**

| Database has | File has | Action |
|---|---|---|
| no row | a record | `create`, appended after the highest `sortOrder` |
| an identical row | the same record | `unchanged`, so a re-run is a no-op |
| a `DRAFT` row that differs | a record | `conflict`; with `--update` it becomes `update` |
| a `SAMPLE` (seed) or `VERIFIED` row | a record | `protected`; never changed |
| a row | no record | left alone; the importer never deletes |

A write is refused when the file has any error or the plan has any conflict. The seed (`npm run db:seed`) likewise
only updates rows that are still `SAMPLE`.

## Adding one dream, step by step

1. **Collect the source.** Take the printed or online source you are allowed to use. Record its title, author,
   publisher, edition, year (B.E. or C.E. in `note`) and, for online sources, the https URL. Do not make up
   bibliographic details. If something is unknown, leave the field out.
2. **Transcribe.** Copy `name`, `meaning` and the lucky numbers exactly as written. Keep numbers as strings
   (`"08"`). Write `short` as a faithful one-line summary. Put the page or section in `source.locator`. Add
   `advice`, `digits` or `isGoodOmen` only if the source gives them.
3. **Image (optional).**
   - Use only an image you have the right to use: your own, a licence that allows it, or written permission.
   - Fill in `credit`, `license` and `sourceUrl`, and add `alt` text.
   - The app does not verify the URL. Open it yourself, and prefer a stable https host you control.
   - Leave `image` out if there is none: the app shows its striped placeholder, which is clearly not a photo.
4. **Choose a stable id.** Use a short English slug, e.g. `snake-coiling`. It must never change after
   publication, because saved dreams refer to it.
5. **Validate.** Run `npm run content:import -- --file batch.json` and fix every `ERROR`. Read the warnings.
6. **Dry run.** Run `--plan` against a local database and check `create`/`conflict`/`protected`.
7. **Write locally.** Use `--write` on the local database, then check the app in API mode, sorted with
   `sort=name`.
8. **Review.** A second person compares the record with the source. Only then, in a separate step, can it become
   `VERIFIED`.
9. **Production.** Not yet allowed. Writing to Neon needs explicit approval, a backup or Neon branch first, the
   migration `0002_content_metadata` applied, and `--allow-remote-host`.

## Thai ordering (ก–ฮ)

- `GET /dreams?sort=name` returns Thai dictionary order, using ICU collation in Node (`Intl.Collator('th')`):
  - leading vowels (เ แ โ ใ ไ) are skipped, so `เสือ` sorts under ส
  - a following consonant sorts before a following vowel (`ก้อน` before `กา`)
  - tone marks are a secondary difference
- PostgreSQL ordering is not used:
  - the default collation sorts by code point, which puts `เสือ` after `ฮ`
  - ICU collations depend on how the database was created (unavailable for the local WIN874 database)
- The API reads all matching ids and names, sorts them, then loads one page. That is fine for thousands of
  rows. Revisit (e.g. a stored sort key) far beyond that.
- The default `sort=catalogue` (curated order) is unchanged, and the app's screens still use it.
- The bundled sample repository refuses `sort=name` rather than approximate it.
