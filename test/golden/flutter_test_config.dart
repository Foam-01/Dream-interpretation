// Applies only to tests under test/golden/: loads the real fonts the app uses
// so golden images render Thai text instead of the default test font.
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Families must match `fontFamily` in lib/theme.dart and pubspec.yaml.
const appFonts = {'NotoSansThai': 'assets/fonts/NotoSansThai.ttf', 'NotoSerifThai': 'assets/fonts/NotoSerifThai.ttf'};

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();

  for (final MapEntry(key: family, value: asset) in appFonts.entries) {
    final data = await rootBundle.load(asset);
    if (data.lengthInBytes == 0) throw StateError('Font asset is empty: $asset');
    await (FontLoader(family)..addFont(Future.value(data))).load();
  }

  // Icons.star / star_border on the detail page need the Material icon font,
  // which flutter_test does not load by default. Taken from the Flutter SDK.
  // flutter_tester lives under <sdk>/bin/cache/artifacts/engine/<platform>/.
  File? icons;
  for (var dir = File(Platform.resolvedExecutable).parent; dir.parent.path != dir.path; dir = dir.parent) {
    final f = File('${dir.path}/material_fonts/materialicons-regular.otf');
    if (f.existsSync()) {
      icons = f;
      break;
    }
  }
  if (icons == null) throw StateError('Material icons font not found near ${Platform.resolvedExecutable}');
  final iconBytes = icons.readAsBytesSync();
  await (FontLoader('MaterialIcons')..addFont(Future.value(ByteData.sublistView(iconBytes)))).load();

  await testMain();
}
