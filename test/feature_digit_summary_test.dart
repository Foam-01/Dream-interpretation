// Feature 2 (สรุปเลขนำโชค 0–9) shows the owner's book pages "สรุปตัวเลขนำโชคความฝัน": the intro, then one card
// per digit (1–9, then 0) with its picture and the "ได้แก่ ฝันเห็น …" list.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/data/digit_summary.dart';
import 'package:maha_dream/main.dart';
import 'package:maha_dream/widgets/ui.dart';

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

  testWidgets('the page shows horizontal digit tabs 0-9 and all 10 digit cards in order', (tester) async {
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
    for (var d = 0; d <= 9; d++) {
      final items = find.byKey(ValueKey('digit-items-$d'));
      await tester.scrollUntilVisible(items, 300, scrollable: list);
      expect(find.text('ฝันแบบไหนเป็นเลข $d'), findsOneWidget);
    }
    expect(find.text('ยังไม่มีความฝันที่ให้เลขนี้', skipOffstage: false), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('two quick digit taps end on the last one tapped (F13 I1)', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MahaDreamApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('เลขเด็ด').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('สรุปเลขนำโชค 0–9'));
    await tester.pumpAndSettle();

    // 9 is far down the page; tap 2 before the jump to 9 has drawn a frame (the tab row scrolls
    // away with the page once the jump starts, so a later tap could not reach it).
    await tester.tap(find.widgetWithText(SelectPill, '9'));
    await tester.tap(find.widgetWithText(SelectPill, '2'));
    await tester.pumpAndSettle();

    final title = tester.getRect(find.text('ฝันแบบไหนเป็นเลข 2'));
    final view = tester.getRect(find.byType(Scrollable).first);
    expect(title.top, greaterThanOrEqualTo(view.top), reason: 'digit 2 is on screen');
    expect(title.bottom, lessThanOrEqualTo(view.bottom));
    expect(find.text('ฝันแบบไหนเป็นเลข 9'), findsNothing, reason: 'the page did not end on 9');
    expect(tester.takeException(), isNull);
  });
}
