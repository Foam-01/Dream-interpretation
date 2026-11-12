// F11 error handling: app-wide handlers, the release fallback widget, and logging of unexpected errors.
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/data/dream_repository.dart';
import 'package:maha_dream/main.dart';
import 'package:maha_dream/state/load_request.dart';
import 'package:maha_dream/widgets/ui.dart';

void main() {
  group('installErrorHandlers', () {
    late FlutterExceptionHandler? savedOnError;
    late bool Function(Object, StackTrace)? savedPlatformOnError;
    late ErrorWidgetBuilder savedBuilder;

    setUp(() {
      savedOnError = FlutterError.onError;
      savedPlatformOnError = PlatformDispatcher.instance.onError;
      savedBuilder = ErrorWidget.builder;
    });
    tearDown(() {
      FlutterError.onError = savedOnError;
      PlatformDispatcher.instance.onError = savedPlatformOnError;
      ErrorWidget.builder = savedBuilder;
    });

    test('release: a widget that fails to build shows the Thai notice, not a grey box', () {
      installErrorHandlers(release: true);
      final w = ErrorWidget.builder(FlutterErrorDetails(exception: StateError('boom')));
      expect(w, isA<BrokenSectionNotice>());
    });

    test('debug keeps Flutter\'s own error widget', () {
      installErrorHandlers(release: false);
      expect(ErrorWidget.builder, same(savedBuilder));
    });

    test('uncaught errors are handled (logged), not left to crash the isolate', () {
      installErrorHandlers(release: false);
      expect(PlatformDispatcher.instance.onError!(StateError('late'), StackTrace.current), isTrue);
    });
  });

  testWidgets('the release notice renders on its own, with no app around it', (tester) async {
    await tester.pumpWidget(const BrokenSectionNotice());
    expect(find.text('แสดงส่วนนี้ไม่ได้ ลองกลับไปแล้วเปิดใหม่อีกครั้ง'), findsOneWidget);
  });

  group('LoadRequest', () {
    test('an unexpected error still ends in failure with the generic kind', () async {
      final r = LoadRequest<int>();
      r.run(() => Future<int>.error(StateError('bug')));
      await Future<void>.delayed(Duration.zero);
      expect(r.status, LoadStatus.failure);
      expect(r.error!.kind, DreamRepositoryErrorKind.unexpected);
      r.dispose();
    });

    test('a synchronous throw from fetch also ends in failure, never stuck loading', () async {
      final r = LoadRequest<int>();
      r.run(() => throw StateError('sync bug'));
      await Future<void>.delayed(Duration.zero);
      expect(r.status, LoadStatus.failure);
      r.dispose();
    });
  });
}
