// Golden of the search pager bar after jumping to the last page. (The default search golden shows the bar
// on page 1.)
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/app_shell.dart';
import 'package:maha_dream/data/design_data.dart';
import 'package:maha_dream/data/dream_images_k.dart';

import 'golden_test.dart' show expectGolden, pumpApp, tap;

/// Decodes every bundled dream picture before a capture (asset decoding is asynchronous).
Future<void> precacheAllDreamImages(WidgetTester tester) async {
  final context = tester.element(find.byType(Scaffold).first);
  await tester.runAsync(() async {
    for (final d in dreams) {
      final image = dreamImageFor(d.id);
      if (image != null) await precacheImage(AssetImage(image.url), context);
    }
  });
  await tester.pumpAndSettle();
}

Future<void> openSearch(WidgetTester tester) async {
  await pumpApp(tester);
  tester
      .element(find.byType(Scaffold).first)
      .getInheritedWidgetOfExactType<AppScope>()!
      .notifier!
      .goSearch(resetCat: true);
  await tester.pumpAndSettle();
  await precacheAllDreamImages(tester);
}

void main() {
  testWidgets('search: pager jumped to the last page', (tester) async {
    await openSearch(tester);
    await tap(tester, find.bySemanticsLabel('ไปหน้าสุดท้าย'));
    await expectGolden(tester, 'search_pager_last');
  });
}
