// Feature 6 (ภาพแป๊ะกงชี้โชค): one search box — a number selects it and shows its hundred block; a word lists
// every number whose picture name contains it (people know what they dreamt, not the number).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/data/formulas.dart';
import 'package:maha_dream/main.dart';
import 'package:maha_dream/widgets/ui.dart';

void main() {
  Future<void> openPae(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MahaDreamApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('ตำรา').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('ภาพแป๊ะกงชี้โชค'));
    await tester.pumpAndSettle();
  }

  final box = find.byKey(const ValueKey('pae-search'));
  bool pillSelected(WidgetTester tester, String label) =>
      tester.widget<SelectPill>(find.widgetWithText(SelectPill, label)).selected;

  testWidgets('typing 789 selects 789 in the 700–799 block', (tester) async {
    await openPae(tester);
    expect(find.text('ค้นหาคำ เช่น ม้า หรือเลข 000–999'), findsOneWidget);
    expect(tester.widget<TextField>(box).keyboardType, isNot(TextInputType.number), reason: 'words need letters');
    await tester.enterText(box, '789');
    await tester.pumpAndSettle();
    expect(find.text('เลขกลับ 987'), findsOneWidget);
    expect(pillSelected(tester, '700–799'), isTrue);
    expect(find.text('750'), findsOneWidget, reason: 'the grid shows the 700 block');
  });

  testWidgets('a short number means 000–099', (tester) async {
    await openPae(tester);
    await tester.enterText(box, '5');
    await tester.pumpAndSettle();
    expect(find.text('เลขกลับ 500'), findsOneWidget); // 005
    expect(pillSelected(tester, '000–099'), isTrue);
  });

  testWidgets('a word lists every number whose picture name contains it; tapping one selects it', (tester) async {
    await openPae(tester);
    final matches = [for (var i = 0; i < 1000; i++) if (paeOf(i).name.contains('ม้า')) paeOf(i).num];
    expect(matches, isNotEmpty);

    await tester.enterText(box, 'ม้า');
    await tester.pumpAndSettle();
    expect(find.text('พบ ${matches.length} เลข ที่มีคำว่า "ม้า"'), findsOneWidget);
    expect(find.text('000'), findsNothing, reason: 'ฤๅษี does not match');
    expect(pillSelected(tester, '000–099'), isFalse, reason: 'no block while listing words');

    await tester.tap(find.text(matches.first));
    await tester.pumpAndSettle();
    expect(find.text(matches.first), findsNWidgets(2), reason: 'grid cell and the big card');

    await tester.tap(find.byTooltip('ล้างคำค้นหา'));
    await tester.pumpAndSettle();
    expect(tester.widget<TextField>(box).controller!.text, isEmpty);
    expect(find.textContaining('ที่มีคำว่า'), findsNothing, reason: 'clearing ends the word search');

    await tester.enterText(box, 'ไม่มีคำนี้');
    await tester.pumpAndSettle();
    expect(find.text('ไม่พบภาพที่มีคำว่า "ไม่มีคำนี้"'), findsOneWidget);

    await tester.tap(find.widgetWithText(SelectPill, '000–099'));
    await tester.pumpAndSettle();
    expect(tester.widget<TextField>(box).controller!.text, isEmpty, reason: 'a block pill clears the word');
    expect(find.text('000'), findsNWidgets(2), reason: 'block 000–099 is back, 000 selected');
    expect(tester.takeException(), isNull);
  });
}
