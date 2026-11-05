// The search box hint suggests real dreams: each example is a dream name in the bundled book and finds it.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/data/design_data.dart';
import 'package:maha_dream/main.dart';
import 'package:maha_dream/screens/search_screen.dart';

void main() {
  test('every hint example is a dream name in the book', () {
    final names = dreams.map((d) => d.name).toSet();
    for (final w in searchHintExamples) {
      expect(names, contains(w));
    }
  });

  testWidgets('the hint shows the examples, and typing one finds that dream', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MahaDreamApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('ทำนายฝัน').last);
    await tester.pumpAndSettle();

    expect(find.text('พิมพ์ เช่น งู ฟันหัก คนตาย'), findsOneWidget);
    for (final w in searchHintExamples) {
      await tester.enterText(find.byType(TextField), w);
      await tester.pumpAndSettle();
      expect(find.text(w), findsWidgets, reason: w); // the query and the matching dream
      expect(find.textContaining('ไม่พบ'), findsNothing, reason: w);
    }
  });
}
