// Dream pictures (1200 x 670) are decoded at the size they are shown, not at full size.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/app_shell.dart';
import 'package:maha_dream/main.dart';
import 'package:maha_dream/widgets/ui.dart';

void main() {
  test('decode width covers the box at the picture ratio and screen density', () {
    // 64 x 64 thumbnail, density 3: the height needs 64 * 1.79 * 3 ≈ 344 px.
    expect(DreamImageView.decodeWidth(BoxConstraints.tight(const Size(64, 64)), 3), 344);
    // Full-width 360 x 200 on density 2: the width needs 720 px (height would need 716).
    expect(DreamImageView.decodeWidth(BoxConstraints.tight(const Size(360, 200)), 2), 720);
    // Would need the whole picture or more: decode at full size.
    expect(DreamImageView.decodeWidth(BoxConstraints.tight(const Size(800, 450)), 2), isNull);
    expect(DreamImageView.decodeWidth(const BoxConstraints(), 2), isNull);
  });

  testWidgets('search thumbnails are decoded small, the detail picture larger', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MahaDreamApp());
    await tester.pumpAndSettle();
    final app = AppScope.of(tester.element(find.byType(Scaffold).first));
    app.goTab('dream');
    await tester.pumpAndSettle();
    int? width(Finder f) => (tester.widget<Image>(f).image as ResizeImage).width;
    final thumb = find.descendant(of: find.byType(DreamImageView).first, matching: find.byType(Image));
    expect(width(thumb), lessThan(400));
    app.openDream('k-frog');
    await tester.pumpAndSettle();
    final big = find.descendant(of: find.byType(DreamImageView).first, matching: find.byType(Image));
    expect(width(big), greaterThan(700), reason: 'the detail picture stays sharp');
  });
}
