// Every screen of the blue-gold design on a small phone (320×640) and a tablet, at default and
// enlarged text: no RenderFlex overflow or other layout exception anywhere.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/app_shell.dart';
import 'package:maha_dream/data/design_data.dart';
import 'package:maha_dream/main.dart';

const _sizes = {'small phone': Size(320, 640), 'tablet': Size(820, 1180)};
const _scales = [1.0, 1.3];

Future<void> _pump(WidgetTester tester, Size size, double scale) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = scale;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  await tester.pumpWidget(const MahaDreamApp());
  await tester.pumpAndSettle();
  // Opening screen (if shown) fades by itself.
  await tester.pumpAndSettle(const Duration(seconds: 3));
}

AppController _app(WidgetTester tester) =>
    AppScope.of(tester.element(find.byType(Scaffold).first));

/// Scrolls the screen's main list to the end so lazily built rows are laid out too.
Future<void> _scrollAll(WidgetTester tester) async {
  final lists = find.byType(Scrollable);
  if (lists.evaluate().isEmpty) return;
  for (var i = 0; i < 8; i++) {
    await tester.drag(lists.first, const Offset(0, -600), warnIfMissed: false);
    await tester.pump();
  }
}

void main() {
  for (final MapEntry(key: name, value: size) in _sizes.entries) {
    for (final scale in _scales) {
      testWidgets('$name, text ×$scale: every tab, menu and feature lays out', (tester) async {
        await _pump(tester, size, scale);
        final app = _app(tester);
        for (final tab in ['home', 'dream', 'lucky', 'ritual', 'book']) {
          app.goTab(tab);
          await tester.pumpAndSettle();
          await _scrollAll(tester);
          expect(tester.takeException(), isNull, reason: 'tab $tab');
        }
        for (final k in feats.keys) {
          app.openFeat(k);
          await tester.pumpAndSettle();
          await _scrollAll(tester);
          expect(tester.takeException(), isNull, reason: 'feature $k');
        }
        // Dream detail with numbers (กบ) and with "ไม่ควรเสี่ยง" (กราม), opened from search.
        for (final name in ['กบ', 'กราม']) {
          app.goTab('dream');
          await tester.pumpAndSettle();
          final row = find.text(name).first;
          await tester.ensureVisible(row);
          await tester.pumpAndSettle();
          await tester.tap(row);
          await tester.pumpAndSettle();
          expect(find.text('เลขนำโชคจากความฝัน'), findsOneWidget, reason: name);
          await _scrollAll(tester);
          expect(tester.takeException(), isNull, reason: 'dream $name');
        }
      });
    }
  }
}
