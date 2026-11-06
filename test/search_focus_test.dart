// Open-and-search: Home's search box opens the search screen ready to type, and a lucky number finds its dream.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/main.dart';

void main() {
  Future<void> openApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MahaDreamApp());
    await tester.pumpAndSettle();
  }

  final box = find.byKey(const ValueKey('dream-search'));
  bool focused(WidgetTester tester) => tester.widget<TextField>(box).focusNode!.hasFocus;

  testWidgets("Home's search box opens search with the cursor in the box", (tester) async {
    await openApp(tester);
    await tester.tap(find.text('เมื่อคืนคุณฝันเห็นอะไร...'));
    await tester.pumpAndSettle();
    expect(box, findsOneWidget);
    expect(focused(tester), isTrue, reason: 'one tap is enough to start typing');
  });

  testWidgets('the search tab on its own does not pop the keyboard up', (tester) async {
    await openApp(tester);
    await tester.tap(find.text('ทำนายฝัน').last);
    await tester.pumpAndSettle();
    expect(focused(tester), isFalse, reason: 'browsing the list should not be covered by the keyboard');
  });

  testWidgets('typing a lucky number finds the dream that gives it', (tester) async {
    await openApp(tester);
    await tester.tap(find.text('เมื่อคืนคุณฝันเห็นอะไร...'));
    await tester.pumpAndSettle();
    await tester.enterText(box, '46'); // กรงนก gives 46 and 86
    await tester.pumpAndSettle();
    expect(find.text('กรงนก'), findsOneWidget);
    expect(find.text('ไม่พบความฝันนี้ ลองคำอื่น'), findsNothing);
  });
}
