// On-device smoke test: starts the real app (main(), opening animation included) on an emulator or phone
// and walks the main paths with real taps. It catches what flutter_tester cannot: the Android build,
// the bundled assets and fonts on a device, and the opening gate.
//
//   flutter test integration_test -d <device id>      (see README, "Running tests")
//
// Not run in CI: it needs an Android emulator.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:maha_dream/data/design_data.dart';
import 'package:maha_dream/data/formulas.dart';
import 'package:maha_dream/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /// Taps the bottom tab with [label]: of the widgets showing that text, the one lowest on screen.
  Future<void> openTab(WidgetTester tester, String label) async {
    final all = find.text(label).evaluate().toList();
    final tab = all.reduce(
      (a, b) =>
          tester.getCenter(find.byElementPredicate((e) => e == a)).dy >=
              tester.getCenter(find.byElementPredicate((e) => e == b)).dy
          ? a
          : b,
    );
    await tester.tap(find.byElementPredicate((e) => e == tab));
    await tester.pumpAndSettle();
  }

  Future<void> tapText(WidgetTester tester, String text) async {
    await tester.ensureVisible(find.text(text).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text(text).first);
    await tester.pumpAndSettle();
  }

  testWidgets('the real app opens and its main paths work on a device', (tester) async {
    app.main();
    // The opening animation starts a moment after the first frame and ends by itself (about 7 s);
    // it covers Home until then, so wait until it has left the tree.
    final opening = find.byWidgetPredicate((w) => w.runtimeType.toString() == '_OpeningView');
    await tester.pump(const Duration(seconds: 1));
    for (var i = 0; i < 300 && opening.evaluate().isNotEmpty; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(opening, findsNothing, reason: 'the opening animation finished');
    await tester.pumpAndSettle();
    expect(find.text('เมนูยอดนิยม'), findsOneWidget, reason: 'Home after the opening animation');

    // Search → dream detail → Back to the same results.
    await openTab(tester, 'ทำนายฝัน');
    await tester.enterText(find.byKey(const ValueKey('dream-search')), 'งู');
    await tester.pumpAndSettle();
    await tester.tap(find.text('งู').last);
    await tester.pumpAndSettle();
    expect(find.text('เลขนำโชคจากความฝัน'), findsOneWidget, reason: 'dream detail page');
    await tapText(tester, 'กลับ');
    expect(find.text('ค้นหาความฝัน'), findsWidgets, reason: 'back on the search page');

    // Menu 5: range chip filters the 100 animals.
    await openTab(tester, 'ตำรา');
    await tapText(tester, 'ทำนายฝันจากสัตว์');
    expect(find.text('100 ตัว'), findsOneWidget);
    await tapText(tester, '21–40');
    expect(find.text('20 ตัว'), findsOneWidget);

    // Menu 6: search across the 1,000 pae kong pictures by number.
    await openTab(tester, 'ตำรา');
    await tapText(tester, 'ภาพแป๊ะกงชี้โชค');
    expect(find.text('1000 ภาพ'), findsOneWidget);
    await tester.enterText(find.byKey(const ValueKey('pae-search')), '123');
    await tester.pumpAndSettle();
    expect(find.text('พบ 2 ภาพ'), findsOneWidget);

    // Menu 7: another weekday shows that day's lock numbers.
    await openTab(tester, 'เลขเด็ด');
    await tapText(tester, 'เลขล็อคตามวัน');
    final other = (weekdayIndex(nextDrawDate(DateTime.now())) + 1) % 7;
    await tester.tap(find.text(dayShort[other]).first);
    await tester.pumpAndSettle();
    expect(find.text('ถ้าสลากออกวัน${dayFull[other]}'), findsOneWidget);

    // Menu 3: the remedies list and its search box.
    await openTab(tester, 'แก้ฝัน');
    await tapText(tester, 'เคล็ดลับแก้ฝันร้าย');
    expect(find.text('ฝันว่าตกส้วม เปื้อนอุจจาระไปทั้งตัว'), findsOneWidget);
    await tester.enterText(find.byKey(const ValueKey('remedy-search')), 'เงินทอง');
    await tester.pumpAndSettle();
    expect(find.text('ฝันว่าได้เงินทอง'), findsOneWidget);
    expect(find.text('ฝันว่าตกส้วม เปื้อนอุจจาระไปทั้งตัว'), findsNothing);

    expect(tester.takeException(), isNull);
  });
}
