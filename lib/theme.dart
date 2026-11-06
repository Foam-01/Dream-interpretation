import 'package:flutter/material.dart';

/// Design tokens: the blue-gold theme from the "Dream App Blue Gold" canvas (artboard สีและตัวอักษร).
/// Names describe the role, not the hue, so a palette change stays inside this class.
class C {
  // Fills
  static const bg = Color(0xFF050E2E);
  static const surface = Color(0xFF0C1F57);
  static const input = Color(0xFF0A1B4D);
  static const brand = Color(0xFF0B2A7A);
  static const brandBright = Color(0xFF1A4BC2);
  static const brandTile = Color(0xFF1A4BC2);
  static const headerEnd = Color(0xFF081642);
  static const navBar = Color(0xFF040B26);
  static const highlight = Color(0xFF173275);
  static const muted = Color(0xFF1A2A5E);
  static const divider = Color(0xFF1E2F66);
  static const shadow = Color(0x66000000);

  // Gold
  static const gold = Color(0xFFE8C46A);
  static const goldDeep = Color(0xFFD9A93F);
  static const goldLight = Color(0xFFF6DE9A);
  static const goldBorder = Color(0x8CE8C46A);
  static const goldMuted = Color(0xFFC9A25A);

  // Text
  static const text = Color(0xFFFFFFFF);
  static const textBody = Color(0xFFEAF0FF);
  static const textSoft = Color(0xFFC9D6FF);
  static const textMuted = Color(0xFFC9D6FF);
  static const caption = Color(0xFFAEBBE3);
  static const placeholder = Color(0xFF8FA3D6);
  static const accent = Color(0xFFF6DE9A);
  static const number = Color(0xFFF6DE9A);
  static const onGold = Color(0xFF061440);
  static const onBrand = Color(0xFFEAF0FF);
  static const onBrandMuted = Color(0xFFC9D6FF);
  static const tabInactive = Color(0xFFAEBBE3);

  // Picture placeholders keep a paper tone: the line drawings are made for a light ground.
  static const imgText = Color(0xFF6B5A35);
  static const stripeA = Color(0xFFF4EAD2);
  static const stripeB = Color(0xFFEADCB8);
}

/// Fill for the highlighted number tiles (lock top row, digit boxes, lead numbers).
const goldGradient = LinearGradient(
    begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [C.goldLight, C.goldDeep]);

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

TextStyle serif(double size, {FontWeight weight = FontWeight.w700, Color color = C.text, double? letterSpacing, double? height}) =>
    _font('NotoSerifThai', size, weight, color, letterSpacing, height);

TextStyle sans(double size, {FontWeight weight = FontWeight.w400, Color color = C.text, double? height}) =>
    _font('NotoSansThai', size, weight, color, null, height);

ThemeData buildTheme() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'NotoSansThai',
    colorScheme: ColorScheme.fromSeed(seedColor: C.brand, primary: C.brand, surface: C.bg, brightness: Brightness.dark),
    scaffoldBackgroundColor: C.bg,
    textSelectionTheme: const TextSelectionThemeData(cursorColor: C.gold),
  );
}
