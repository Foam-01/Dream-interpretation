import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/main.dart';
import 'package:maha_dream/app_shell.dart';
import 'package:maha_dream/data/design_data.dart';
import 'package:maha_dream/data/formulas.dart';

void main() {
  test('dream numbers keep leading zeros', () {
    final d = dreams.firstWhere((d) => d.name == 'ฟันหลุด');
    expect(d.firstTwo, '08');
  });

  test('day formula matches design for Friday lock numbers', () {
    final r = dayData('7', 5); // Friday
    expect(r.tiles.first.label, 'บน');
    expect(r.rows.length, 3);
  });

  test('pae number is zero-padded and reversible', () {
    final p = paeOf(59);
    expect(p.num, '059');
    expect(p.rev, '950');
  });

  test('next draw date is 1st or 16th', () {
    expect(nextDrawDate(DateTime(2026, 10, 23)), DateTime(2026, 11, 1));
    expect(nextDrawDate(DateTime(2026, 10, 5)), DateTime(2026, 10, 16));
  });

  test('navigation: feature opens in its tab and back returns to menu', () {
    final c = AppController();
    c.openFeat('6');
    expect(c.tab, 'book');
    expect(c.page, isA<FeaturePage>());
    c.back();
    expect(c.page, isA<MenuPage>());
    c.back();
    expect(c.tab, 'home');
    expect(c.back(), isFalse);
  });

  test('every menu item points to an existing feature', () {
    for (final m in menus.values) {
      for (final item in m.items) {
        expect(feats.containsKey(item.key), isTrue, reason: item.key);
      }
    }
  });

  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MahaDreamApp());
  }

  testWidgets('home quick link opens Pae Kong feature', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('แป๊ะกง 1000'));
    await tester.pump();
    expect(find.text('ภาพแป๊ะกงชี้โชค'), findsOneWidget);
  });

  testWidgets('search -> result -> save toggle', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('เมื่อคืนคุณฝันเห็นอะไร...'));
    await tester.pump();
    expect(find.text('พบ 10 รายการ'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'งู');
    await tester.pump();
    expect(find.text('พบ 1 รายการ'), findsOneWidget);
    await tester.tap(find.text('ฝันเห็นงู'));
    await tester.pump();
    expect(find.text('เลขนำโชคจากความฝัน'), findsOneWidget);
    await tester.tap(find.text('บันทึก'));
    await tester.pump();
    expect(find.text('บันทึกแล้ว'), findsOneWidget);
  });

  testWidgets('every bottom tab and feature renders', (tester) async {
    await pumpApp(tester);
    for (final k in feats.keys) {
      await tester.tap(find.text(const {'lucky': 'เลขเด็ด', 'ritual': 'แก้ฝัน', 'book': 'ตำรา'}[tabOf(k)]!).last);
      await tester.pump();
      final item = menus[tabOf(k)]!.items.firstWhere((i) => i.key == k);
      await tester.tap(find.text(item.title));
      await tester.pump();
      expect(find.text(feats[k]!.title), findsOneWidget, reason: k);
      expect(tester.takeException(), isNull, reason: k);
    }
  });

  testWidgets('search shows empty state', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('ทำนายฝัน').last);
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'ไม่มีคำนี้');
    await tester.pump();
    expect(find.text('ไม่พบความฝันนี้ ลองคำอื่น'), findsOneWidget);
  });
}
