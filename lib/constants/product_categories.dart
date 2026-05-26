import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

/// Kategori katalog barang bekas / preloved (ID disimpan di RTDB).
abstract final class ProductCategories {
  ProductCategories._();

  static const List<String> ids = [
    'Electronics',
    'Accessories',
    'HomeLiving',
    'Books',
    'Collectibles',
    'SpareParts',
    'Metal',
  ];

  /// Empat kategori unggulan di beranda.
  static const List<String> homeFeaturedIds = [
    'Electronics',
    'HomeLiving',
    'SpareParts',
    'Metal',
  ];

  /// Pemetaan kategori lama → kategori baru.
  static String normalize(String raw) {
    final key = raw.trim();
    if (key.isEmpty) return key;
    switch (key.toLowerCase()) {
      case 'fashion':
        return 'Accessories';
      case 'furniture':
      case 'home':
        return 'HomeLiving';
      case 'gaming':
        return 'Electronics';
      case 'sports':
        return 'Accessories';
      default:
        for (final id in ids) {
          if (id.toLowerCase() == key.toLowerCase()) return id;
        }
        return key;
    }
  }

  static bool isKnown(String raw) =>
      ids.any((id) => id.toLowerCase() == normalize(raw).toLowerCase());

  static String label(AppLocalizations loc, String id) {
    switch (normalize(id)) {
      case 'Electronics':
        return loc.catElectronics;
      case 'Accessories':
        return loc.catAccessories;
      case 'HomeLiving':
        return loc.catHomeLiving;
      case 'Books':
        return loc.catBooks;
      case 'Collectibles':
        return loc.catCollectibles;
      case 'SpareParts':
        return loc.catSpareParts;
      case 'Metal':
        return loc.catMetal;
      default:
        return id;
    }
  }

  static IconData icon(String id) {
    switch (normalize(id)) {
      case 'Electronics':
        return Icons.smartphone_rounded;
      case 'Accessories':
        return Icons.watch_rounded;
      case 'HomeLiving':
        return Icons.kitchen_rounded;
      case 'Books':
        return Icons.menu_book_rounded;
      case 'Collectibles':
        return Icons.collections_rounded;
      case 'SpareParts':
        return Icons.settings_suggest_rounded;
      case 'Metal':
        return Icons.hardware_rounded;
      default:
        return Icons.category_rounded;
    }
  }
}
