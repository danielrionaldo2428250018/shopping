import '../models/catalog_product.dart';

String formatIdr(int amount) {
  final digits = amount.abs().toString();
  final buf = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) {
      buf.write('.');
    }
    buf.write(digits[i]);
  }
  return 'Rp $buf';
}

/// Katalog diisi dari Realtime Database lewat [CatalogProvider].
const String kDefaultProductId = '';

final List<CatalogProduct> kCatalogProducts = [];

CatalogProduct? catalogProductById(String id) {
  if (id.isEmpty) return null;
  for (final p in kCatalogProducts) {
    if (p.id == id) return p;
  }
  return null;
}

CatalogProduct? catalogProductOrNull(String? id) {
  if (id == null || id.isEmpty) return null;
  return catalogProductById(id);
}

List<CatalogProduct> catalogSearch(String query) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return List<CatalogProduct>.from(kCatalogProducts);
  return kCatalogProducts
      .where(
        (p) =>
            p.title.toLowerCase().contains(q) ||
            p.category.toLowerCase().contains(q) ||
            p.sellerName.toLowerCase().contains(q),
      )
      .toList();
}

List<CatalogProduct> catalogByCategory(String categoryTitle) {
  final c = categoryTitle.toLowerCase();
  return kCatalogProducts
      .where((p) => p.category.toLowerCase() == c)
      .toList();
}

int catalogCountForCategory(String categoryTitle) {
  return catalogByCategory(categoryTitle).length;
}
