// UX additions from the blue-gold redesign: letter grid and switcher, remedy search,
// chant text size and copying a dream's numbers.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/data/nightmare_remedies.dart';
import 'package:maha_dream/main.dart';

Future<void> pumpApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const MahaDreamApp());
  await tester.pumpAndSettle();
}

Future<void> tap(WidgetTester tester, Finder f) async {
  await tester.ensureVisible(f);
  await tester.pumpAndSettle();
  await tester.tap(f);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('book menu shows letters as a grid and the switcher moves between letters', (tester) async {
    await pumpApp(tester);
    await tap(tester, find.text('ตำรา').last);
    expect(find.text('ทำนายฝันหมวด ก'), findsNothing, reason: 'no long list of 32 rows');
    await tap(tester, find.byTooltip('ทำนายฝันหมวด ข'));
    expect(find.text('ทำนายฝันหมวด ข'), findsOneWidget);
    await tap(tester, find.text('ค'));
    expect(find.text('ทำนายฝันหมวด ค'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('remedies show search box and all 18 from the book', (tester) async {
    await pumpApp(tester);
    await tap(tester, find.text('แก้ฝัน').last);
    await tap(tester, find.text('เคล็ดลับแก้ฝันร้าย'));
    expect(find.byKey(const ValueKey('remedy-search')), findsOneWidget);
    expect(find.text('ฝันว่า${remedies[0].dream}'), findsOneWidget);
  });

  testWidgets('chant text size grows and shrinks within limits', (tester) async {
    await pumpApp(tester);
    await tap(tester, find.text('แก้ฝัน').last);
    await tap(tester, find.text('บทสวดมนต์ความฝัน'));
    double size() => tester.widget<SelectableText>(find.byType(SelectableText).first).style!.fontSize!;
    expect(size(), 17);
    for (var i = 0; i < 5; i++) {
      await tap(tester, find.text('ก+'));
    }
    expect(size(), closeTo(17 * 1.5, .01));
    await tap(tester, find.text('ก-'));
    expect(size(), closeTo(17 * 1.3, .01));
  });

  testWidgets('dream detail has no save or copy-numbers button (owner decision)', (tester) async {
    await pumpApp(tester);
    await tap(tester, find.text('ทำนายฝัน').last);
    await tap(tester, find.text('กบ').first);
    expect(find.text('เลขนำโชคจากความฝัน'), findsOneWidget);
    expect(find.text('บันทึก'), findsNothing);
    expect(find.text('คัดลอกเลขทั้งหมด'), findsNothing);
  });
}
