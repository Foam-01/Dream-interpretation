// F24: lottery draws follow the date in Thailand (UTC+7), whatever the phone's time zone.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/data/formulas.dart';
import 'package:maha_dream/main.dart';

void main() {
  group('thaiToday', () {
    test('is the calendar date in Thailand', () {
      expect(thaiToday(DateTime.utc(2026, 11, 16, 16, 59)), DateTime(2026, 11, 16)); // 23:59 in Thailand
      expect(thaiToday(DateTime.utc(2026, 11, 16, 17)), DateTime(2026, 11, 17)); // midnight in Thailand
      expect(thaiToday(DateTime.utc(2026, 12, 31, 17)), DateTime(2027, 1, 1)); // new year in Thailand
    });

    test('a phone abroad gets the Thai draw: after the 16 Nov draw it is the 1 Dec draw', () {
      // 16 Nov 18:00 UTC = still 16 Nov in the Americas and Europe, already 17 Nov 01:00 in Thailand.
      final abroad = DateTime.utc(2026, 11, 16, 18);
      expect(nextDrawDate(thaiToday(abroad)), DateTime(2026, 12, 1));
      // Earlier that day it is 16 Nov in Thailand too: today's draw.
      expect(nextDrawDate(thaiToday(DateTime.utc(2026, 11, 16, 8))), DateTime(2026, 11, 16));
    });
  });

  Future<void> pumpAt(WidgetTester tester, DateTime now) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MahaDreamApp(clock: () => now));
    await tester.pumpAndSettle();
  }

  testWidgets('Home shows the draw of the Thai date', (tester) async {
    await pumpAt(tester, DateTime.utc(2026, 11, 16, 18)); // 17 Nov 01:00 in Thailand
    expect(find.text('งวด 1 ธ.ค. 69'), findsOneWidget);
    await pumpAt(tester, DateTime.utc(2026, 11, 16, 8)); // 16 Nov 15:00 in Thailand
    expect(find.text('งวด 16 พ.ย. 69'), findsOneWidget);
  });
}
