// F12: errors are kept in memory (readable on release builds), repository failures included,
// and testers can read them from a hidden sheet on Home.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/data/dream_repository.dart';
import 'package:maha_dream/main.dart';
import 'package:maha_dream/state/error_log.dart';
import 'package:maha_dream/state/load_request.dart';

void main() {
  setUp(ErrorLog.clear);

  test('keeps the newest ${ErrorLog.capacity} errors, oldest dropped first', () {
    for (var i = 0; i < ErrorLog.capacity + 5; i++) {
      logError('e$i', null, context: 'test', now: () => DateTime(2026, 11, 8));
    }
    final r = ErrorLog.records;
    expect(r, hasLength(ErrorLog.capacity));
    expect(r.first.error, 'e5');
    expect(r.last.error, 'e${ErrorLog.capacity + 4}');
    expect(ErrorLog.report(), contains('[test] e5'));
  });

  test('a repository failure is recorded with kind and status, not the search words', () async {
    final req = LoadRequest<int>();
    req.run(
      () => Future.error(const DreamRepositoryException(DreamRepositoryErrorKind.server, 'HTTP 503', statusCode: 503)),
    );
    await Future<void>.delayed(Duration.zero);
    expect(req.status, LoadStatus.failure);
    final r = ErrorLog.records.single;
    expect(r.context, 'repository');
    expect(r.error, contains('server 503'));
    req.dispose();
  });

  test('any other failure keeps its stack', () async {
    final req = LoadRequest<int>();
    req.run(() => Future.error(StateError('boom'), StackTrace.current));
    await Future<void>.delayed(Duration.zero);
    final r = ErrorLog.records.single;
    expect(r.context, 'load_request');
    expect(r.stack, isNotNull);
    req.dispose();
  });

  testWidgets('long-pressing the Home title opens the error log', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MahaDreamApp());
    await tester.pumpAndSettle();
    logError('sample failure', null, context: 'test');
    await tester.longPress(find.text('ทำนายฝัน').first);
    await tester.pumpAndSettle();
    expect(find.text('บันทึกข้อผิดพลาด (1)'), findsOneWidget);
    expect(find.text('sample failure'), findsOneWidget);
    await tester.tap(find.text('ล้าง'));
    await tester.pumpAndSettle();
    expect(find.text('ยังไม่มีข้อผิดพลาด'), findsOneWidget);
  });
}
