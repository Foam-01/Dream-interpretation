// Release layout check: every screen and the states its buttons lead to, on phones, foldables and tablets,
// at several text sizes. Fails on a layout exception AND on text that is silently cut off or squeezed
// (no exception is thrown for those). Repeated content is sampled (owner's call): a few dreams, the first
// and last pages of the animal and pae kong lists.
//
// Quick run (part of the normal suite): 3 sizes x 2 text sizes.
// Full run before a release:
//   flutter test test/golden/release_layout_test.dart --dart-define=FULL_LAYOUT=true
// Lives under test/golden/ so the real Thai fonts are measured.
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/app_shell.dart';
import 'package:maha_dream/data/design_data.dart';
import 'package:maha_dream/main.dart';
import 'package:maha_dream/widgets/ui.dart';

const _full = bool.fromEnvironment('FULL_LAYOUT');

const _allSizes = {
  'tiny phone 320x568': Size(320, 568),
  'small phone 360x640': Size(360, 640),
  'phone 393x852': Size(393, 852),
  'phone 412x915': Size(412, 915),
  'large phone 448x997': Size(448, 997),
  'foldable folded 360x780': Size(360, 780),
  'foldable open 673x841': Size(673, 841),
  'tablet 7in 600x960': Size(600, 960),
  'tablet 10in 800x1280': Size(800, 1280),
  'tablet landscape 1280x800': Size(1280, 800),
};
const _quickSizes = ['small phone 360x640', 'phone 412x915', 'tablet 10in 800x1280'];
const _allScales = [1.0, 1.3, 1.5, 1.75, 2.0];
const _quickScales = [1.0, 2.0];

/// Text that is cut off without an exception: squeezed shorter than it needs, truncated with a plain clip,
/// or sticking out of a clipping parent (a clip box, or a list across its scroll direction).
List<String> clippedText(WidgetTester tester) {
  final problems = <String>[];
  for (final e in find.byType(RichText, skipOffstage: false).evaluate()) {
    final p = e.renderObject;
    if (p is! RenderParagraph || !p.attached || !p.hasSize || p.size.isEmpty) continue;
    final text = p.text.toPlainText().replaceAll('\n', ' ');
    if (text.trim().isEmpty) continue;
    final label = text.length > 40 ? '${text.substring(0, 40)}…' : text;
    if (p.size.height + 0.5 < p.getMaxIntrinsicHeight(p.size.width)) problems.add('squeezed: "$label"');
    if (p.didExceedMaxLines && p.overflow == TextOverflow.clip) problems.add('cut off: "$label"');
    final box = MatrixUtils.transformRect(p.getTransformTo(null), Offset.zero & p.size);
    // Inside a scrolling area only the cross direction can clip (along the scroll it is just off screen).
    bool vertOnly = false, horizOnly = false;
    for (RenderObject? a = p.parent; a != null; a = a.parent) {
      if (a is! RenderBox || !a.hasSize) continue;
      final clip = MatrixUtils.transformRect(a.getTransformTo(null), Offset.zero & a.size);
      final scrollAxis = _scrollAxis(a);
      bool outV() => box.top < clip.top - 1 || box.bottom > clip.bottom + 1;
      bool outH() => box.left < clip.left - 1 || box.right > clip.right + 1;
      if (scrollAxis != null) {
        final out = scrollAxis == Axis.horizontal ? (!horizOnly && outV()) : (!vertOnly && outH());
        if (out) problems.add('outside its list: "$label"');
        if (scrollAxis == Axis.horizontal) {
          vertOnly = true;
        } else {
          horizOnly = true;
        }
        if (vertOnly && horizOnly) break;
        continue;
      }
      if (a is RenderClipRect || a is RenderClipRRect) {
        final out = (!horizOnly && outV()) || (!vertOnly && outH());
        if (out) problems.add('clipped: "$label"');
      }
    }
  }
  return problems;
}

/// The scroll direction when [box] is a scrolling area (ListView, GridView, SingleChildScrollView).
Axis? _scrollAxis(RenderBox box) {
  if (box is RenderViewportBase) return box.axis;
  if (box.runtimeType.toString() == '_RenderSingleChildViewport') {
    return (box as dynamic).axisDirection == AxisDirection.left || (box as dynamic).axisDirection == AxisDirection.right
        ? Axis.horizontal
        : Axis.vertical;
  }
  return null;
}

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

/// Sample dreams: longest name, longest prediction, one with ไม่ควรเสี่ยง, one with three-digit numbers.
List<String> _sampleDreams() {
  final byName = [...dreams]..sort((a, b) => b.name.length.compareTo(a.name.length));
  final byText = [...dreams]..sort((a, b) => b.meaning.length.compareTo(a.meaning.length));
  return {
    byName.first.id,
    byText.first.id,
    dreams.firstWhere((d) => d.numbers.isNone).id,
    dreams.firstWhere((d) => d.numbers.threeDigit.length >= 3).id,
  }.toList();
}

void main() {
  final sizes = _full ? _allSizes.keys.toList() : _quickSizes;
  final scales = _full ? _allScales : _quickScales;
  for (final name in sizes) {
    for (final scale in scales) {
      testWidgets('$name, text x$scale: every screen and state lays out, no text cut off', (tester) async {
        final app = await _open(tester, _allSizes[name]!, scale);
        final failures = <String>[];

        Future<void> check(String where) async {
          await tester.pumpAndSettle();
          // Look at the page from top to bottom.
          for (var i = 0; i < 12; i++) {
            final ex = tester.takeException();
            if (ex != null) failures.add('$where: ${ex.toString().split('\n').first}');
            for (final c in clippedText(tester)) {
              failures.add('$where: $c');
            }
            final lists = find.byType(Scrollable);
            if (lists.evaluate().isEmpty) break;
            final pos = tester.state<ScrollableState>(lists.first).position;
            if (pos.pixels >= pos.maxScrollExtent) break;
            await tester.drag(lists.first, const Offset(0, -500), warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }

        Future<void> tapAll(Finder f, String where) async {
          final n = f.evaluate().length;
          for (var i = 0; i < n && i < 12; i++) {
            final one = f.at(i);
            if (one.evaluate().isEmpty) break;
            await tester.ensureVisible(one);
            await tester.pumpAndSettle();
            await tester.tap(one, warnIfMissed: false);
            await check('$where, button ${i + 1}');
          }
        }

        Future<void> lastPage(String where) async {
          final last = find.bySemanticsLabel('ไปหน้าสุดท้าย');
          if (last.evaluate().isEmpty) return;
          await tester.ensureVisible(last);
          await tester.pumpAndSettle();
          await tester.tap(last, warnIfMissed: false);
          await check('$where, last page');
        }

        for (final tab in ['home', 'dream', 'lucky', 'ritual', 'book']) {
          app.goTab(tab);
          await check('tab $tab');
        }
        // Search: results by word and by number, nothing found, one letter, last page.
        app.goTab('dream');
        for (final q in ['งู', '46', 'ไม่มีคำนี้เลย']) {
          app.setQuery(q);
          await check('search "$q"');
        }
        app.setQuery('');
        await check('search all');
        await lastPage('search all');

        for (final k in feats.keys) {
          app.openFeat(k);
          await check('feature $k');
          if (int.parse(k) <= 12) {
            await tapAll(find.byType(SelectPill), 'feature $k');
            await lastPage('feature $k');
          }
        }
        for (final id in _sampleDreams()) {
          app.openDream(id);
          await check('dream $id');
        }

        expect(failures.toSet().toList(), isEmpty, reason: '$name x$scale');
      });
    }
  }
}
