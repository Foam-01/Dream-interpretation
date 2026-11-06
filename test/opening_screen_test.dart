// The opening animation: plays over the app at start-up, ends by itself, and a tap skips it.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/main.dart';
import 'package:maha_dream/screens/opening_screen.dart';

void main() {
  Future<void> start(WidgetTester tester, {bool opening = true}) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MahaDreamApp(opening: opening));
    await tester.pump();
  }

  final home = find.text('เมื่อคืนคุณฝันเห็นอะไร...');

  testWidgets('shows the app name, then fades to Home by itself', (tester) async {
    await start(tester);
    await tester.pump(const Duration(milliseconds: 3000));
    expect(find.text('ทำนายฝัน'), findsWidgets);
    expect(find.text('ตำราทำนายฝัน พร้อมเลขนำโชค'), findsOneWidget);
    await tester.pump(OpeningGate.duration);
    await tester.pumpAndSettle();
    expect(find.text('ตำราทำนายฝัน พร้อมเลขนำโชค'), findsNothing);
    expect(home.hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a tap skips to Home', (tester) async {
    await start(tester);
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tapAt(const Offset(195, 700));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    expect(find.text('ตำราทำนายฝัน พร้อมเลขนำโชค'), findsNothing);
    expect(home.hitTestable(), findsOneWidget);
  });

  testWidgets('off by default (tests, goldens) and with reduce motion', (tester) async {
    await start(tester, opening: false);
    expect(home.hitTestable(), findsOneWidget);

    tester.platformDispatcher.accessibilityFeaturesTestValue = FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAllTestValues);
    await tester.pumpWidget(const SizedBox());
    await start(tester);
    expect(find.text('ตำราทำนายฝัน พร้อมเลขนำโชค'), findsNothing);
    expect(home.hitTestable(), findsOneWidget);
  });
}
