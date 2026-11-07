// Feature 6 (ภาพแป๊ะกงชี้โชค): the book's 1,000 pictures, real names and lucky numbers from source.txt,
// shown 21 a page like menu 5; one search box finds a dream word or either number across all 1,000.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/data/pae_numbers.dart';
import 'package:maha_dream/main.dart';
import 'package:maha_dream/widgets/ui.dart';

import 'pager_helper.dart';

void main() {
  test('1,000 pictures in book order, as in source.txt; lucky numbers are 3 digits and all different', () {
    final lines = File('backend/content/incoming/feature-06-pae-kong/source.txt')
        .readAsStringSync()
        .replaceAll('\r\n', '\n')
        .split('\n')
        .skip(1)
        .where((l) => l.isNotEmpty)
        .toList();
    expect([for (final p in paeNumbers) '${p.number}|${p.name}|${p.lucky}'], lines);
    expect(paeNumbers.map((p) => p.number), [for (var i = 1; i <= 1000; i++) i.toString().padLeft(3, '0')]);
    expect(paeNumbers.every((p) => RegExp(r'^\d{3}$').hasMatch(p.lucky)), isTrue);
    expect(paeNumbers.map((p) => p.lucky).toSet().length, 1000);
  });

  test('every picture is bundled', () {
    for (final p in paeNumbers) {
      expect(File(p.image).existsSync(), isTrue, reason: p.image);
    }
    expect(paeNumbers.first.image, 'assets/pae/0001.jpg');
    expect(paeNumbers.last.image, 'assets/pae/1000.jpg');
  });

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

  testWidgets('shows 21 a page; the pager turns pages and goes to the last', (tester) async {
    await openPae(tester);
    expect(find.text('ค้นหาสิ่งที่ฝัน เช่น ม้า หรือเลข'), findsOneWidget);
    expect(tester.widget<TextField>(box).keyboardType, isNot(TextInputType.number), reason: 'words need letters');
    expect(find.text('1000 ภาพ'), findsOneWidget);
    expect(find.text('มังกร'), findsOneWidget);
    expect(find.text('545'), findsOneWidget, reason: 'lucky number of 001');
    await expectPagerLabel(tester, 'หน้า 1 / 48');
    await tapPager(tester, 'ไปหน้าถัดไป');
    expect(find.text('ภาพ 022'), findsOneWidget, reason: 'back at the top of page 2');
    expect(find.text('มังกร'), findsNothing);
    await expectPagerLabel(tester, 'หน้า 2 / 48');
    await tapPager(tester, 'ไปหน้าสุดท้าย');
    await expectPagerLabel(tester, 'หน้า 48 / 48');
    expect(find.text('ภาพ 1000'), findsOneWidget);
  });

  testWidgets('a range chip filters to those 100, paged by 21; ทั้งหมด brings all back', (tester) async {
    await openPae(tester);
    final chip = find.widgetWithText(SelectPill, '301–400');
    await tester.ensureVisible(chip);
    await tester.pumpAndSettle();
    await tester.tap(chip);
    await tester.pumpAndSettle();
    expect(find.text('100 ภาพ'), findsOneWidget);
    expect(find.text('ภาพ 301'), findsOneWidget);
    expect(find.text('มังกร'), findsNothing);
    await expectPagerLabel(tester, 'หน้า 1 / 5');
    final all = find.widgetWithText(SelectPill, 'ทั้งหมด');
    await tester.scrollUntilVisible(
      all,
      -400,
      scrollable: find.byWidgetPredicate((w) => w is Scrollable && w.axisDirection == AxisDirection.down).first,
    );
    await tester.tap(all);
    await tester.pumpAndSettle();
    expect(find.text('1000 ภาพ'), findsOneWidget);
  });

  testWidgets('search by dream word, by lucky number or picture number; clear goes back', (tester) async {
    await openPae(tester);
    final horses = [
      for (final p in paeNumbers)
        if (p.name.contains('ม้า')) p,
    ];
    expect(horses, isNotEmpty);
    await tester.enterText(box, 'ม้า');
    await tester.pumpAndSettle();
    expect(find.text('พบ ${horses.length} ภาพ'), findsOneWidget);

    await tester.enterText(box, '545'); // lucky number of 001, and picture 545
    await tester.pumpAndSettle();
    expect(find.text('พบ 2 ภาพ'), findsOneWidget);
    expect(find.text('มังกร'), findsOneWidget);

    await tester.enterText(box, 'ไม่มีคำนี้');
    await tester.pumpAndSettle();
    expect(find.text('ไม่พบภาพที่ตรงกับ "ไม่มีคำนี้" ลองคำอื่นหรือพิมพ์เลข'), findsOneWidget);

    await tester.tap(find.byTooltip('ล้างคำค้นหา'));
    await tester.pumpAndSettle();
    expect(tester.widget<TextField>(box).controller!.text, isEmpty);
    expect(find.text('มังกร'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
