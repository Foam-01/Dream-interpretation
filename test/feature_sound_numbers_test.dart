// Feature 9 (สูตรเลขเสียงโชค): the book's กลุ่มเลขตัวเด่น / ตัวกัน per draw weekday (pp. 258–264), opened on the next
// draw.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/data/design_data.dart';
import 'package:maha_dream/data/sound_numbers.dart';
import 'package:maha_dream/main.dart';
import 'package:maha_dream/widgets/ui.dart';

void main() {
  test('the groups are the transcription in source.md, in the book\'s order', () {
    final src = File('backend/content/incoming/feature-09-sound-numbers/source.md')
        .readAsStringSync()
        .replaceAll('\r\n', '\n');
    for (var i = 0; i < 7; i++) {
      expect(src, contains('สลากออกวัน${dayFull[i]} '));
      expect(src, contains('กลุ่มเลขตัวเด่น: ${soundLead[i].join(' ')}\n'), reason: dayFull[i]);
      expect(src, contains('กลุ่มเลขตัวกัน: ${soundBlock[i].join(' ')}\n'), reason: dayFull[i]);
      expect(soundBlock[i], hasLength(10));
    }
    expect([for (final l in soundLead) l.length], [20, 20, 19, 20, 15, 20, 15]);
  });

  test('every weekday has its bundled deity picture', () {
    for (final img in soundImages) {
      expect(File(img!).existsSync(), isTrue, reason: img);
    }
    expect(Directory('assets/days').listSync().whereType<File>(), hasLength(7));
  });

  Future<void> openAt(WidgetTester tester, DateTime now) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MahaDreamApp(clock: () => now));
    await tester.pumpAndSettle();
    await tester.tap(find.text('เลขเด็ด').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('สูตรเลขเสียงโชค'));
    await tester.pumpAndSettle();
  }

  bool pillSelected(WidgetTester tester, String label) =>
      tester.widget<SelectPill>(find.widgetWithText(SelectPill, label)).selected;

  testWidgets('opens on the next draw (Mon 5 Oct 2026 → Fri 16 Oct) with that day\'s groups', (tester) async {
    await openAt(tester, DateTime(2026, 10, 5));
    expect(pillSelected(tester, 'ศ'), isTrue);
    expect(find.text('งวด 16 ต.ค. 2569 สลากออกวันศุกร์'), findsOneWidget);
    expect(find.text('กลุ่มเลขตัวเด่น'), findsOneWidget);
    expect(find.text('98', skipOffstage: false), findsOneWidget); // Friday lead
    await tester.tap(find.widgetWithText(SelectPill, 'ส'));
    await tester.pumpAndSettle();
    expect(find.text('สลากออกวันเสาร์'), findsOneWidget);
    expect(find.text('07', skipOffstage: false), findsOneWidget); // Saturday lead
  });

  testWidgets('no sample formula is left on the page', (tester) async {
    await openAt(tester, DateTime(2026, 10, 5));
    for (final old in ['ดาวประจำวัน', 'เลขคู่เด่น', 'ธาตุ']) {
      expect(find.text(old, skipOffstage: false), findsNothing);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('Home links to this page instead of showing sample digits', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MahaDreamApp(clock: () => DateTime(2026, 10, 5)));
    await tester.pumpAndSettle();
    final link = find.text('ตัวเด่น · ตัวกัน ›');
    await tester.scrollUntilVisible(link.hitTestable(), 200, scrollable: find.byType(Scrollable).first);
    await tester.tap(link);
    await tester.pumpAndSettle();
    expect(find.text('งวด 16 ต.ค. 2569 สลากออกวันศุกร์'), findsOneWidget);
  });
}
