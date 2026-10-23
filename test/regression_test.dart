// Regression tests (M0.1): lock in current behavior before the M1–M4 refactor.
// Expected values are taken from the current implementation in lib/, not from
// any real textbook data.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/data/design_data.dart';
import 'package:maha_dream/data/formulas.dart';
import 'package:maha_dream/main.dart';
import 'package:maha_dream/screens/home_screen.dart' show DreamCard;
import 'package:maha_dream/widgets/ui.dart';

Future<void> pumpApp(WidgetTester tester, {double textScale = 1.0}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  await tester.pumpWidget(const MahaDreamApp());
}

Future<void> tapText(WidgetTester tester, String text, {bool last = false}) async {
  final f = last ? find.text(text).last : find.text(text);
  // Items may sit outside the viewport (lazy/horizontal lists).
  await tester.ensureVisible(f);
  await tester.pump();
  await tester.tap(f);
  await tester.pump();
}

/// Category/day/digit pills: the same label can also appear in result rows.
Future<void> tapPill(WidgetTester tester, String text) async {
  final f = find.widgetWithText(SelectPill, text);
  if (f.evaluate().isEmpty) {
    // Lazily built horizontal pill row: scroll it until the pill exists.
    final row = find.ancestor(of: find.byType(SelectPill).first, matching: find.byType(Scrollable)).first;
    final atStart = tester.state<ScrollableState>(row).position.pixels == 0;
    await tester.scrollUntilVisible(f, atStart ? 80 : -80, scrollable: row);
  }
  await tester.ensureVisible(f);
  await tester.pump();
  await tester.tap(f);
  await tester.pump();
}

/// Feature pages contain nested non-scrolling grids, so target the page list.
Future<void> scrollTo(WidgetTester tester, Finder f) =>
    tester.scrollUntilVisible(f, 200, scrollable: find.byType(Scrollable).first);

/// Bottom tab labels also appear elsewhere (e.g. home quick links), and the
/// tab bar is built after the page body, so the last match is the tab.
Future<void> tapTab(WidgetTester tester, String label) => tapText(tester, label, last: true);

Future<void> openSearch(WidgetTester tester) => tapText(tester, 'เมื่อคืนคุณฝันเห็นอะไร...');

Future<void> typeQuery(WidgetTester tester, String q) async {
  await tester.enterText(find.byType(TextField), q);
  await tester.pump();
}

Future<void> systemBack(WidgetTester tester) async {
  await tester.binding.handlePopRoute();
  await tester.pump();
}

