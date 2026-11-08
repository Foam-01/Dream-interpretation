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

## Getting Started

This project is built with Flutter.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
