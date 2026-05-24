import 'package:flutter/material.dart';

/// Warna & gradien mengikuti terang/gelap (abu-abu gelap, bukan hitam pekat).
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.scaffold,
    required this.surface,
    required this.surfaceElevated,
    required this.headerGradient,
    required this.promoGradient,
    required this.profileHeaderGradient,
    required this.authGradient,
    required this.headerIconButtonBg,
    required this.headerPillBg,
    required this.headerPillText,
    required this.onHeader,
  });

  final Color scaffold;
  final Color surface;
  final Color surfaceElevated;
  final List<Color> headerGradient;
  final List<Color> promoGradient;
  final List<Color> profileHeaderGradient;
  final List<Color> authGradient;
  final Color headerIconButtonBg;
  final Color headerPillBg;
  final Color headerPillText;
  final Color onHeader;

  static const light = AppColors(
    scaffold: Color(0xFFF7F3EE),
    surface: Color(0xFFFFFFFF),
    surfaceElevated: Color(0xFFFFFFFF),
    headerGradient: [
      Color(0xFF6B5344),
      Color(0xFFA67C52),
      Color(0xFFD7CCC8),
    ],
    promoGradient: [
      Color(0xFFB87333),
      Color(0xFFD4A574),
    ],
    profileHeaderGradient: [
      Color(0xFF8E44AD),
      Color(0xFFD7B8F3),
      Color(0xFFF5F0FA),
    ],
    authGradient: [
      Color(0xFF7D5A3C),
      Color(0xFFA07855),
      Color(0xFFC9A882),
    ],
    headerIconButtonBg: Color(0x38FFFFFF),
    headerPillBg: Color(0xFF1A1A1A),
    headerPillText: Color(0xFFFFFFFF),
    onHeader: Color(0xFFFFFFFF),
  );

  static const dark = AppColors(
    scaffold: Color(0xFF2E2E32),
    surface: Color(0xFF3A3A3F),
    surfaceElevated: Color(0xFF45454B),
    headerGradient: [
      Color(0xFF4A443F),
      Color(0xFF5C564F),
      Color(0xFF6E6860),
    ],
    promoGradient: [
      Color(0xFF5A4D42),
      Color(0xFF6E5F52),
    ],
    profileHeaderGradient: [
      Color(0xFF4A3D52),
      Color(0xFF5E4F68),
      Color(0xFF6E6278),
    ],
    authGradient: [
      Color(0xFF4A4038),
      Color(0xFF5C5248),
      Color(0xFF6E6458),
    ],
    headerIconButtonBg: Color(0x38FFFFFF),
    headerPillBg: Color(0xFF1A1A1A),
    headerPillText: Color(0xFFFFFFFF),
    onHeader: Color(0xFFF2F2F2),
  );

  @override
  AppColors copyWith({
    Color? scaffold,
    Color? surface,
    Color? surfaceElevated,
    List<Color>? headerGradient,
    List<Color>? promoGradient,
    List<Color>? profileHeaderGradient,
    List<Color>? authGradient,
    Color? headerIconButtonBg,
    Color? headerPillBg,
    Color? headerPillText,
    Color? onHeader,
  }) {
    return AppColors(
      scaffold: scaffold ?? this.scaffold,
      surface: surface ?? this.surface,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      headerGradient: headerGradient ?? this.headerGradient,
      promoGradient: promoGradient ?? this.promoGradient,
      profileHeaderGradient:
          profileHeaderGradient ?? this.profileHeaderGradient,
      authGradient: authGradient ?? this.authGradient,
      headerIconButtonBg: headerIconButtonBg ?? this.headerIconButtonBg,
      headerPillBg: headerPillBg ?? this.headerPillBg,
      headerPillText: headerPillText ?? this.headerPillText,
      onHeader: onHeader ?? this.onHeader,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return t < 0.5 ? this : other;
  }
}

AppColors appColors(BuildContext context) =>
    Theme.of(context).extension<AppColors>() ?? AppColors.light;
