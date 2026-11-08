# Crash reporting (Firebase Crashlytics)

The app sends crashes and unexpected errors to Firebase Crashlytics, project **maha-dream**
(console: https://console.firebase.google.com/project/maha-dream/crashlytics).

## What is sent, and when

| Build | Sent? |
|---|---|
| Android **release** with `android/app/google-services.json` | yes |
| Android debug / profile | no (`initCrashReporting` returns `NoCrashReporter`) |
| Web, tests, CI, any build **without** `google-services.json` | no |

- **Fatal:** errors no one caught (`FlutterError.onError`, `PlatformDispatcher.onError` in `lib/main.dart`).
- **Non-fatal:** everything passed to `logError` (`lib/state/error_log.dart`), e.g. API errors (5xx,
  bad JSON) and unexpected failures in `LoadRequest`.
- **Not sent:** network and timeout failures (`worthReporting` in `lib/state/crash_reporter.dart`).
  They stay on the device in `ErrorLog`.
- **Attached:** app version and device model (Crashlytics), plus the custom key `data_source`
  (`sample` or `api`). No user id or search words: the app has no accounts, and error messages
  never contain what the user typed.

## Setting it up on a new machine

`google-services.json` is not in git (`.gitignore`). Without it the Firebase Gradle plugins are skipped
and the app builds and runs with crash reporting off.

1. Firebase console → project **maha-dream** → Project settings → Your apps → Android
   (`com.mahadream.maha_dream`) → download `google-services.json`.
2. Put it at `android/app/google-services.json`.

## Checking that it works

1. Build a release APK. Without the upload key, for a test build only:
   `$env:ALLOW_DEBUG_SIGNING = 'true'; .\scripts\build_release.ps1 apk` (see the README)
2. Install it, open the app, long-press the **ทำนายฝัน** title on Home: the error log sheet opens.
3. Tap **ทดสอบ**: one non-fatal report marked `manual test` is recorded.
4. Close and reopen the app (non-fatal reports are uploaded on the next launch). The report shows in the
   Crashlytics console within a few minutes.

## Before a Play release

- Declare "Crash logs" and "Diagnostics" in Play's Data safety form, and mention Crashlytics in the
  privacy policy (it uses an installation id, which counts as a device identifier).
- If the build is obfuscated (`--obfuscate --split-debug-info=…`), upload the symbol files to Crashlytics
  for every release, or stack traces will not be readable.
