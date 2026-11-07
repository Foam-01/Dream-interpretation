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

   ```bash
   flutter build appbundle --release --obfuscate --split-debug-info=build/symbols
   ```

5. In Play Console, turn on **Play App Signing** on the first upload, so Google keeps the app signing key
   and a lost upload key can be replaced.

For a local test build without the key (never for upload), set `ALLOW_DEBUG_SIGNING=true` first.

## Branches

`serve_dev` (development) → merge into `uat` (tests pass) → merge into `prod` (released), then tag the
version on `prod` (e.g. `v1.0.0`).

## Getting Started

This project is built with Flutter.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
