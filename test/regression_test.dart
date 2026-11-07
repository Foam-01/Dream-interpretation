// Regression tests (M0.1): lock in current behavior before the M1–M4 refactor.
// Expected values are taken from the current implementation in lib/, not from
// any real textbook data.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/data/design_data.dart';
import 'package:maha_dream/data/formulas.dart';
import 'package:maha_dream/data/pae_numbers.dart';
import 'package:maha_dream/data/lock_numbers.dart';
import 'package:maha_dream/main.dart';
import 'package:maha_dream/screens/home_screen.dart' show DreamCard;
import 'package:maha_dream/widgets/ui.dart';

import 'fixtures/legacy_sample_data.dart';
import 'pager_helper.dart';

Future<void> pumpApp(WidgetTester tester, {double textScale = 1.0}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  await tester.pumpWidget(const MahaDreamApp(repository: legacySampleRepository));
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
      // The query field shows "ช้าง" too; count result rows only.
      expect(find.descendant(of: find.byType(InkWell), matching: find.text('ช้าง')), findsOneWidget);

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
      expect(find.text('พบ ${legacySampleDreams.length} รายการ'), findsOneWidget);
      expect(find.text('พบ 10 รายการ'), findsOneWidget);
    });

    testWidgets('query matches text in the `short` field', (tester) async {
      await pumpApp(tester);
      await openSearch(tester);
      await typeQuery(tester, 'ลาภก้อนเล็ก'); // only in ปลา.short
      expect(find.text('พบ 1 รายการ'), findsOneWidget);
      expect(find.text('ปลา'), findsOneWidget);
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
      await tapText(tester, 'ฟันหลุด', last: true); // the row, not the query field
    }

    testWidgets('ฟันหลุด shows numbers 08 and 098 · 809', (tester) async {
      await openToothDream(tester);
      expect(find.text('ฟันหลุด'), findsOneWidget);
      expect(find.text('08 · 80'), findsOneWidget);
      expect(find.text('098 · 809'), findsOneWidget);
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
      await tapText(tester, 'งู');
      await scrollTo(tester, find.text('เคล็ดลับขอโชค'));
      expect(find.text('เคล็ดลับแก้ฝันร้าย'), findsNothing);
    });

    testWidgets('"อ่านบทสวด ›" goes to the ritual tab menu (not directly to prayers)', (tester) async {
      await openToothDream(tester);
      await tapText(tester, 'อ่านบทสวด ›');
      expect(find.text('แก้ฝันและขอโชค'), findsOneWidget);
      expect(find.text('บทสวดมนต์ความฝัน'), findsOneWidget);
      expect(find.text('ฟันหลุด'), findsNothing);
    });

    testWidgets('"‹ กลับ" returns to search keeping the query', (tester) async {
      await openToothDream(tester);
      await tapText(tester, 'กลับ');
      expect(find.text('ค้นหาความฝัน'), findsOneWidget);
      expect(find.text('พบ 1 รายการ'), findsOneWidget);
    });
  });

  // Group C (save toggle) removed: the detail page has no save button until accounts exist.

  group('D. Navigation', () {
    testWidgets('tapping the current tab inside a feature returns to its menu', (tester) async {
      await pumpApp(tester);
      await tapTab(tester, 'ตำรา');
      await tapText(tester, 'ทำนายฝันจากสัตว์');
      expect(find.byKey(const ValueKey('animal-search')), findsOneWidget, reason: 'on the animals page');
      await tapTab(tester, 'ตำรา');
      expect(find.byKey(const ValueKey('animal-search')), findsNothing);
      expect(find.text('ตำราทำนาย'), findsOneWidget);
      expect(find.text('ทำนายฝันจากสัตว์'), findsOneWidget, reason: 'the menu row, same name as the page');
    });

    testWidgets('tapping the current tab on detail resets to search', (tester) async {
      await pumpApp(tester);
      await openSearch(tester);
      await tapText(tester, 'งู');
      await tapTab(tester, 'ทำนายฝัน');
      expect(find.text('ค้นหาความฝัน'), findsOneWidget);
      expect(find.text('เลขนำโชคจากความฝัน'), findsNothing);
    });

    testWidgets('feature header back link returns to menu', (tester) async {
      await pumpApp(tester);
      await tapTab(tester, 'เลขเด็ด');
      await tapText(tester, 'เลขล็อคตามวัน');
      await tester.tap(find.byType(BackLink));
      await tester.pumpAndSettle();
      expect(find.text('สูตรเลขประจำงวด'), findsOneWidget);
    });

    testWidgets('system back: feature -> menu -> home, then stays on home', (tester) async {
      await pumpApp(tester);
      await tapTab(tester, 'ตำรา');
      await tapText(tester, 'ทำนายฝันจากสัตว์');
      expect(find.byKey(const ValueKey('animal-search')), findsOneWidget);

      await systemBack(tester);
      expect(find.byKey(const ValueKey('animal-search')), findsNothing, reason: 'left the animals page');
      expect(find.text('ตำราทำนาย'), findsOneWidget);

      await systemBack(tester);
      // Home header title (the label also appears on the quick link and tab).
      expect(find.descendant(of: find.byType(PageHeader), matching: find.text('ทำนายฝัน')), findsOneWidget);
      expect(find.text('เมนูยอดนิยม'), findsOneWidget);

      // At home root PopScope allows the pop; the test harness has no
      // activity to close, so the home page must still be shown.
      await systemBack(tester);
      expect(find.text('เมนูยอดนิยม'), findsOneWidget);
    });

    testWidgets('system back on detail returns to search', (tester) async {
      await pumpApp(tester);
      await openSearch(tester);
      await tapText(tester, 'งู');
      await systemBack(tester);
      expect(find.text('ค้นหาความฝัน'), findsOneWidget);
      await systemBack(tester);
      expect(find.text('เมนูยอดนิยม'), findsOneWidget);
    });
  });

  group('E. Feature selection', () {
    testWidgets('lock-by-day: selecting Monday shows the Monday numbers from the book', (tester) async {
      await pumpApp(tester);
      await tapTab(tester, 'เลขเด็ด');
      await tapText(tester, 'เลขล็อคตามวัน');
      await tapPill(tester, 'จ');
      await tester.pumpAndSettle();
      for (final n in [...lockTop[1], ...lockBottom[1]]) {
        expect(find.text(n), findsWidgets, reason: n);
      }
      expect(find.textContaining('คำนวณจากดาวประจำวัน'), findsNothing, reason: 'sample formula removed');
    });

    testWidgets('life fortune (menu 1) opens the dream search, not a birthday formula', (tester) async {
      await pumpApp(tester);
      await tapTab(tester, 'ตำรา');
      await tapText(tester, 'พยากรณ์โชคชะตาชีวิต');
      expect(find.text('ค้นหาความฝัน'), findsWidgets);
      expect(find.textContaining('พบ '), findsOneWidget); // the search result count
      expect(find.textContaining('เลือกวันเกิดของคุณ', skipOffstage: false), findsNothing);
    });

    testWidgets('digit summary: tapping 7 jumps to the ฝันแบบไหนเป็นเลข 7 card', (tester) async {
      await pumpApp(tester);
      await tapTab(tester, 'เลขเด็ด');
      await tapText(tester, 'สรุปเลขนำโชค 0–9');
      expect(find.text('ฝันแบบไหนเป็นเลข 7').hitTestable(), findsNothing);
      await tapPill(tester, '7');
      await tester.pumpAndSettle();
      expect(find.text('ฝันแบบไหนเป็นเลข 7').hitTestable(), findsOneWidget);
    });

    test('the bundled real content has no single lucky digits', () {
      expect(dreams.expand((d) => d.digits), isEmpty);
    });

    testWidgets('pae kong: the pager shows the next 21 of the book', (tester) async {
      await pumpApp(tester);
      await tapTab(tester, 'ตำรา');
      await tapText(tester, 'ภาพแป๊ะกงชี้โชค');
      expect(find.text(paeNumbers.first.name), findsOneWidget);
      await tapPager(tester, 'ไปหน้าถัดไป');
      expect(find.text(paeNumbers[21].lucky, skipOffstage: false), findsOneWidget);
      expect(find.text(paeNumbers.first.name), findsNothing);
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
      expect(nextDrawDate(DateTime(2026, 12, 20)), DateTime(2027, 1, 2)); // year rollover, New Year draw moved to the 2nd
      // Draws the lottery office moved (drawShifts): 16 Dec 2569 → 17 Dec, 1 Jan 2570 → 2 Jan.
      expect(nextDrawDate(DateTime(2026, 12, 10)), DateTime(2026, 12, 17));
      expect(nextDrawDate(DateTime(2026, 12, 17)), DateTime(2026, 12, 17));
      expect(nextDrawDate(DateTime(2027, 1, 1)), DateTime(2027, 1, 2));
      expect(nextDrawDate(DateTime(2027, 1, 3)), DateTime(2027, 1, 16));
      expect(drawRound(DateTime(2026, 12, 17)), 16);
      expect(drawRound(DateTime(2027, 1, 2)), 1);
      expect(drawRound(DateTime(2026, 11, 16)), 16);
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
      await tapText(tester, 'งู');
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
        // The hot list is a daily random draw, so check whichever card comes first.
        await scrollTo(tester, find.text('ฝันยอดฮิตวันนี้'));
        // The row now sits mid-page and may still be loading when its title appears.
        await tester.pumpAndSettle();
        await scrollTo(tester, find.byType(DreamCard).first);
        final card = find.byType(DreamCard).first;
        final shown = tester.widget<DreamCard>(card);
        final cardRect = tester.getRect(card);
        for (final f in [
          find.descendant(of: card, matching: find.text(shown.name)),
          find.descendant(of: card, matching: find.text(shown.number)),
        ]) {
          final r = tester.getRect(f);
          expect(r.bottom, lessThanOrEqualTo(cardRect.bottom), reason: 'text bottom inside card');
          expect(r.top, greaterThanOrEqualTo(cardRect.top));
        }
        expect(tester.takeException(), isNull);
      });
    }
  });
}
