// Feature 5 (ทำนายฝันสัตว์ต่าง ๆ 100 ตัวเลข): the book's pages of 9 (last page 10), and a search across all 100.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/data/animal_numbers.dart';
import 'package:maha_dream/main.dart';
import 'package:maha_dream/widgets/ui.dart';

void main() {
  test('100 numbers in book order, pairs go both ways, as in source.md', () {
    final src = File('backend/content/incoming/feature-05-animals/source.md')
        .readAsStringSync()
        .replaceAll('\r\n', '\n');
    expect(animalNumbers.map((a) => a.number), [for (var i = 1; i < 100; i++) i.toString().padLeft(2, '0'), '00']);
    final byNumber = {for (final a in animalNumbers) a.number: a};
    for (final a in animalNumbers) {
      expect(src, contains('${a.number} | ${a.name} | ${a.pair}\n'));
      expect(byNumber[a.pair]!.pair, a.number, reason: '${a.number} ↔ ${a.pair}');
    }
    expect([for (final p in animalPages) p.length], [...List.filled(10, 9), 10]);
  });

  test('every number has its bundled picture; 00 shares the bee of 48', () {
    for (final a in animalNumbers) {
      expect(a.image, 'assets/animals/${a.number}.jpg');
      expect(File(a.image!).existsSync(), isTrue, reason: a.image);
    }
    expect(File('assets/animals/00.jpg').readAsBytesSync(), File('assets/animals/48.jpg').readAsBytesSync());
  });

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

  testWidgets('opens on page 01–09; another page pill shows that page', (tester) async {
    await openAnimals(tester);
    expect(find.text('มังกรบิน'), findsOneWidget);
    expect(find.text('เสือดาว', skipOffstage: false), findsOneWidget);
    await tester.tap(find.widgetWithText(SelectPill, '28–36'));
    await tester.pumpAndSettle();
    expect(find.text('ค้างคาว'), findsOneWidget);
    expect(find.text('มังกรบิน'), findsNothing);
  });

  testWidgets('search by name finds both numbers; by number finds it; clear goes back', (tester) async {
    await openAnimals(tester);
    await tester.enterText(box, 'ช้าง');
    await tester.pumpAndSettle();
    expect(find.text('พบ 2 ตัว'), findsOneWidget); // 11 and 77
    await tester.enterText(box, '75');
    await tester.pumpAndSettle();
    expect(find.text('หนู'), findsWidgets);
    await tester.enterText(box, 'ไดโนเสาร์');
    await tester.pumpAndSettle();
    expect(find.text('ไม่พบสัตว์ที่ตรงกับ "ไดโนเสาร์"'), findsOneWidget);
    await tester.tap(find.byTooltip('ล้างคำค้นหา'));
    await tester.pumpAndSettle();
    expect(find.text('มังกรบิน'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
