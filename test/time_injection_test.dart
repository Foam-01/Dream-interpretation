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

/// Text inside the home lock card's badge row (ตัวเด่น / ตัวกัน / เลขวิ่ง).
Finder inBadgeRow(String text) => find.descendant(
    of: find.ancestor(of: find.text('ตัวเด่น'), matching: find.byType(Wrap)).first, matching: find.text(text));

void expectHome(
  WidgetTester tester, {
  required String header,
  required String cardTitle,
  required String draw,
  required String top,
  required String bottom,
  required String lead,
  required String block,
  required String running,
}) {
  expect(find.text(header), findsOneWidget);
  expect(find.text(cardTitle), findsOneWidget);
  expect(find.text(draw), findsOneWidget);
  expect(find.text(top), findsOneWidget);
  expect(find.text(bottom), findsOneWidget);
  expect(inBadgeRow(lead), findsOneWidget, reason: 'ตัวเด่น');
  expect(inBadgeRow(block), findsOneWidget, reason: 'ตัวกัน');
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
          lead: '6',
          block: '0',
          running: '3 · 1 · 4');
    });

    testWidgets('H2 Monday 2026-10-05 (different values, next draw on the 16th)', (tester) async {
      await pumpAt(tester, DateTime(2026, 10, 5));
      expectHome(tester,
          header: 'วันจันทร์ที่ 5 ต.ค. 2569',
          cardTitle: 'เลขล็อคประจำวันจันทร์',
          draw: 'งวด 16 ต.ค. 69',
          top: '2 7',
          bottom: '8 8',
          lead: '2',
          block: '6',
          running: '7 · 7 · 6');
    });

    testWidgets('H3 time of day does not change the date (Sunday 23:59)', (tester) async {
      await pumpAt(tester, DateTime(2026, 10, 25, 23, 59));
      expectHome(tester,
          header: 'วันอาทิตย์ที่ 25 ต.ค. 2569',
          cardTitle: 'เลขล็อคประจำวันอาทิตย์',
          draw: 'งวด 1 พ.ย. 69',
          top: '1 5',
          bottom: '6 4',
          lead: '1',
          block: '5',
          running: '3 · 6 · 9');
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

    testWidgets('F3 feature 1 on Monday 2026-10-26 starts on Monday', (tester) async {
      await pumpAt(tester, DateTime(2026, 10, 26));
      await openFeature(tester, 'ตำรา', 'พยากรณ์โชคชะตาชีวิต');
      expect(pillSelected(tester, 'จ'), isTrue);
      expect(find.text('เลือกวันเกิดของคุณ · วันจันทร์'), findsOneWidget);
    });
  });

  group('Feature 8 draw cards (current order locked)', () {
    Future<void> openDraws(WidgetTester tester, DateTime now) async {
      await pumpAt(tester, now);
      await openFeature(tester, 'เลขเด็ด', 'สูตรเลขเด่น');
    }

    /// Card 1 is always listed first; its date is beside its title.
    void expectCards(WidgetTester tester, {required String date1, required String date16}) {
      final t1 = tester.getCenter(find.text('งวดวันที่ 1'));
      final t16 = tester.getCenter(find.text('งวดวันที่ 16'));
      expect(t1.dy, lessThan(t16.dy), reason: 'card "งวดวันที่ 1" is shown first');
      expect(tester.getCenter(find.text(date1)).dy, moreOrLessEquals(t1.dy, epsilon: 4));
      expect(tester.getCenter(find.text(date16)).dy, moreOrLessEquals(t16.dy, epsilon: 4));
    }

    testWidgets('D1 2026-10-05: card 1 shows a later date than card 16 (existing behaviour)', (tester) async {
      await openDraws(tester, DateTime(2026, 10, 5));
      expectCards(tester, date1: '1 พ.ย. 2569', date16: '16 ต.ค. 2569');
      for (final n in ['4', '7', '9', '2', '5', '8']) {
        expect(find.text(n), findsOneWidget, reason: n);
      }
      expect(find.text('สูตร: เลขท้าย 2 ตัวงวดก่อน + เลขวันพระ แล้วถอดหลักหน่วย'), findsOneWidget);
      expect(find.text('สูตร: เลขหน้า 3 ตัว × กำลังดาวประจำวันออกรางวัล'), findsOneWidget);
      expect(find.textContaining('47 · 79 · 94', findRichText: true), findsOneWidget);
      expect(find.textContaining('25 · 58 · 82', findRichText: true), findsOneWidget);
    });

    testWidgets('D2 2026-10-23: chronological order', (tester) async {
      await openDraws(tester, DateTime(2026, 10, 23));
      expectCards(tester, date1: '1 พ.ย. 2569', date16: '16 พ.ย. 2569');
    });

    testWidgets('D3 2026-12-10: year rollover', (tester) async {
      await openDraws(tester, DateTime(2026, 12, 10));
      expectCards(tester, date1: '1 ม.ค. 2570', date16: '16 ธ.ค. 2569');
    });
  });
}
