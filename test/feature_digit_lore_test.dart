// Feature 12 (หลักทำนายฝันตัวเลข ตามตำราโบราณ) shows the owner's book pages 137–142: intro, 28 rules, closing.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/data/digit_lore.dart';
import 'package:maha_dream/main.dart';

void main() {
  test('the data is source.md with only the fixes listed in REVIEW.md', () {
    var src = File('backend/content/incoming/feature-12-digit-lore/source.md')
        .readAsStringSync()
        .replaceAll('\r\n', '\n');
    for (final (from, to) in [
      ('สุนัข, เรือ หรือสัตว์ 4 เท้า', 'สุนัข, เสือ หรือสัตว์ 4 เท้า'),
      ('ตุ๊กแกนั้นคือเอาไม้ตรี', 'ตุ๊กแกนั้นถือเอาไม้ตรี'),
      ('มีลักษณะเป็นเลข ๗ ของไทย\n', 'มีลักษณะเป็นเลข ๗ ของไทย)\n'),
      ('เพราะปลาเข้าในลักษณะของเลข 8)', 'เพราะปลาเข้าในลักษณะของเลข 8'),
    ]) {
      expect(src, contains(from));
      src = src.replaceFirst(from, to);
    }
    expect(src,
        'หลักทำนายฝันตัวเลข (ตามตำราโบราณ)\n\n$loreIntro\n\n${loreEntries.map((e) => e.text).join('\n\n')}\n\n$loreClosing\n');
    expect(loreEntries, hasLength(28));
  });

  test('each badge is the number its rule leads with; bold part is what was dreamt', () {
    for (final e in loreEntries) {
      final lead = RegExp(r'เป็น(?: เลข|เลข)? ?“?(\d+|คี่)').firstMatch(e.text)!.group(1);
      expect(e.badge, lead, reason: e.text);
      if (e.seen != null) expect(e.text, startsWith('ถ้าฝันเห็น ${e.seen} '));
    }
  });

  testWidgets('the page shows the intro, every rule and the closing', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MahaDreamApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('ตำรา').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('หลักทำนายฝันตัวเลข'));
    await tester.pumpAndSettle();

    final list = find.byType(Scrollable).first;
    expect(find.text(loreIntro), findsOneWidget);
    for (final e in loreEntries) {
      await tester.scrollUntilVisible(find.text(e.text, findRichText: true), 300, scrollable: list);
    }
    await tester.scrollUntilVisible(find.text(loreClosing), 300, scrollable: list);
    for (final old in ['ไข่ · วงกลม', 'ฟักทอง · น้ำเต้า']) {
      expect(find.text(old, skipOffstage: false), findsNothing);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('number filters show matching rules and All restores every rule', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MahaDreamApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('ตำรา').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('หลักทำนายฝันตัวเลข'));
    await tester.pumpAndSettle();

    final oneRules = loreEntries.where((entry) => entry.badge == '1');
    final zeroRule = loreEntries.firstWhere((entry) => entry.badge == '0');
    await tester.tap(find.byKey(const ValueKey('lore-filter-1')));
    await tester.pumpAndSettle();
    for (final entry in oneRules) {
      expect(find.text(entry.text, findRichText: true), findsOneWidget);
    }
    expect(find.text(zeroRule.text, findRichText: true, skipOffstage: false), findsNothing);

    await tester.tap(find.byKey(const ValueKey('lore-filter-all')));
    await tester.pumpAndSettle();
    expect(find.text(oneRules.first.text, findRichText: true), findsOneWidget);
    expect(find.text(zeroRule.text, findRichText: true, skipOffstage: false), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test('the app shows the rules sorted by number, odd-number rules last, book order within a number', () {
    final sorted = loreEntriesByNumber;
    expect(sorted.toSet(), loreEntries.toSet(), reason: 'same 28 rules, none lost');
    final badges = sorted.map((e) => e.badge).toList();
    expect(badges.first, '0');
    expect(badges.sublist(badges.length - 2), ['คี่', 'คี่']);
    int key(String b) => int.tryParse(b) ?? 10;
    for (var i = 1; i < badges.length; i++) {
      expect(key(badges[i]), greaterThanOrEqualTo(key(badges[i - 1])));
    }
    final ones = loreEntries.where((e) => e.badge == '1').toList();
    expect(sorted.where((e) => e.badge == '1').toList(), ones);
  });
}
