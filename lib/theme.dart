import 'package:flutter/material.dart';

/// Design tokens taken from Claude Design `Dream App.dc.html`.
class C {
  static const red = Color(0xFF8E1414);
  static const redBright = Color(0xFFB81E1E);
  static const redTile = Color(0xFFC42424);
  static const redDeep = Color(0xFF5A0E0E);
  static const gold = Color(0xFFF2C96B);
  static const goldDeep = Color(0xFFD4A23A);
  static const goldLight = Color(0xFFFFE3A3);
  static const goldBorder = Color(0xFFE4C27A);
  static const goldMuted = Color(0xFFC9A25A);
  static const tabInactive = Color(0xFFD9B88A);
  static const cream = Color(0xFFFBF4E8);
  static const card = Color(0xFFFFFDF7);
  static const input = Color(0xFFFFF8EA);
  static const tileLight = Color(0xFFFBECC8);
  static const divider = Color(0xFFF0E2C4);
  static const chipGrey = Color(0xFFE9DCC4);
  static const onRed = Color(0xFFFFF3D6);
  static const onRedMuted = Color(0xFFF7D9A8);
  static const ink = Color(0xFF3A1A10);
  static const inkBody = Color(0xFF4A2A1A);
  static const inkSoft = Color(0xFF5A3A2A);
  static const inkMuted = Color(0xFF7A5A4A);
  static const caption = Color(0xFF9A7A4A);
  static const placeholder = Color(0xFFA8796A);
  static const imgText = Color(0xFF8A6A3A);
  static const stripeA = Color(0xFFF3E2BF);
  static const stripeB = Color(0xFFEAD3A3);
}

TextStyle _font(String family, double size, FontWeight weight, Color color, double? letterSpacing, double? height) =>
    TextStyle(
      fontFamily: family,
      fontSize: size,
      fontWeight: weight,
      // Variable fonts: drive the wght axis explicitly.
      fontVariations: [FontVariation.weight(weight.value.toDouble())],
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );

TextStyle serif(double size, {FontWeight weight = FontWeight.w700, Color color = C.ink, double? letterSpacing, double? height}) =>
    _font('NotoSerifThai', size, weight, color, letterSpacing, height);

TextStyle sans(double size, {FontWeight weight = FontWeight.w400, Color color = C.ink, double? height}) =>
    _font('NotoSansThai', size, weight, color, null, height);

ThemeData buildTheme() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'NotoSansThai',
    colorScheme: ColorScheme.fromSeed(seedColor: C.red, primary: C.red, surface: C.cream),
    scaffoldBackgroundColor: C.cream,
    textSelectionTheme: const TextSelectionThemeData(cursorColor: C.redBright),
  );
}
