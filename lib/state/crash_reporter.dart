import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import '../data/dream_repository.dart';

/// Where errors go off the device. [logError] calls the current [crashReporter]; tests swap in a fake.
abstract interface class CrashReporter {
  Future<void> recordError(Object error, StackTrace? stack, {required bool fatal, required String reason});
  Future<void> setKey(String key, String value);
}

/// Sends nothing: debug builds, web, tests, and builds without android/app/google-services.json.
class NoCrashReporter implements CrashReporter {
  const NoCrashReporter();
  @override
  Future<void> recordError(Object error, StackTrace? stack, {required bool fatal, required String reason}) async {}
  @override
  Future<void> setKey(String key, String value) async {}
}

/// Firebase Crashlytics (project maha-dream). No user id is set: the app has no accounts.
class FirebaseCrashReporter implements CrashReporter {
  final FirebaseCrashlytics _c;
  const FirebaseCrashReporter(this._c);
  @override
  Future<void> recordError(Object error, StackTrace? stack, {required bool fatal, required String reason}) =>
      _c.recordError(error, stack, fatal: fatal, reason: reason);
  @override
  Future<void> setKey(String key, String value) => _c.setCustomKey(key, value);
}

/// The reporter in use; [NoCrashReporter] until [initCrashReporting] says otherwise.
CrashReporter crashReporter = const NoCrashReporter();

/// Lost connections and timeouts are expected on phones and say nothing about a bug: kept on the device
/// (ErrorLog) but not sent.
bool worthReporting(Object error) =>
    !(error is DreamRepositoryException &&
        (error.kind == DreamRepositoryErrorKind.network || error.kind == DreamRepositoryErrorKind.timeout));

/// Starts Crashlytics on Android release builds. Anything else — debug, web, no Firebase config, or
/// Firebase failing to start — keeps [NoCrashReporter], and the app runs as before.
Future<CrashReporter> initCrashReporting({bool release = kReleaseMode}) async {
  if (!release || kIsWeb || defaultTargetPlatform != TargetPlatform.android) return const NoCrashReporter();
  try {
    await Firebase.initializeApp();
    final c = FirebaseCrashlytics.instance;
    await c.setCrashlyticsCollectionEnabled(true);
    return FirebaseCrashReporter(c);
  } catch (e) {
    // No google-services.json in this build (the Gradle plugins were skipped): report nothing.
    if (kDebugMode) debugPrint('[crash] Crashlytics off: $e');
    return const NoCrashReporter();
  }
}
