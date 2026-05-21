import 'package:flutter/material.dart';

/// Identitas aplikasi: marketplace barang bekas / preloved.
abstract final class AppBranding {
  static const String appName = 'PreLoved';

  /// Tagline singkat (hero home, splash mental model).
  static const String tagline = 'Barang second, cerita baru';

  /// Subjudul di beranda.
  static const String homeSubtitle =
      'Temukan barang bekas berkualitas di sekitarmu';

  /// Warna utama — nuansa tembaga / kayu (bukan ungu retail baru).
  static const Color seedColor = Color(0xFFC47844);

  /// Aksen gelap untuk teks harga / CTA sekunder.
  static const Color accentDeep = Color(0xFF8B5A2B);

  static const Color scaffoldLight = Color(0xFFF7F3EE);
  static const Color scaffoldDark = Color(0xFF1C1917);

  /// Header beranda — gradasi hangat “thrift / vintage”.
  static const List<Color> heroGradient = [
    Color(0xFF6B5344),
    Color(0xFFA67C52),
    Color(0xFFD7CCC8),
  ];

  /// Login / daftar / hero penjual.
  static const List<Color> authGradient = [
    Color(0xFF7D5A3C),
    Color(0xFFA07855),
    Color(0xFFC9A882),
  ];

  /// Kartu promo di beranda.
  static const List<Color> promoGradient = [
    Color(0xFFB87333),
    Color(0xFFD4A574),
  ];

  static const String defaultDisplayName = 'Pengguna PreLoved';
}
