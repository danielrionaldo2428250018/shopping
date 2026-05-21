/// Produk di katalog (Realtime Database / lokal).
class CatalogProduct {
  const CatalogProduct({
    required this.id,
    required this.title,
    required this.unitPrice,
    required this.imageUrl,
    required this.sellerName,
    required this.sellerInitials,
    required this.sellerRating,
    required this.locationLabel,
    required this.ratingValue,
    required this.reviewsCount,
    required this.soldLabel,
    required this.stock,
    required this.category,
    required this.condition,
    required this.description,
    required this.weightLabel,
  });

  final String id;
  final String title;
  final int unitPrice;
  final String imageUrl;
  final String sellerName;
  final String sellerInitials;
  final double sellerRating;
  final String locationLabel;
  final double ratingValue;
  final int reviewsCount;
  final String soldLabel;
  final int stock;
  final String category;
  final String condition;
  final String description;
  final String weightLabel;

  Map<String, dynamic> toRtdbMap() => {
        'id': id,
        'title': title,
        'unitPrice': unitPrice,
        'imageUrl': imageUrl,
        'sellerName': sellerName,
        'sellerInitials': sellerInitials,
        'sellerRating': sellerRating,
        'locationLabel': locationLabel,
        'ratingValue': ratingValue,
        'reviewsCount': reviewsCount,
        'soldLabel': soldLabel,
        'stock': stock,
        'category': category,
        'condition': condition,
        'description': description,
        'weightLabel': weightLabel,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      };

  static CatalogProduct fromRtdb(String key, Map<dynamic, dynamic> raw) {
    int asInt(dynamic v, [int fallback = 0]) {
      if (v is int) return v;
      if (v is num) return v.toInt();
      return fallback;
    }

    double asDouble(dynamic v, [double fallback = 0]) {
      if (v is double) return v;
      if (v is num) return v.toDouble();
      return fallback;
    }

    String asStr(dynamic v, [String fallback = '']) =>
        v?.toString() ?? fallback;

    final title = asStr(raw['title'], 'Produk');
    final seller = asStr(raw['sellerName'], 'Penjual');
    final initials = asStr(raw['sellerInitials']);
    final sellerInitials = initials.isNotEmpty
        ? initials
        : (seller.isNotEmpty ? seller.substring(0, 1).toUpperCase() : 'P');

    return CatalogProduct(
      id: asStr(raw['id'], key),
      title: title,
      unitPrice: asInt(raw['unitPrice']),
      imageUrl: asStr(
        raw['imageUrl'],
        'https://images.unsplash.com/photo-1560472354-b33ff0c44a43',
      ),
      sellerName: seller,
      sellerInitials: sellerInitials,
      sellerRating: asDouble(raw['sellerRating'], 4.8),
      locationLabel: asStr(raw['locationLabel'], 'Indonesia'),
      ratingValue: asDouble(raw['ratingValue'], 4.5),
      reviewsCount: asInt(raw['reviewsCount']),
      soldLabel: asStr(raw['soldLabel'], '0 terjual'),
      stock: asInt(raw['stock'], 1),
      category: asStr(raw['category'], 'Lainnya'),
      condition: asStr(raw['condition'], 'Bekas'),
      description: asStr(raw['description']),
      weightLabel: asStr(raw['weightLabel'], '-'),
    );
  }
}
