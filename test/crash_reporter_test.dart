// F12 Crashlytics wiring: what is sent, what stays on the device, and that tests/debug send nothing.
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/data/dream_repository.dart';
import 'package:maha_dream/state/crash_reporter.dart';
import 'package:maha_dream/state/error_log.dart';

class _FakeReporter implements CrashReporter {
  final sent = <(Object, bool, String)>[];
  @override
  Future<void> recordError(Object error, StackTrace? stack, {required bool fatal, required String reason}) async =>
      sent.add((error, fatal, reason));
  @override
  Future<void> setKey(String key, String value) async {}
}

void main() {
  late _FakeReporter fake;
  setUp(() {
    ErrorLog.clear();
    fake = _FakeReporter();
    crashReporter = fake;
  });
  tearDown(() => crashReporter = const NoCrashReporter());

  test('a bug is sent as non-fatal with its context', () {
    logError(StateError('boom'), StackTrace.current, context: 'load_request');
    expect(fake.sent.single.$2, isFalse);
    expect(fake.sent.single.$3, 'load_request');
  });

  test('an uncaught error is sent as fatal', () {
    logError(StateError('boom'), null, context: 'uncaught', fatal: true);
    expect(fake.sent.single.$2, isTrue);
  });

  test('network and timeout failures stay on the device only', () {
    for (final kind in [DreamRepositoryErrorKind.network, DreamRepositoryErrorKind.timeout]) {
      logError(DreamRepositoryException(kind, 'SocketException'), null, context: 'repository');
    }
    expect(fake.sent, isEmpty);
    expect(ErrorLog.records, hasLength(2));
  });

  test('server and bad-response failures are sent', () {
    logError(
      const DreamRepositoryException(DreamRepositoryErrorKind.server, 'HTTP 503', statusCode: 503),
      null,
      context: 'repository',
    );
    logError(
      const DreamRepositoryException(DreamRepositoryErrorKind.badResponse, 'missing field'),
      null,
      context: 'repository',
    );
    expect(fake.sent, hasLength(2));
  });

  test('debug builds (and tests) never start Crashlytics', () async {
    expect(await initCrashReporting(release: false), isA<NoCrashReporter>());
  });
}
