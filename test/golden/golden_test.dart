// Golden baseline, group A (M0.3): screens that do not depend on the current
// date/time. Home and day-based formulas are excluded until time is injectable.
// Fonts are loaded by test/golden/flutter_test_config.dart.
@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/data/dream_images_k.dart';
import 'package:maha_dream/main.dart';
import 'package:maha_dream/widgets/ui.dart';

import 'flutter_test_config.dart' show appFonts;

const _logicalSize = Size(390, 844);
const _dpr = 2.0;

Future<void> pumpApp(WidgetTester tester) async {
  tester.view.physicalSize = _logicalSize * _dpr;
  tester.view.devicePixelRatio = _dpr;
  tester.platformDispatcher.textScaleFactorTestValue = 1.0;
  tester.platformDispatcher.localeTestValue = const Locale('th');
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearAllTestValues);
  await tester.pumpWidget(const MahaDreamApp());
  await tester.pumpAndSettle();
}

/// Decodes the bundled dream pictures before a capture (asset decoding is asynchronous).
Future<void> precacheDreamImages(WidgetTester tester) async {
  final context = tester.element(find.byType(Scaffold).first);
  await tester.runAsync(() async {
    for (final image in dreamImagesK.values) {
      await precacheImage(AssetImage(image.url), context);
    }
  });
  await tester.pumpAndSettle();
}

Future<void> tap(WidgetTester tester, Finder f) async {
  await tester.tap(f);
  await tester.pumpAndSettle();
}

Finder _text(String s) => find.text(s);

/// Bottom tab label (the tab bar is built after the page body).
Finder _tab(String label) => find.text(label).last;

Future<void> expectGolden(WidgetTester tester, String name) async {
  expect(tester.takeException(), isNull, reason: 'no exceptions/overflow before capture');
  // Every capture starts at scroll offset 0 because each screen is rebuilt
  // with a fresh key on navigation (see AppShell).
  await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/$name.png'));
}

double _textWidth(String family) {
  final p = TextPainter(
    text: TextSpan(
      text: 'มหาทำนายฝัน 0123',
      style: TextStyle(fontFamily: family, fontSize: 20),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  return p.width;
}

Future<void> openSearch(WidgetTester tester) => tap(tester, _text('เมื่อคืนคุณฝันเห็นอะไร...'));

Future<void> openFeature(WidgetTester tester, String tab, String menuTitle) async {
  await tap(tester, _tab(tab));
  await tap(tester, _text(menuTitle));
}

void main() {
  test('real Noto Thai fonts are loaded (metrics differ from the test font)', () {
    // The default flutter_test font draws every glyph as a fontSize square;
    // a really loaded family yields a different width for the same string.
    final fallback = _textWidth('FlutterTest');
    for (final family in appFonts.keys) {
      expect(_textWidth(family), isNot(closeTo(fallback, 0.5)), reason: family);
    }
  });

  group('Golden A — search', () {
    testWidgets('search: default list', (tester) async {
      await pumpApp(tester);
      await openSearch(tester);
      await precacheDreamImages(tester);
      await expectGolden(tester, 'search_default');
    });

    testWidgets('search: no results', (tester) async {
      await pumpApp(tester);
      await openSearch(tester);
      await tester.enterText(find.byType(TextField), 'ไม่มีคำนี้');
      await tester.pumpAndSettle();
      // Hide the text cursor blink difference by unfocusing.
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
      await expectGolden(tester, 'search_empty');
    });

    testWidgets('search: category หมวด ก selected', (tester) async {
      await pumpApp(tester);
      await openSearch(tester);
      await tap(tester, find.widgetWithText(SelectPill, 'หมวด ก'));
      await precacheDreamImages(tester);
      await expectGolden(tester, 'search_cat_k');
    });
  });

  group('Golden A — dream detail', () {
    testWidgets('detail: กบ (lucky numbers, no source cited)', (tester) async {
      await pumpApp(tester);
      await openSearch(tester);
      await tap(tester, _text('กบ'));
      await precacheDreamImages(tester);
      await expectGolden(tester, 'detail_frog');
    });

    testWidgets('detail: กราม (ไม่ควรเสี่ยง)', (tester) async {
      await pumpApp(tester);
      await openSearch(tester);
      await tap(tester, _text('กราม'));
      await expectGolden(tester, 'detail_jaw');
    });
  });

  group('Golden A — tab menus', () {
    testWidgets('menu: เลขเด็ด', (tester) async {
      await pumpApp(tester);
      await tap(tester, _tab('เลขเด็ด'));
      await expectGolden(tester, 'menu_lucky');
    });

    testWidgets('menu: แก้ฝัน', (tester) async {
      await pumpApp(tester);
      await tap(tester, _tab('แก้ฝัน'));
      await expectGolden(tester, 'menu_ritual');
    });

    testWidgets('menu: ตำรา', (tester) async {
      await pumpApp(tester);
      await tap(tester, _tab('ตำรา'));
      await expectGolden(tester, 'menu_book');
    });
  });

  group('Golden A — features (time-independent)', () {
    testWidgets('feature 12: หลักทำนายฝันตัวเลข (digit lore table)', (tester) async {
      await pumpApp(tester);
      await openFeature(tester, 'ตำรา', 'หลักทำนายฝันตัวเลข');
      await expectGolden(tester, 'feat12_digit_lore_table');
    });

    testWidgets('feature 2: สรุปเลขนำโชค 0–9 (digit summary, default digit 5)', (tester) async {
      await pumpApp(tester);
      await openFeature(tester, 'เลขเด็ด', 'สรุปเลขนำโชค 0–9');
      await expectGolden(tester, 'feat02_digit_summary');
    });

    testWidgets('feature 5: ตารางชื่อสัตว์ (animals)', (tester) async {
      await pumpApp(tester);
      await openFeature(tester, 'ตำรา', 'ตารางชื่อสัตว์');
      await expectGolden(tester, 'feat05_animals');
    });

    testWidgets('feature 6: ภาพแป๊ะกงชี้โชค (pae kong, default 059)', (tester) async {
      await pumpApp(tester);
      await openFeature(tester, 'ตำรา', 'ภาพแป๊ะกงชี้โชค');
      await expectGolden(tester, 'feat06_pae_kong');
    });

    testWidgets('feature 13: ทำนายฝันหมวด ก (list with per-dream pictures)', (tester) async {
      await pumpApp(tester);
      await openFeature(tester, 'ตำรา', 'ทำนายฝันหมวด ก');
      await precacheDreamImages(tester);
      await expectGolden(tester, 'feat13_letter_k');
    });


    testWidgets('feature 3: เคล็ดลับแก้ฝันร้าย (steps / remedies)', (tester) async {
      await pumpApp(tester);
      await openFeature(tester, 'แก้ฝัน', 'เคล็ดลับแก้ฝันร้าย');
      await expectGolden(tester, 'feat03_remedy_steps');
    });
  });
}
