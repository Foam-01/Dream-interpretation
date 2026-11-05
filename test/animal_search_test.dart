// Feature 5 (ทำนายฝันจากสัตว์): the search box filters the table by animal name or number.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/main.dart';

void main() {
  Future<void> openAnimals(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MahaDreamApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('ตำรา').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('ตารางชื่อสัตว์'));
    await tester.pumpAndSettle();
  }

  final box = find.byKey(const ValueKey('animal-search'));

  testWidgets('a name keeps only matching animals; clearing brings all back', (tester) async {
    await openAnimals(tester);
    expect(find.text('ค้นหาชื่อสัตว์ เช่น งู หรือเลข'), findsOneWidget);
    await tester.enterText(box, 'งู');
    await tester.pumpAndSettle();
    expect(find.text('งู'), findsNWidgets(2), reason: 'the query and the row');
    expect(find.text('ช้าง'), findsNothing);

    await tester.tap(find.byTooltip('ล้างคำค้นหา'));
    await tester.pumpAndSettle();
    expect(find.text('ช้าง'), findsOneWidget);
  });

  testWidgets('a number finds the animals with it; no match says so', (tester) async {
    await openAnimals(tester);
    await tester.enterText(box, '9');
    await tester.pumpAndSettle();
    expect(find.text('ช้าง'), findsOneWidget); // lead 9
    expect(find.text('เสือ'), findsNothing);

    await tester.enterText(box, 'ไดโนเสาร์');
    await tester.pumpAndSettle();
    expect(find.text('ไม่พบสัตว์ที่ตรงกับ "ไดโนเสาร์"'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
