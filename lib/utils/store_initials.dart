import 'package:flutter/material.dart';

import '../constants/app_branding.dart';

/// Inisial toko dari huruf pertama tiap kata (maks. 3), mis. "My Lovely Antiques" → MLA.
String storeInitialsFromName(String storeName) {
  final words = storeName
      .trim()
      .split(RegExp(r'\s+'))
      .where((w) => w.isNotEmpty)
      .toList();
  if (words.isEmpty) return '?';
  final buffer = StringBuffer();
  for (final w in words.take(3)) {
    buffer.write(w[0].toUpperCase());
  }
  return buffer.toString();
}

/// Warna latar avatar toko — konsisten per nama toko.
Color storeAvatarBackgroundColor(String storeName) {
  final hash = storeName.trim().toLowerCase().hashCode.abs();
  final hues = <Color>[
    const Color(0xFFE8E0FF),
    const Color(0xFFDCEEFB),
    const Color(0xFFE3F5E8),
    const Color(0xFFFFF0D6),
    const Color(0xFFFCE4EC),
  ];
  return hues[hash % hues.length];
}

Color storeAvatarTextColor(String storeName) => AppBranding.seedColor;
