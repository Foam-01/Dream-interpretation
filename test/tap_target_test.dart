// Buttons have at least a 48 x 48 tap area (Android's minimum) while looking the same size.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/app_shell.dart';
import 'package:maha_dream/main.dart';
import 'package:maha_dream/widgets/ui.dart';

import 'pager_helper.dart';

void main() {
  Future<AppController> open(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MahaDreamApp());
    await tester.pumpAndSettle();
    return AppScope.of(tester.element(find.byType(Scaffold).first));
  }

  testWidgets('a range pill can be tapped just above the visible pill', (tester) async {
    final app = await open(tester);
    app.openFeat('5');
    await tester.pumpAndSettle();
    final pill = find.widgetWithText(SelectPill, '21–40');
    final area = tester.getRect(find.descendant(of: pill, matching: find.byType(MinTapTarget)));
    final visible = tester.getRect(find.descendant(of: find.byType(MinTapTarget), matching: find.text('21–40')).first);
    expect(area.height, greaterThanOrEqualTo(48));
    expect(area.width, greaterThanOrEqualTo(48));
    expect(visible.height, lessThan(area.height), reason: 'the pill itself is not taller');
    await tester.tapAt(Offset(area.center.dx, area.top + 2));
    await tester.pumpAndSettle();
    expect(tester.widget<SelectPill>(pill).selected, isTrue);
  });

  testWidgets('pager buttons have a 48 x 48 tap area around the 40 x 40 circle', (tester) async {
    final app = await open(tester);
    app.openFeat('6');
    await tester.pumpAndSettle();
    await scrollToPager(tester, 'ไปหน้าถัดไป');
    final next = find.bySemanticsLabel('ไปหน้าถัดไป');
    final area = tester.getRect(find.descendant(of: next, matching: find.byType(MinTapTarget)));
    expect(area.size, const Size(48, 48));
    await tester.tapAt(area.topLeft + const Offset(2, 2)); // outside the circle, inside the area
    await tester.pumpAndSettle();
    await expectPagerLabel(tester, 'หน้า 2 / 48');
  });
}
