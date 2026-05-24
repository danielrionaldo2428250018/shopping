import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Praktik green computing: hemat RAM, CPU, dan jaringan di perangkat entry-level.
abstract final class GreenComputing {
  static const prefsKeyEco = 'settings_eco_mode_v1';

  /// Batas item di beranda (kurangi widget + decode gambar).
  static int homeProductCap({
    required bool ecoMode,
    required bool compactScreen,
  }) {
    if (ecoMode) return compactScreen ? 6 : 10;
    return compactScreen ? 10 : 16;
  }

  /// Jeda sebelum langganan katalog RTDB (startup lebih ringan).
  static Duration catalogSubscribeDelay(bool ecoMode) =>
      Duration(milliseconds: ecoMode ? 450 : 200);

  /// Lebar decode bitmap di memori (px) — proporsional ukuran di layar.
  static int memCacheWidth(BuildContext context, double logicalWidth) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final px = (logicalWidth * dpr).round();
    return px.clamp(96, 640);
  }

  static void applyStartupTuning({bool ecoMode = false}) {
    final cache = PaintingBinding.instance.imageCache;
    cache.maximumSize = ecoMode ? 48 : 64;
    cache.maximumSizeBytes = ecoMode ? 16 << 20 : 24 << 20;
  }

  static void tuneImageCacheForEco(bool ecoMode) {
    final cache = PaintingBinding.instance.imageCache;
    cache.maximumSize = ecoMode ? 48 : 64;
    cache.maximumSizeBytes = ecoMode ? 16 << 20 : 24 << 20;
    if (ecoMode) {
      cache.clear();
      cache.clearLiveImages();
    }
  }

  /// Default aktif — green computing untuk HP RAM kecil (bisa dimatikan di Settings).
  static bool readEcoFromPrefs(SharedPreferences prefs) =>
      prefs.getBool(prefsKeyEco) ?? true;

  static Duration providerNotifyDebounce(bool ecoMode) =>
      Duration(milliseconds: ecoMode ? 220 : 90);

  static double scrollCacheExtent(bool ecoMode) => ecoMode ? 180 : 420;

  static int dataImageCacheMax(bool ecoMode) => ecoMode ? 14 : 32;

  /// Jeda langganan chat/Firestore setelah beranda tampil.
  static Duration secondaryServicesDelay(bool ecoMode) =>
      Duration(milliseconds: ecoMode ? 900 : 450);
}