void main() {
  group('A. Search and category', () {
    testWidgets('category "สัตว์" shows 4 results', (tester) async {
      await pumpApp(tester);
      await openSearch(tester);
      await tapPill(tester, 'สัตว์');
      expect(find.text('พบ 4 รายการ'), findsOneWidget);
    });

    testWidgets('query + category must satisfy both conditions', (tester) async {
      await pumpApp(tester);
      await openSearch(tester);
      await tapPill(tester, 'สัตว์');
      await typeQuery(tester, 'ช้าง');
      expect(find.text('พบ 1 รายการ'), findsOneWidget);
      expect(find.text('ฝันเห็นช้าง'), findsOneWidget);

      // Matches the query but not the category -> excluded.
      await typeQuery(tester, 'ไฟไหม้');
      expect(find.text('พบ 0 รายการ'), findsOneWidget);
      expect(find.text('ไม่พบความฝันนี้ ลองคำอื่น'), findsOneWidget);
    });

    testWidgets('"ทั้งหมด" with empty query shows all 10', (tester) async {
      await pumpApp(tester);
      await openSearch(tester);
      await tapPill(tester, 'สัตว์');
      expect(find.text('พบ 4 รายการ'), findsOneWidget);
      await tapPill(tester, 'ทั้งหมด');
      expect(find.text('พบ ${dreams.length} รายการ'), findsOneWidget);
      expect(find.text('พบ 10 รายการ'), findsOneWidget);
    });

    testWidgets('query matches text in the `short` field', (tester) async {
      await pumpApp(tester);
      await openSearch(tester);
      await typeQuery(tester, 'ลาภก้อนเล็ก'); // only in ปลา.short
      expect(find.text('พบ 1 รายการ'), findsOneWidget);
      expect(find.text('ฝันเห็นปลา'), findsOneWidget);
    });

    testWidgets('clear button restores results for the selected category', (tester) async {
      await pumpApp(tester);
      await openSearch(tester);
      await tapPill(tester, 'สัตว์');
      await typeQuery(tester, 'งู');
      expect(find.text('พบ 1 รายการ'), findsOneWidget);
      await tester.tap(find.byTooltip('ล้างคำค้นหา'));
      await tester.pump();
      expect(find.text('พบ 4 รายการ'), findsOneWidget);
      expect(find.byTooltip('ล้างคำค้นหา'), findsNothing);
      expect(tester.widget<TextField>(find.byType(TextField)).controller!.text, isEmpty);
    });

    testWidgets('query and category persist when switching tabs (current behavior)', (tester) async {
      await pumpApp(tester);
      await openSearch(tester);
      await tapPill(tester, 'สัตว์');
      await typeQuery(tester, 'งู');
      await tapTab(tester, 'ตำรา');
      await tapTab(tester, 'ทำนายฝัน');
      expect(tester.widget<TextField>(find.byType(TextField)).controller!.text, 'งู');
      expect(find.text('พบ 1 รายการ'), findsOneWidget);
    });

    testWidgets('home quick link "ทำนายฝัน" resets category but keeps query (current behavior)', (tester) async {
      await pumpApp(tester);
      await openSearch(tester);
      await tapPill(tester, 'สัตว์');
      await tapTab(tester, 'หน้าแรก');
      // App title, quick link and tab share the label; target the quick-link grid.
      await tester.tap(find.descendant(of: find.byType(ContentGrid), matching: find.text('ทำนายฝัน')));
      await tester.pump();
      expect(find.text('พบ 10 รายการ'), findsOneWidget);
    });
  });

  group('B. Dream detail', () {
    Future<void> openToothDream(WidgetTester tester) async {
      await pumpApp(tester);
      await openSearch(tester);
      await typeQuery(tester, 'ฟันหลุด');
      await tapText(tester, 'ฝันเห็นฟันหลุด');
    }

    testWidgets('ฟันหลุด shows numbers 08 and 098 · 809', (tester) async {
      await openToothDream(tester);
      expect(find.text('ฝันเห็นฟันหลุด'), findsOneWidget);
      expect(find.text('08 · 80'), findsOneWidget);
      expect(find.text('098 · 809'), findsOneWidget);
      // Lucky digit boxes keep the leading zero digit.
      expect(find.text('0'), findsOneWidget);
      expect(find.text('8'), findsOneWidget);
    });

    testWidgets('bad-omen dream shows "เคล็ดลับแก้ฝันร้าย"', (tester) async {
      await openToothDream(tester);
      await scrollTo(tester, find.text('เคล็ดลับแก้ฝันร้าย'));
      expect(find.text('เคล็ดลับแก้ฝันร้าย'), findsOneWidget);
      expect(find.text('เคล็ดลับขอโชค'), findsNothing);
    });

    testWidgets('good-omen dream shows "เคล็ดลับขอโชค"', (tester) async {
      await pumpApp(tester);
      await openSearch(tester);
      await tapText(tester, 'ฝันเห็นงู');
      await scrollTo(tester, find.text('เคล็ดลับขอโชค'));
      expect(find.text('เคล็ดลับแก้ฝันร้าย'), findsNothing);
    });

    testWidgets('"อ่านบทสวด ›" goes to the ritual tab menu (not directly to prayers)', (tester) async {
      await openToothDream(tester);
            await tapText(tester, 'อ่านบทสวด ›');
      expect(find.text('แก้ฝัน & ขอโชค'), findsOneWidget);
      expect(find.text('บทสวดมนต์ความฝัน'), findsOneWidget);
      expect(find.text('ฝันเห็นฟันหลุด'), findsNothing);
    });

    testWidgets('"‹ กลับ" returns to search keeping the query', (tester) async {
      await openToothDream(tester);
      await tapText(tester, '‹ กลับ');
      expect(find.text('ค้นหาความฝัน'), findsOneWidget);
      expect(find.text('พบ 1 รายการ'), findsOneWidget);
    });
  });

  group('C. Saved dreams (in-memory)', () {
    testWidgets('toggling save twice returns to initial state', (tester) async {
      await pumpApp(tester);
      await openSearch(tester);
      await tapText(tester, 'ฝันเห็นงู');
      expect(find.text('บันทึก'), findsOneWidget);
      expect(find.byIcon(Icons.star_border), findsOneWidget);
      await tapText(tester, 'บันทึก');
      expect(find.text('บันทึกแล้ว'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
      await tapText(tester, 'บันทึกแล้ว');
      expect(find.text('บันทึก'), findsOneWidget);
      expect(find.text('บันทึกแล้ว'), findsNothing);
    });

    testWidgets('saving one dream does not change another', (tester) async {
      await pumpApp(tester);
      await openSearch(tester);
      await tapText(tester, 'ฝันเห็นงู');
      await tapText(tester, 'บันทึก');
      await tapText(tester, '‹ กลับ');
      await tapText(tester, 'ฝันเห็นช้าง');
      expect(find.text('บันทึก'), findsOneWidget);
      expect(find.text('บันทึกแล้ว'), findsNothing);
      await tapText(tester, '‹ กลับ');
      await tapText(tester, 'ฝันเห็นงู');
      expect(find.text('บันทึกแล้ว'), findsOneWidget);
    });
  });

  group('D. Navigation', () {
    testWidgets('tapping the current tab inside a feature returns to its menu', (tester) async {
      await pumpApp(tester);
      await tapTab(tester, 'ตำรา');
      await tapText(tester, 'ตารางชื่อสัตว์');
      expect(find.text('ทำนายฝันจากสัตว์'), findsOneWidget);
      await tapTab(tester, 'ตำรา');
      expect(find.text('ทำนายฝันจากสัตว์'), findsNothing);
      expect(find.text('ตำราทำนาย'), findsOneWidget);
      expect(find.text('ตารางชื่อสัตว์'), findsOneWidget);
    });

    testWidgets('tapping the current tab on detail resets to search', (tester) async {
      await pumpApp(tester);
      await openSearch(tester);
      await tapText(tester, 'ฝันเห็นงู');
      await tapTab(tester, 'ทำนายฝัน');
      expect(find.text('ค้นหาความฝัน'), findsOneWidget);
      expect(find.text('เลขนำโชคจากความฝัน'), findsNothing);
    });

    testWidgets('feature header back link returns to menu', (tester) async {
      await pumpApp(tester);
      await tapTab(tester, 'เลขเด็ด');
      await tapText(tester, 'เลขล็อคตามวัน');
      await tapText(tester, '‹ เลขเด็ด');
      expect(find.text('สูตรเลขประจำงวด'), findsOneWidget);
    });

    testWidgets('system back: feature -> menu -> home, then stays on home', (tester) async {
      await pumpApp(tester);
      await tapTab(tester, 'ตำรา');
      await tapText(tester, 'ตารางชื่อสัตว์');
      expect(find.text('ทำนายฝันจากสัตว์'), findsOneWidget);

      await systemBack(tester);
      expect(find.text('ทำนายฝันจากสัตว์'), findsNothing);
      expect(find.text('ตำราทำนาย'), findsOneWidget);

      await systemBack(tester);
      // Home header title (the label also appears on the quick link and tab).
      expect(find.descendant(of: find.byType(RedHeader), matching: find.text('ทำนายฝัน')), findsOneWidget);
      expect(find.text('หมวดยอดนิยม'), findsOneWidget);

      // At home root PopScope allows the pop; the test harness has no
      // activity to close, so the home page must still be shown.
      await systemBack(tester);
      expect(find.text('หมวดยอดนิยม'), findsOneWidget);
    });

    testWidgets('system back on detail returns to search', (tester) async {
      await pumpApp(tester);
      await openSearch(tester);
      await tapText(tester, 'ฝันเห็นงู');
      await systemBack(tester);
      expect(find.text('ค้นหาความฝัน'), findsOneWidget);
      await systemBack(tester);
      expect(find.text('หมวดยอดนิยม'), findsOneWidget);
    });
  });

  group('E. Feature selection', () {
    testWidgets('lock-by-day: selecting Monday shows Monday numbers', (tester) async {
      await pumpApp(tester);
      await tapTab(tester, 'เลขเด็ด');
      await tapText(tester, 'เลขล็อคตามวัน');
      await tapPill(tester, 'จ');
      final expected = dayData('7', 1);
      expect(find.text('วันจันทร์'), findsOneWidget);
      expect(expected.tiles[0].value, '2 7');
      expect(find.text('2 7'), findsOneWidget);
      expect(find.text(expected.tiles[1].value), findsOneWidget);
      expect(find.text('เลขล็อควันจันทร์ คำนวณจากดาวประจำวัน (2) และฤกษ์ยามงวดนี้'), findsOneWidget);
    });

    testWidgets('life fortune shows birth-day caption prefix', (tester) async {
      await pumpApp(tester);
      await tapTab(tester, 'ตำรา');
      await tapText(tester, 'พยากรณ์โชคชะตาชีวิต');
      await tapPill(tester, 'อา');
      expect(find.text('เลือกวันเกิดของคุณ · วันอาทิตย์'), findsOneWidget);
    });

    testWidgets('digit summary: selecting 7 lists dreams containing 7', (tester) async {
      await pumpApp(tester);
      await tapTab(tester, 'เลขเด็ด');
      await tapText(tester, 'สรุปเลขนำโชค 0–9');
      expect(find.text('เลข 5 · ตะขอ · งู'), findsOneWidget); // default digit
      await tapPill(tester, '7');
      expect(find.text('เลข 7 · ไม้เท้า'), findsOneWidget);
      expect(find.text('ความฝันที่ให้เลข 7'), findsOneWidget);
      await scrollTo(tester, find.text('ฝันเห็นเสือ'));
      expect(find.text('ฝันเห็นน้ำท่วม'), findsOneWidget);
      expect(find.text('ฝันเห็นเสือ'), findsOneWidget);
      expect(find.text('ฝันเห็นงู'), findsNothing);
    });

    test('digit summary empty state is unreachable with current data', () {
      // Every digit 0-9 appears in at least one dream, so the
      // "ยังไม่มีความฝันที่ให้เลขนี้" branch cannot be reached through the UI.
      final used = dreams.expand((d) => d.digits).toSet();
      expect(used, containsAll(['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']));
    });

    testWidgets('pae kong: selecting 300–399 jumps to 300 and cells are selectable', (tester) async {
      await pumpApp(tester);
      await tapTab(tester, 'ตำรา');
      await tapText(tester, 'ภาพแป๊ะกงชี้โชค');
      expect(find.text('เลขกลับ 950'), findsOneWidget); // default 059
      await tapPill(tester, '300–399');
      expect(find.text('เลขกลับ 003'), findsOneWidget);
      expect(find.text(paeOf(300).name), findsWidgets);
      // Direct tap: ensureVisible inside the nested non-scrolling grid moves
      // the target away (harness quirk, not app behavior).
      await tester.tap(find.text('301'));
      await tester.pump();
      expect(find.text('เลขกลับ 103'), findsOneWidget);
      expect(find.text('301'), findsNWidgets(2)); // header + grid cell
    });
  });

  group('F. Date utilities', () {
    test('weekdayIndex maps Sunday to 0 and Saturday to 6', () {
      expect(weekdayIndex(DateTime(2026, 10, 25)), 0); // Sunday
      expect(weekdayIndex(DateTime(2026, 10, 26)), 1); // Monday
      expect(weekdayIndex(DateTime(2026, 10, 23)), 5); // Friday
      expect(weekdayIndex(DateTime(2026, 10, 24)), 6); // Saturday
    });

    test('thaiDate uses Buddhist Era year and abbreviated month', () {
      expect(thaiDate(DateTime(2026, 10, 23)), '23 ต.ค. 2569');
      expect(thaiDate(DateTime(2026, 1, 1)), '1 ม.ค. 2569');
      expect(thaiDate(DateTime(2026, 12, 31)), '31 ธ.ค. 2569');
      expect(thaiDate(DateTime(2024, 2, 29)), '29 ก.พ. 2567');
    });

    test('thaiDateShort uses 2-digit Buddhist Era year', () {
      expect(thaiDateShort(DateTime(2026, 11, 1)), '1 พ.ย. 69');
      expect(thaiDateShort(DateTime(2027, 1, 16)), '16 ม.ค. 70');
    });

    test('thaiDateLong includes Thai weekday name', () {
      expect(thaiDateLong(DateTime(2026, 10, 23)), 'วันศุกร์ที่ 23 ต.ค. 2569');
      expect(thaiDateLong(DateTime(2026, 10, 25)), 'วันอาทิตย์ที่ 25 ต.ค. 2569');
    });

    test('nextDrawDate boundaries', () {
      expect(nextDrawDate(DateTime(2026, 10, 1)), DateTime(2026, 10, 1));
      expect(nextDrawDate(DateTime(2026, 10, 2)), DateTime(2026, 10, 16));
      expect(nextDrawDate(DateTime(2026, 10, 16)), DateTime(2026, 10, 16));
      expect(nextDrawDate(DateTime(2026, 10, 17)), DateTime(2026, 11, 1));
      expect(nextDrawDate(DateTime(2026, 12, 20)), DateTime(2027, 1, 1)); // year rollover
      expect(nextDrawDate(DateTime(2026, 10, 1, 23, 59)), DateTime(2026, 10, 1)); // time ignored
    });
  });

  group('G. Text scale 1.3 — no exceptions or overflow (known app failures, see report)', () {
    Future<void> expectClean(WidgetTester tester, String where) async {
      expect(tester.takeException(), isNull, reason: where);
    }

    testWidgets('home', (tester) async {
      await pumpApp(tester, textScale: 1.3);
      await expectClean(tester, 'home');
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -600));
      await tester.pump();
      await expectClean(tester, 'home scrolled');
    });

    testWidgets('search and detail', (tester) async {
      await pumpApp(tester, textScale: 1.3);
      await openSearch(tester);
      await expectClean(tester, 'search');
      await tapText(tester, 'ฝันเห็นงู');
      await expectClean(tester, 'detail');
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -1200));
      await tester.pump();
      await expectClean(tester, 'detail scrolled');
    });

    testWidgets('key features', (tester) async {
      await pumpApp(tester, textScale: 1.3);
      for (final k in ['7', '2', '8', '9']) {
        await tapTab(tester, 'เลขเด็ด');
        await tapText(tester, menus['lucky']!.items.firstWhere((i) => i.key == k).title);
        await expectClean(tester, 'feature $k');
      }
      for (final k in ['5', '6']) {
        await tapTab(tester, 'ตำรา');
        await tapText(tester, menus['book']!.items.firstWhere((i) => i.key == k).title);
        await expectClean(tester, 'feature $k');
      }
    });
  });

  group('H. Home hot-dream cards are not clipped (M0.2)', () {
    for (final scale in [1.0, 1.3]) {
      testWidgets('card content fits inside the card at text scale $scale', (tester) async {
        await pumpApp(tester, textScale: scale);
        // Home is a lazy list: scroll the page until the hot row is built.
        await scrollTo(tester, find.text('ฝันเห็นงู'));
        final card = find.ancestor(of: find.text('ฝันเห็นงู').first, matching: find.byType(DreamCard));
        final cardRect = tester.getRect(card);
        for (final f in [find.text('ฝันเห็นงู').first, find.text(dreams[0].firstTwo).first]) {
          final r = tester.getRect(f);
          expect(r.bottom, lessThanOrEqualTo(cardRect.bottom), reason: 'text bottom inside card');
          expect(r.top, greaterThanOrEqualTo(cardRect.top));
        }
        expect(tester.takeException(), isNull);
      });
    }
  });
}
