// M1.4.2: date-dependent screens use the injected clock. Expected values were
// computed from the unchanged source (formulas.dart / design_data.dart) for
// each fixed date; they lock current behaviour, including draw-card order.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/main.dart';
import 'package:maha_dream/widgets/ui.dart';

Future<void> pumpAt(WidgetTester tester, DateTime now) async {
  tester.view.physicalSize = const Size(390, 1400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(MahaDreamApp(clock: () => now));
}

Future<void> openFeature(WidgetTester tester, String tab, String menuTitle) async {
  await tester.tap(find.text(tab).last); // bottom tab is built after the page body
  await tester.pump();
  await tester.tap(find.text(menuTitle));
  await tester.pump();
}

/// Text inside the home lock card's badge row (link to ตัวเด่น · ตัวกัน, then เลขวิ่ง).
Finder inBadgeRow(String text) => find.descendant(
    of: find.ancestor(of: find.text('ตัวเด่น · ตัวกัน ›'), matching: find.byType(Wrap)).first,
    matching: find.text(text));

void expectHome(
  WidgetTester tester, {
  required String header,
  required String cardTitle,
  required String draw,
  required String top,
  required String bottom,
  required String running,
}) {
  expect(find.text(header), findsOneWidget);
  expect(find.text(cardTitle), findsOneWidget);
  expect(find.text(draw), findsOneWidget);
  expect(find.text(top), findsOneWidget);
  expect(find.text(bottom), findsOneWidget);
  expect(inBadgeRow(running), findsOneWidget, reason: 'เลขวิ่ง');
}

void main() {
  test('default clock is the real clock', () {
    expect(identical(const MahaDreamApp().clock, DateTime.now), isTrue);
  });

  group('HomeScreen', () {
    testWidgets('H1 Friday 2026-10-23', (tester) async {
      await pumpAt(tester, DateTime(2026, 10, 23));
      expectHome(tester,
          header: 'วันศุกร์ที่ 23 ต.ค. 2569',
          cardTitle: 'เลขล็อคประจำวันศุกร์',
          draw: 'งวด 1 พ.ย. 69',
          top: '6 5',
          bottom: '6 4',
          running: '1 · 8 · 4'); // draw 1 Nov 2026 is a Sunday
    });

    testWidgets('H2 Monday 2026-10-05 (different values, next draw on the 16th)', (tester) async {
      await pumpAt(tester, DateTime(2026, 10, 5));
      expectHome(tester,
          header: 'วันจันทร์ที่ 5 ต.ค. 2569',
          cardTitle: 'เลขล็อคประจำวันจันทร์',
          draw: 'งวด 16 ต.ค. 69',
          top: '2 7',
          bottom: '8 8',
          running: '6 · 3 · 5'); // draw 16 Oct 2026 is a Friday
    });

    testWidgets('H3 time of day does not change the date (Sunday 23:59)', (tester) async {
      await pumpAt(tester, DateTime(2026, 10, 25, 23, 59));
      expectHome(tester,
          header: 'วันอาทิตย์ที่ 25 ต.ค. 2569',
          cardTitle: 'เลขล็อคประจำวันอาทิตย์',
          draw: 'งวด 1 พ.ย. 69',
          top: '1 5',
          bottom: '6 4',
          running: '1 · 8 · 4'); // draw 1 Nov 2026 is a Sunday
    });
  });

  group('FeatureScreen initial day', () {
    bool pillSelected(WidgetTester tester, String label) =>
        tester.widget<SelectPill>(find.widgetWithText(SelectPill, label)).selected;

    testWidgets('F1 feature 7 on Sunday 2026-10-25 starts on Sunday', (tester) async {
      await pumpAt(tester, DateTime(2026, 10, 25));
      await openFeature(tester, 'เลขเด็ด', 'เลขล็อคตามวัน');
      expect(pillSelected(tester, 'อา'), isTrue);
      expect(pillSelected(tester, 'จ'), isFalse);
      expect(find.text('วันอาทิตย์'), findsOneWidget);
      expect(find.text('1 5'), findsOneWidget);
      expect(find.text('เลขล็อควันอาทิตย์ คำนวณจากดาวประจำวัน (1) และฤกษ์ยามงวดนี้'), findsOneWidget);
    });

    testWidgets('F2 feature 7 on Saturday 2026-10-24 starts on Saturday', (tester) async {
      await pumpAt(tester, DateTime(2026, 10, 24));
      await openFeature(tester, 'เลขเด็ด', 'เลขล็อคตามวัน');
      expect(pillSelected(tester, 'ส'), isTrue);
      expect(find.text('วันเสาร์'), findsOneWidget);
      expect(find.text('7 7'), findsOneWidget);
    });

    testWidgets('F3 feature 9 on Monday 2026-10-26 starts on the day of the next draw (Sunday 1 Nov)', (tester) async {
      await pumpAt(tester, DateTime(2026, 10, 26));
      await openFeature(tester, 'เลขเด็ด', 'สูตรเลขเสียงโชค');
      expect(pillSelected(tester, 'อา'), isTrue);
      expect(find.text('งวด 1 พ.ย. 2569 สลากออกวันอาทิตย์'), findsOneWidget);
    });
  });

  group('Feature 8: the next two draws, in date order, with the lead numbers from the book', () {
    Future<void> openDraws(WidgetTester tester, DateTime now) async {
      await pumpAt(tester, now);
      await openFeature(tester, 'เลขเด็ด', 'สูตรเลขเด่น');
    }

    void expectDraws(WidgetTester tester, List<(String, String)> draws) {
      double? lastY;
      for (final (title, digits) in draws) {
        final t = find.text(title);
        expect(t, findsOneWidget, reason: title);
        final y = tester.getCenter(t).dy;
        if (lastY != null) expect(y, greaterThan(lastY), reason: 'date order');
        lastY = y;
        final card = find.ancestor(of: t, matching: find.byType(Column)).first;
        expect(
          find.descendant(of: card, matching: find.byType(DigitBox)).evaluate().map((e) => (e.widget as DigitBox).digit).join(),
          digits,
          reason: title,
        );
      }
    }

    testWidgets('D1 2026-10-05: 16 Oct (Friday) then 1 Nov (Sunday)', (tester) async {
      await openDraws(tester, DateTime(2026, 10, 5));
      expectDraws(tester, [('งวด 16 ต.ค. 2569 ออกวันศุกร์', '634'), ('งวด 1 พ.ย. 2569 ออกวันอาทิตย์', '574')]);
      expect(find.textContaining('สูตร: ', skipOffstage: false), findsNothing, reason: 'sample formulas removed');
    });

    testWidgets('D2 2026-10-23: 1 Nov (Sunday) then 16 Nov (Monday)', (tester) async {
      await openDraws(tester, DateTime(2026, 10, 23));
      expectDraws(tester, [('งวด 1 พ.ย. 2569 ออกวันอาทิตย์', '574'), ('งวด 16 พ.ย. 2569 ออกวันจันทร์', '493')]);
    });

    testWidgets('D3 2026-12-10: moved draws, 17 Dec (Thursday) then 2 Jan (Saturday)', (tester) async {
      // 16 Dec 2569 → 17 Dec and 1 Jan 2570 → 2 Jan (drawShifts): real weekday, original round's column.
      await openDraws(tester, DateTime(2026, 12, 10));
      expectDraws(tester, [('งวด 17 ธ.ค. 2569 ออกวันพฤหัสบดี', '823'), ('งวด 2 ม.ค. 2570 ออกวันเสาร์', '478')]);
    });
  });
}
