// Responsive check (F04): every tab, feature and a dream detail at phone, tablet and foldable sizes,
// portrait and landscape, with normal, large and very large text — no overflow or layout error anywhere.
// Lives under test/golden/ so the real Thai fonts are measured (the default test font is far wider).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/app_shell.dart';
import 'package:maha_dream/data/design_data.dart';
import 'package:maha_dream/main.dart';

const _sizes = {
  'small phone 320x640': Size(320, 640),
  'phone 412x915': Size(412, 915),
  'tablet 7in 600x960': Size(600, 960),
  'tablet 10in 800x1280': Size(800, 1280),
  'tablet landscape 1280x800': Size(1280, 800),
  'foldable open 673x841': Size(673, 841),
};

Future<AppController> _open(WidgetTester tester, Size size, double scale) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = scale;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearAllTestValues);
  await tester.pumpWidget(const MahaDreamApp());
  await tester.pumpAndSettle();
  return AppScope.of(tester.element(find.byType(Scaffold).first));
}

Future<void> _scrollAll(WidgetTester tester) async {
  final lists = find.byType(Scrollable);
  if (lists.evaluate().isEmpty) return;
  for (var i = 0; i < 10; i++) {
    await tester.drag(lists.first, const Offset(0, -500), warnIfMissed: false);
    await tester.pump();
  }
}

void main() {
  for (final MapEntry(key: name, value: size) in _sizes.entries) {
    for (final scale in [1.0, 1.3, 2.0]) {
      testWidgets('$name, text x$scale: every screen lays out', (tester) async {
        final app = await _open(tester, size, scale);
        Future<void> check(String where) async {
          await tester.pumpAndSettle();
          await _scrollAll(tester);
          expect(tester.takeException(), isNull, reason: where);
        }

        for (final tab in ['home', 'dream', 'lucky', 'ritual', 'book']) {
          app.goTab(tab);
          await check('tab $tab');
        }
        for (final k in feats.keys) {
          app.openFeat(k);
          await check('feature $k');
        }
        for (final id in ['k-frog', 'k-jaw']) {
          app.openDream(id);
          await check('dream $id');
        }
      });
    }
  }

  testWidgets('pages stay phone-width and centred on a wide screen', (tester) async {
    await _open(tester, const Size(1280, 800), 1.0);
    final field = tester.getRect(find.text('เมื่อคืนคุณฝันเห็นอะไร...'));
    expect(field.left, greaterThan((1280 - maxContentWidth) / 2 - 1));
    expect(field.right, lessThan((1280 + maxContentWidth) / 2 + 1));
  });

  testWidgets('the tab bar hides while the keyboard is up, leaving room for results', (tester) async {
    final app = await _open(tester, const Size(360, 640), 1.0);
    app.goTab('dream');
    await tester.pumpAndSettle();
    expect(find.text('ตำรา'), findsWidgets);
    tester.view.viewInsets = const FakeViewPadding(bottom: 280);
    await tester.pumpAndSettle();
    expect(find.text('ตำรา'), findsNothing, reason: 'tab bar hidden');
    expect(find.text('กบ').hitTestable(), findsOneWidget, reason: 'first result still visible above the keyboard');
    tester.view.resetViewInsets();
    await tester.pumpAndSettle();
    expect(find.text('ตำรา'), findsWidgets, reason: 'tab bar back');
  });

  testWidgets('search category chips grow with very large text instead of cutting the labels', (tester) async {
    final app = await _open(tester, const Size(360, 640), 2.0);
    app.goTab('dream');
    await tester.pumpAndSettle();
    final label = find.text('ทั้งหมด').first;
    final chip = tester.getRect(find.ancestor(of: label, matching: find.byType(ListView)).first);
    expect(tester.getRect(label).bottom, lessThanOrEqualTo(chip.bottom + 0.5));
  });

  test('phones stay upright; tablets and foldables turn', () {
    expect(keepsPortrait(const Size(360, 640)), isTrue);
    expect(keepsPortrait(const Size(915, 412)), isTrue, reason: 'a phone held sideways is still a phone');
    expect(keepsPortrait(const Size(600, 960)), isFalse);
    expect(keepsPortrait(const Size(673, 841)), isFalse);
  });
}
