// Feature 4 (การขอโชคจากความฝัน) shows the owner's book page: 6 numbered steps cut at its sentence breaks, then
// the closing sentence in the red box. Only typo fix: "ปประสิทธิ์" → "ประสิทธิ์".
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/data/design_data.dart';
import 'package:maha_dream/main.dart';

void main() {
  test('steps + closing are the source text, in order, nothing added', () {
    final src = File('backend/content/incoming/feature-04-luck-ritual/source.md')
        .readAsStringSync()
        .replaceAll('\r\n', '\n')
        .replaceFirst('ปประสิทธิ์', 'ประสิทธิ์');
    final body = src.split('\n\n').skip(1).join(' ');
    final ours = [for (final s in steps['4']!) s[1], prayers['4']![1]].join(' ');
    String squash(String s) => s.replaceAll(RegExp(r'\s+'), ' ').trim();
    expect(squash(ours), squash(body));
    for (final s in steps['4']!) {
      expect(s[1], contains(s[0].split(' ').first), reason: 'title "${s[0]}" comes from its own step');
    }
    expect(prayers['4']![0], isEmpty, reason: 'no invented label over the closing sentence');
  });

  testWidgets('the page shows the 6 steps and the closing, not the old sample', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MahaDreamApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('แก้ฝัน').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('การขอโชคจากความฝัน'));
    await tester.pumpAndSettle();

    final list = find.byType(Scrollable).first;
    for (final s in steps['4']!) {
      await tester.scrollUntilVisible(find.text(s[1]), 200, scrollable: list);
      expect(find.text(s[0]), findsOneWidget);
    }
    await tester.scrollUntilVisible(find.text(prayers['4']![1]), 200, scrollable: list);
    for (final old in ['ชำระกาย', 'คาถาขอเลขก่อนนอน', 'จดทันทีที่ตื่น']) {
      expect(find.text(old, skipOffstage: false), findsNothing);
    }
    expect(tester.takeException(), isNull);
  });
}
