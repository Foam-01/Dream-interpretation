// Feature 11 (บทสวดมนต์ความฝัน) shows the owner's book page verbatim: the intro, then three four-line stanzas.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/data/design_data.dart';
import 'package:maha_dream/data/dream_chant.dart';
import 'package:maha_dream/main.dart';

void main() {
  test('the data is the transcription in source.md', () {
    final src = File('backend/content/incoming/feature-11-dream-chant/source.md')
        .readAsStringSync()
        .replaceAll('\r\n', '\n');
    expect(src, 'บทสวดมนต์ความฝัน\n\n$chantIntro\n\n${chantStanzas.map((s) => s.join('\n')).join('\n\n')}\n');
    expect(chantStanzas, hasLength(3));
    expect(chantStanzas.map((s) => s.last.split(' ').first), ['พุทฺธานุภาเวน', 'ธมฺมานุภาเวน', 'สงฺฆานุภาเวน']);
    for (final s in chantStanzas) {
      expect(s.take(3), chantStanzas.first.take(3), reason: 'only the last line changes');
    }
  });

  test('feature 11 no longer carries the sample steps or blessing', () {
    expect(feats['11']!.type, FeatType.chant);
    expect(steps.containsKey('11'), isFalse);
    expect(prayers.containsKey('11'), isFalse);
  });

  testWidgets('the page shows the intro and all three stanzas', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MahaDreamApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('แก้ฝัน').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('บทสวดมนต์ความฝัน'));
    await tester.pumpAndSettle();

    final list = find.byType(Scrollable).first;
    expect(find.text(chantIntro), findsOneWidget);
    for (final s in chantStanzas) {
      await tester.scrollUntilVisible(find.text(s.join('\n')), 200, scrollable: list);
    }
    for (final old in ['บทสวดก่อนนอน', 'บทขอโชคลาภ', 'สวดจบ อธิษฐาน']) {
      expect(find.text(old, skipOffstage: false), findsNothing);
    }
    expect(tester.takeException(), isNull);
  });
}
