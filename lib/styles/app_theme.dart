import 'package:flutter/material.dart';

import '../constants/app_branding.dart';
import 'app_colors_extension.dart';

abstract final class AppTheme {
  static ThemeData get light => _build(Brightness.light);

  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final extras = isDark ? AppColors.dark : AppColors.light;

    final scheme = ColorScheme.fromSeed(
      seedColor: AppBranding.seedColor,
      brightness: brightness,
      surface: extras.surface,
      onSurface: isDark ? const Color(0xFFE8E8EA) : const Color(0xFF1C1C1E),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: extras.scaffold,
      canvasColor: extras.scaffold,
      cardColor: extras.surface,
      primaryColor: scheme.primary,
      splashFactory: isDark ? NoSplash.splashFactory : InkSplash.splashFactory,
      dividerColor: isDark ? const Color(0xFF525258) : Colors.grey.shade300,
      extensions: [extras],
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: extras.surfaceElevated,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: extras.surfaceElevated,
        selectedItemColor: AppBranding.seedColor,
        unselectedItemColor: isDark ? const Color(0xFFB0B0B5) : Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF45454B) : Colors.white,
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
        color: extras.surface,
        elevation: isDark ? 0 : 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: extras.surfaceElevated,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: extras.surfaceElevated,
      ),
      listTileTheme: ListTileThemeData(
        tileColor: extras.surface,
        iconColor: scheme.onSurface,
        textColor: scheme.onSurface,
      ),
      iconTheme: IconThemeData(color: scheme.onSurface),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
        ),
      ),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: extras.surfaceElevated,
        contentTextStyle: TextStyle(color: scheme.onSurface),
      ),
      textTheme: ThemeData(brightness: brightness).textTheme.apply(
            bodyColor: scheme.onSurface,
            displayColor: scheme.onSurface,
          ),
    );
  }
}
