// Regression (M0.3.3): Pae Kong range chips and pager (21 a page) must not clip their labels at
// large text scale. Lives under test/golden/ so the real Noto Thai fonts are
// loaded (flutter_test_config.dart); the default test font is shorter than
// Thai glyphs and cannot reproduce the clipping.
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/data/pae_numbers.dart';
import 'package:maha_dream/main.dart';

import '../pager_helper.dart';

Future<void> openPaeKong(WidgetTester tester, double textScale) async {
  tester.view.physicalSize = const Size(390, 844) * 2;
  tester.view.devicePixelRatio = 2;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearAllTestValues);
  await tester.pumpWidget(const MahaDreamApp());
  await tester.pumpAndSettle();
  await tester.tap(find.text('ตำรา').last);
  await tester.pumpAndSettle();
  await tester.tap(find.text('ภาพแป๊ะกงชี้โชค'));
  await tester.pumpAndSettle();
}

void main() {
  for (final scale in [1.0, 1.3]) {
    testWidgets('pae kong pager label is not clipped and turns pages at text scale $scale', (tester) async {
      await openPaeKong(tester, scale);
      expect(find.text(paeNumbers.first.name), findsOneWidget);
      // Range chips: every label gets its full height (the original M0.3.3 clipping bug).
      for (final label in ['ทั้งหมด', for (var i = 0; i < 10; i++) '${paeNumbers[i * 100].number}–${paeNumbers[i * 100 + 99].number}']) {
        final p = tester.renderObject<RenderParagraph>(find.text(label));
        expect(p.size.height, greaterThanOrEqualTo(p.getMaxIntrinsicHeight(double.infinity) - 0.5), reason: label);
      }
      final next = find.bySemanticsLabel('ไปหน้าถัดไป');
      await scrollToPager(tester, 'ไปหน้าถัดไป');
      final label = find.text('หน้า 1 / 48');
      final paragraph = tester.renderObject<RenderParagraph>(label);
      expect(paragraph.size.height, greaterThanOrEqualTo(paragraph.getMaxIntrinsicHeight(double.infinity) - 0.5));
      await tester.tap(next);
      await tester.pumpAndSettle();
      expect(find.text(paeNumbers[21].lucky), findsOneWidget, reason: 'page 2 starts in view');
      await expectPagerLabel(tester, 'หน้า 2 / 48');
      expect(tester.takeException(), isNull);
    });
  }
}
