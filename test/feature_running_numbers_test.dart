// Feature 10 (สูตรเลขวิ่งประจำวัน): the book's table "ถ้าสลากออกวัน … งวดนั้นจะมีเลขวิ่ง", opened on the weekday
// of the next draw; Home shows the same numbers.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/data/design_data.dart';
import 'package:maha_dream/data/running_numbers.dart';
import 'package:maha_dream/main.dart';
import 'package:maha_dream/widgets/ui.dart';

void main() {
  test('the table and intro are the transcription in source.md', () {
    final src = File('backend/content/incoming/feature-10-running-numbers/source.md')
        .readAsStringSync()
        .replaceAll('\r\n', '\n');
    expect(src, contains(runningIntro));
    expect(src, contains(runningTableTitle));
    for (var i = 0; i < 7; i++) {
      expect(src, contains('| วัน${dayFull[i]} | ${runningByDrawDay[i].join(' ')} |'), reason: dayFull[i]);
    }
  });

  Future<void> openAt(WidgetTester tester, DateTime now) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MahaDreamApp(clock: () => now));
    await tester.pumpAndSettle();
    await tester.tap(find.text('เลขเด็ด').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('สูตรเลขวิ่งประจำวัน'));
    await tester.pumpAndSettle();
  }

  bool pillSelected(WidgetTester tester, String label) =>
      tester.widget<SelectPill>(find.widgetWithText(SelectPill, label)).selected;

  testWidgets('opens on the next draw\'s weekday (Mon 5 Oct 2026 → draw Fri 16 Oct)', (tester) async {
    await openAt(tester, DateTime(2026, 10, 5));
    expect(pillSelected(tester, 'ศ'), isTrue);
    expect(find.text('งวด 16 ต.ค. 2569 ออกวันศุกร์'), findsOneWidget);
    for (final n in ['6', '3', '5']) {
      expect(find.descendant(of: find.byType(DigitBox), matching: find.text(n)), findsOneWidget);
    }
  });

  testWidgets('another weekday shows "ถ้าสลากออกวัน…" with its numbers; no sample formula', (tester) async {
    await openAt(tester, DateTime(2026, 10, 5));
    await tester.tap(find.widgetWithText(SelectPill, 'อ'));
    await tester.pumpAndSettle();
    expect(find.text('ถ้าสลากออกวันอังคาร'), findsOneWidget);
    for (final n in ['3', '0', '5']) {
      expect(find.descendant(of: find.byType(DigitBox), matching: find.text(n)), findsOneWidget);
    }
    for (final old in ['เลขเจาะ 2 ตัว', 'รูด 19 ประตู', '3 ตัวโต๊ด']) {
      expect(find.text(old, skipOffstage: false), findsNothing);
    }
    expect(tester.takeException(), isNull);
  });
}
