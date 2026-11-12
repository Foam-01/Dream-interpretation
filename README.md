# Dream Interpretation App 🌙

A Flutter application for dream interpretation.

## Contributors

| Avatar | Username |
|--------|----------|
| [![Foam-01](https://avatars.githubusercontent.com/Foam-01?s=64)](https://github.com/Foam-01) | [@Foam-01](https://github.com/Foam-01) |

## Data source

By default the app uses its bundled content (the owner's book), so it works offline. Build with
`--dart-define=API_BASE_URL=http://10.0.2.2:3000/api/v1` to read dreams from the backend in `backend/`.
See [docs/api-mode.md](docs/api-mode.md).

## Release build (Google Play)

Release builds are signed with your own upload key, never the debug key. A release build stops with an
error when the key is missing.

1. Create the upload key once, outside the repo, and keep a backup of the file and its passwords:

   ```bash
   keytool -genkeypair -v -keystore ../keys/upload-keystore.jks -alias upload -keyalg RSA -keysize 2048 -validity 10000
   ```

   (`keytool` is in Android Studio's JDK, e.g. `C:\Program Files\Android\openjdk\jdk-21.0.8\bin`.)
2. Copy `android/key.properties.example` to `android/key.properties` and fill in the path and passwords.
   Git ignores `key.properties`, `*.jks` and `*.keystore`.
3. Bump `version:` in `pubspec.yaml` (the number after `+` must be higher than the last upload).
4. Build the bundle for Play, with Dart code obfuscated; keep `build/symbols` to read crash reports:

   ```powershell
   .\scripts\build_release.ps1 appbundle --obfuscate --split-debug-info=build/symbols
   ```

   The script deletes the generated plugin registrant first: after a debug build or test run it lists the
   dev-only `integration_test` plugin, and a plain `flutter build … --release` reuses it and fails with
   `package dev.flutter.plugins.integration_test does not exist`. (Without the script: delete
   `android/app/src/main/java/io/flutter/plugins/GeneratedPluginRegistrant.java`, then build.)

5. In Play Console, turn on **Play App Signing** on the first upload, so Google keeps the app signing key
   and a lost upload key can be replaced.

For a local test build without the key (never for upload), set `ALLOW_DEBUG_SIGNING=true` first
(`$env:ALLOW_DEBUG_SIGNING = 'true'; .\scripts\build_release.ps1 apk`).

## Branches

`serve_dev` (development) → merge into `uat` (tests pass) → merge into `prod` (released), then tag the
version on `prod` (e.g. `v1.0.0`).

## Running tests

CI (`.github/workflows/ci.yml`) runs on pull requests and on pushes to `main`, `serve_dev`, `uat` and `prod`:
`dart format` check, `flutter analyze`, `flutter test`, and the backend steps below.

App (from the repository root):

```bash
dart format --output=none --set-exit-if-changed lib test   # same check as CI
flutter analyze
flutter test                                               # unit, widget and golden tests
```

- Golden images live in `test/golden/goldens/`. After an intended visual change, update only the goldens of the
  screens you changed (`flutter test <file> --update-goldens --plain-name "<test>"`) and review them before
  committing. Failed comparisons are written to `test/golden/failures/` (git-ignored).
- The full layout check (10 screen sizes × 5 text sizes) is not part of CI; run it before a release:
  `flutter test test/golden/release_layout_test.dart --dart-define=FULL_LAYOUT=true`
- `test/live_api_contract_test.dart` is skipped unless `LIVE_API_BASE_URL` points at a running backend.
- On-device smoke test (needs a running emulator or phone; not run in CI):
  `flutter test integration_test -d <device id>` (`flutter devices` lists the ids).

Backend (from `backend/`; the e2e tests start their own throwaway PostgreSQL):

```bash
npm ci
npm run format:check
npm run lint
npm test
npm run test:e2e
```

## Moved lottery draws (check before each period runs out)

Draws are on the 1st and 16th, except the ones the Government Lottery Office (สำนักงานสลากกินแบ่งรัฐบาล) moves,
for example for New Year, Teachers' Day (16 Jan) or Labour Day (1 May). The app only knows the moves listed in
`lib/data/draw_schedule.dart`, and only announced dates belong there, never guessed ones.

`drawShiftsCheckedUntil` in that file is the last draw date that has been checked. 14 days before it,
`test/draw_schedule_reminder_test.dart` starts failing (also in CI) as a reminder. Then:

1. Look up the GLO's announcements for the coming draws (www.glo.or.th or news of its notice).
2. Add every moved draw to `drawShifts` (usual date → real date) with its reason and source.
3. Raise `drawShiftsCheckedUntil` to the last draw the announcements cover, then run `flutter test`.

## Getting started

1. Install **Flutter 3.47.5** (stable), the version CI uses (`.github/workflows/ci.yml`), with the Android SDK.
2. From this folder:

   ```bash
   flutter pub get
   ```

   ```bash
   flutter run
   ```

   The app runs on its bundled content; no backend, account or network is needed.

Two files are not in git. The app builds and runs without them; you only need them for a release:

- `android/app/google-services.json`: Firebase Crashlytics config. Without it crash reporting is off
  ([docs/crash-reporting.md](docs/crash-reporting.md)).
- `android/key.properties` and the upload keystore: release signing (see "Release build" above).

The backend in `backend/` is optional (API mode only); its setup is in [backend/README.md](backend/README.md).

## Project structure

```
lib/
  main.dart            start-up: crash reporting, error handlers, data source (bundled or API)
  app_shell.dart       the frame: bottom tabs, Back handling, which screen is shown
  theme.dart           colours and text styles (blue-gold theme)
  data/                the book's content and the rules that read it
    dreams_*.dart        GENERATED dream text per letter (see "Updating the book content")
    dream_images_*.dart  picture of each dream; category_*.dart: category ids
    design_data.dart     models (Dream, LuckyNumbers) and the menu list (menus, feats)
    formulas.dart        draw dates, Thai dates; draw_schedule.dart: draws the lottery office moved
    *_numbers.dart, digit_*.dart, ...   content of menus 2-12
    dream_repository.dart               the data interface; sample_ = bundled, api_ = backend
  state/               app_controller.dart (tabs, page stacks, search words), load_request.dart,
                       daily_pick.dart, error_log.dart, crash_reporter.dart
  screens/             home, search, result (one dream), menu (a tab's menu list)
    feature_screen.dart  picks the screen of a menu
    features/            one file per menu (menus 2-12 and the letter pages)
  widgets/ui.dart      shared widgets (cards, pills, pager, search field, pictures)
test/                  unit, widget and golden tests (test/golden/); integration_test/ runs on a device
backend/               optional NestJS API + the content sources (backend/content/incoming/)
```

To add a menu: add it to `feats` and `menus` in `lib/data/design_data.dart`, write its screen in
`lib/screens/features/`, and add its case to the `switch` in `lib/screens/feature_screen.dart` (the compiler
points at the missing case).

## Updating the book content

The sources live in `backend/content/incoming/`, one folder per letter category or menu, each with the text
as received and a `REVIEW.md` listing every correction. Text is kept as in the book; nothing is invented.

- **Dream text (letter categories)**: edit `dreams.json` in the category's folder, then regenerate the Dart
  files. Never edit `lib/data/dreams_*.dart` by hand.

  ```bash
  cd backend && node scripts/generate-flutter-content.mjs
  ```

- **Menus 2-12** (animals, pae kong, lock numbers, ...): edit the matching `lib/data/*.dart` file to follow
  the menu's `source.md` / `source.txt`; most of these files have a test that compares them with the source.
- **Pictures**: `assets/dreams/`, `assets/pae/`, `assets/animals/`; no words or extra numbers in a picture.

Then run `flutter test`: the category and feature tests fail when the app and the sources disagree.
