import 'package:flutter/material.dart';

import '../constants/app_branding.dart';

abstract final class AppTheme {
  static ThemeData get light => _build(Brightness.light);

  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: AppBranding.seedColor,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor:
          isDark ? AppBranding.scaffoldDark : AppBranding.scaffoldLight,
      cardColor: isDark ? const Color(0xFF2A2A2E) : Colors.white,
      dividerColor: isDark ? Colors.white24 : Colors.grey.shade300,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: isDark ? const Color(0xFF2A2A2E) : Colors.white,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? const Color(0xFF2A2A2E) : Colors.white,
        selectedItemColor: AppBranding.seedColor,
        unselectedItemColor: isDark ? Colors.white60 : Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF3A3A3E) : Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
      cardTheme: CardThemeData(
        color: isDark ? const Color(0xFF2A2A2E) : Colors.white,
        elevation: isDark ? 0 : 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: isDark ? const Color(0xFF2A2A2E) : Colors.white,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isDark ? const Color(0xFF2A2A2E) : Colors.white,
      ),
    );
  }
}
