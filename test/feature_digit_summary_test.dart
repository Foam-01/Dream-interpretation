// Feature 2 (สรุปเลขนำโชค 0–9) shows the owner's book pages "สรุปตัวเลขนำโชคความฝัน": the intro, then one card
// per digit (1–9, then 0) with its picture and the "ได้แก่ ฝันเห็น …" list.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/data/digit_summary.dart';
import 'package:maha_dream/main.dart';

void main() {
  test('the data matches the transcription in source.md', () {
    final src = File('backend/content/incoming/feature-02-digit-summary/source.md')
        .readAsStringSync()
        .replaceAll('\r\n', '\n'); // git may check it out with CRLF
    expect(src, contains(digitSummaryIntro));
    expect(digitSymbols.map((s) => s.digit), [1, 2, 3, 4, 5, 6, 7, 8, 9, 0]);
    for (final s in digitSymbols) {
      expect(src, contains('เลข ${s.digit}\nได้แก่ ฝันเห็น ${s.items.join(', ')} ฯลฯ\n'), reason: 'เลข ${s.digit}');
    }
    expect([for (final s in digitSymbols) s.items.length], [19, 18, 19, 26, 14, 17, 13, 20, 17, 18]);
  });

  test('every digit has its bundled picture', () {
    for (final s in digitSymbols) {
      expect(s.image, 'assets/digits/digit-${s.digit}.jpg');
      expect(File(s.image!).existsSync(), isTrue, reason: s.image);
    }
    expect(Directory('assets/digits').listSync().whereType<File>(), hasLength(10));
  });

  testWidgets('the page shows the intro and every digit card in book order', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MahaDreamApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('เลขเด็ด').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('สรุปเลขนำโชค 0–9'));
    await tester.pumpAndSettle();

    final list = find.byType(Scrollable).first;
    expect(find.text(digitSummaryIntro), findsOneWidget);
    double? lastY;
    for (final s in digitSymbols) {
      final items = find.text('ได้แก่ ฝันเห็น ${s.items.join(', ')} ฯลฯ', findRichText: true);
      await tester.scrollUntilVisible(items, 300, scrollable: list);
      expect(find.text('เลข ${s.digit}'), findsOneWidget);
      expect(find.bySemanticsLabel('ภาพประกอบเลข ${s.digit}'), findsOneWidget);
      final y = tester.getTopLeft(find.text('เลข ${s.digit}')).dy;
      if (lastY != null) expect(y, isNot(lastY));
      lastY = y;
    }
    expect(find.text('ยังไม่มีความฝันที่ให้เลขนี้', skipOffstage: false), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
