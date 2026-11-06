// Taps a pager button (menus 5 and 6, search) by its spoken label. The pager sits at the end of a lazy
// list, so scroll down until it is built and in view first.
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

final _pageList = find.byWidgetPredicate((w) => w is Scrollable && w.axisDirection == AxisDirection.down).first;

Future<void> scrollToPager(WidgetTester tester, String label) async {
  await tester.scrollUntilVisible(find.bySemanticsLabel(label), 400, scrollable: _pageList);
  await tester.pumpAndSettle();
}

Future<void> tapPager(WidgetTester tester, String label) async {
  await scrollToPager(tester, label);
  await tester.tap(find.bySemanticsLabel(label));
  await tester.pumpAndSettle();
}

/// Scrolls down to the pager and checks it reads [label] (e.g. หน้า 2 / 50).
Future<void> expectPagerLabel(WidgetTester tester, String label) async {
  await tester.scrollUntilVisible(find.text(label), 400, scrollable: _pageList);
  expect(find.text(label), findsOneWidget);
}
