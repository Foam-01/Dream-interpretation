import 'package:flutter/material.dart';

/// Placeholder design tokens. Replace with values from the Claude Design
/// file (`Dream App.dc.html`) once it can be read.
class AppColors {
  static const night = Color(0xFF1B1035);
  static const nightSoft = Color(0xFF2A1B4F);
  static const card = Color(0xFF33245E);
  static const gold = Color(0xFFE8C26A);
  static const goldSoft = Color(0xFFF5E2B0);
  static const text = Color(0xFFF4EEFF);
  static const textMuted = Color(0xFFB9AED6);
  static const danger = Color(0xFFFF8A80);
}

class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const radius = 16.0;
}

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.gold,
      brightness: Brightness.dark,
      primary: AppColors.gold,
      surface: AppColors.night,
    ),
  );
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.night,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.night,
      foregroundColor: AppColors.goldSoft,
      centerTitle: true,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: AppColors.card,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radius)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.nightSoft,
      hintStyle: const TextStyle(color: AppColors.textMuted),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        borderSide: BorderSide.none,
      ),
    ),
    textTheme: base.textTheme.apply(bodyColor: AppColors.text, displayColor: AppColors.text),
  );
}
