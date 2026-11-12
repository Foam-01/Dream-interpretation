// Feature 3 (เคล็ดลับแก้ฝันร้าย) shows the owner's text "เคล็ดแก้ฝันร้าย": 18 numbered remedies, the closing,
// then the intro folded under "อ่านเพิ่มเติม".
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/data/design_data.dart';
import 'package:maha_dream/data/nightmare_remedies.dart';
import 'package:maha_dream/main.dart';

void main() {
  test('the data is the owner text: 7 intro paragraphs, 18 remedies, a closing', () {
    expect(remedyIntro, hasLength(7));
    expect(remedies, hasLength(18));
    for (final r in remedies) {
      expect([r.dream, r.omen, r.cure], everyElement(isNotEmpty));
      expect(r.cure, anyOf(startsWith('ต้องไป'), startsWith('ต้องนอน'), startsWith('ต้องแก้')), reason: r.dream);
    }
    expect(remedies.map((r) => r.dream).toSet(), hasLength(18), reason: 'no remedy twice');
    expect(remedyClosing, startsWith('ที่ยกกล่าวนี้'));
    // Copy noise from the pasted page is not content.
    final all = [
      ...remedyIntro,
      for (final r in remedies) ...[r.dream, r.omen, r.cure],
      remedyClosing,
    ].join('\n');
    expect(all, isNot(contains('แปะกงชี้โชค')));
    expect(RegExp(r'[0-9a-f]{8}-[0-9a-f]{4}').hasMatch(all), isFalse);
  });

  test('feature 3 no longer carries the placeholder steps or chant', () {
    expect(feats['3']!.type, FeatType.remedies);
    expect(steps.containsKey('3'), isFalse);
    expect(prayers.containsKey('3'), isFalse);
  });

  testWidgets('the page shows the intro, every remedy and the closing', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MahaDreamApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('แก้ฝัน').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('เคล็ดลับแก้ฝันร้าย'));
    await tester.pumpAndSettle();

    final list = find.byType(Scrollable).first;
    // The list comes first; the long intro stays folded until asked for.
    expect(find.byKey(const ValueKey('remedy-search')), findsOneWidget, reason: 'design: search in the header');
    expect(find.text('ฝันว่า${remedies.first.dream}'), findsOneWidget);
    expect(find.text(remedyIntro.first, skipOffstage: false), findsNothing);
    for (final r in remedies) {
      await tester.scrollUntilVisible(find.text('ฝันว่า${r.dream}'), 400, scrollable: list);
      expect(find.text(r.omen), findsWidgets);
      expect(find.text(r.cure), findsOneWidget);
    }
    await tester.scrollUntilVisible(find.text(remedyClosing), 400, scrollable: list);
    await tester.scrollUntilVisible(find.text('อ่านเพิ่มเติม').hitTestable(), 200, scrollable: list);
    await tester.tap(find.text('อ่านเพิ่มเติม'));
    await tester.pumpAndSettle();
    for (final p in remedyIntro) {
      expect(find.text(p, skipOffstage: false), findsOneWidget);
    }
    expect(find.text('ตั้งสติเมื่อตื่น', skipOffstage: false), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
