// Regression (M0.3.3): Pae Kong hundred-range tabs must not clip their text at
// large text scale. Lives under test/golden/ so the real Noto Thai fonts are
// loaded (flutter_test_config.dart); the default test font is shorter than
// Thai glyphs and cannot reproduce the clipping.
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/main.dart';
import 'package:maha_dream/widgets/ui.dart';

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

/// The label is not clipped when the paragraph got at least its natural
/// height and lies fully inside its pill. A squeezed parent forces the
/// paragraph shorter than its intrinsic height, which is exactly the clipping
/// seen on the emulator; no exception is thrown in that case.
void expectLabelNotClipped(WidgetTester tester, String label) {
  final text = find.text(label);
  final paragraph = tester.renderObject<RenderParagraph>(text);
  final natural = paragraph.getMaxIntrinsicHeight(double.infinity);
  expect(paragraph.size.height, greaterThanOrEqualTo(natural - 0.5),
      reason: '"$label" got ${paragraph.size.height} of $natural px height');

  final pill = find.ancestor(of: text, matching: find.byType(SelectPill));
  final textRect = tester.getRect(text);
  final pillRect = tester.getRect(pill);
  expect(textRect.top, greaterThanOrEqualTo(pillRect.top - 0.5), reason: label);
  expect(textRect.bottom, lessThanOrEqualTo(pillRect.bottom + 0.5), reason: label);
}

void main() {
  for (final scale in [1.0, 1.3]) {
    testWidgets('pae kong range tabs are not clipped at text scale $scale', (tester) async {
      await openPaeKong(tester, scale);
      // Every range label rendered in the row (visible or scrolled-off).
      for (var i = 0; i < 10; i++) {
        final label = '${i}00–${i}99';
        expect(find.text(label), findsOneWidget, reason: label);
        expectLabelNotClipped(tester, label);
      }
      expect(tester.takeException(), isNull);
    });

    testWidgets('pae kong range selection still works at text scale $scale', (tester) async {
      await openPaeKong(tester, scale);
      expect(find.text('เลขกลับ 950'), findsOneWidget); // default 059
      final tab = find.widgetWithText(SelectPill, '200–299');
      await tester.ensureVisible(tab);
      await tester.pumpAndSettle();
      await tester.tap(tab);
      await tester.pumpAndSettle();
      expect(find.text('เลขกลับ 002'), findsOneWidget); // jumps to 200
      expect(find.text('200'), findsNWidgets(2)); // header + grid cell
      expect(tester.takeException(), isNull);
    });
  }
}
