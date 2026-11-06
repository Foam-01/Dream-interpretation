// Feature 5 (ทำนายฝันสัตว์ต่าง ๆ 100 ตัวเลข): 21 a page with a pager, and a search across all 100.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/data/animal_numbers.dart';
import 'package:maha_dream/main.dart';
import 'package:maha_dream/widgets/ui.dart';

import 'pager_helper.dart';

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

  testWidgets('shows 21 a page; the pager turns pages and goes to the last', (tester) async {
    await openAnimals(tester);
    expect(find.text('100 ตัว'), findsOneWidget);
    expect(find.text('มังกรบิน'), findsOneWidget);
    await expectPagerLabel(tester, 'หน้า 1 / 5');
    await tapPager(tester, 'ไปหน้าถัดไป');
    expect(find.text('นกกระทา'), findsOneWidget, reason: 'back at the top of page 2 (22–42)');
    expect(find.text('มังกรบิน'), findsNothing);
    await expectPagerLabel(tester, 'หน้า 2 / 5');
    await tapPager(tester, 'ไปหน้าสุดท้าย');
    await expectPagerLabel(tester, 'หน้า 5 / 5');
    expect(find.text('ผึ้ง'), findsWidgets, reason: '00 is the last one');
  });

  testWidgets('a range chip filters to those 20; ทั้งหมด brings all back', (tester) async {
    await openAnimals(tester);
    final chip = find.widgetWithText(SelectPill, '41–60');
    await tester.ensureVisible(chip);
    await tester.pumpAndSettle();
    await tester.tap(chip);
    await tester.pumpAndSettle();
    expect(find.text('20 ตัว'), findsOneWidget);
    expect(find.text('จิ้งหรีด'), findsOneWidget, reason: '42 is in the range');
    expect(find.text('มังกรบิน'), findsNothing);
    final all = find.widgetWithText(SelectPill, 'ทั้งหมด');
    await tester.ensureVisible(all);
    await tester.pumpAndSettle();
    await tester.tap(all);
    await tester.pumpAndSettle();
    expect(find.text('100 ตัว'), findsOneWidget);
    expect(find.text('มังกรบิน'), findsOneWidget);
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
    await expectPagerLabel(tester, 'หน้า 1 / 5');
    expect(tester.takeException(), isNull);
  });
}
