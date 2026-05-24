/// Produk di katalog (Realtime Database / lokal).
class CatalogProduct {
  const CatalogProduct({
    required this.id,
    required this.title,
    required this.unitPrice,
    required this.imageUrl,
    required this.sellerName,
    this.sellerUid = '',
    required this.sellerInitials,
    required this.sellerRating,
    required this.locationLabel,
    required this.ratingValue,
    required this.reviewsCount,
    required this.soldCount,
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
  final String sellerUid;
  final String sellerInitials;
  final double sellerRating;
  final String locationLabel;
  final double ratingValue;
  final int reviewsCount;
  final int soldCount;
  final String soldLabel;
  final int stock;
  final String category;
  final String condition;
  final String description;
  final String weightLabel;

  CatalogProduct copyWith({
    String? id,
    String? title,
    int? unitPrice,
    String? imageUrl,
    String? sellerName,
    String? sellerUid,
    String? sellerInitials,
    double? sellerRating,
    String? locationLabel,
    double? ratingValue,
    int? reviewsCount,
    int? soldCount,
    String? soldLabel,
    int? stock,
    String? category,
    String? condition,
    String? description,
    String? weightLabel,
  }) {
    return CatalogProduct(
      id: id ?? this.id,
      title: title ?? this.title,
      unitPrice: unitPrice ?? this.unitPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      sellerName: sellerName ?? this.sellerName,
      sellerUid: sellerUid ?? this.sellerUid,
      sellerInitials: sellerInitials ?? this.sellerInitials,
      sellerRating: sellerRating ?? this.sellerRating,
      locationLabel: locationLabel ?? this.locationLabel,
      ratingValue: ratingValue ?? this.ratingValue,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      soldCount: soldCount ?? this.soldCount,
      soldLabel: soldLabel ?? this.soldLabel,
      stock: stock ?? this.stock,
      category: category ?? this.category,
      condition: condition ?? this.condition,
      description: description ?? this.description,
      weightLabel: weightLabel ?? this.weightLabel,
    );
  }

  Map<String, dynamic> toRtdbMap() => {
        'id': id,
        'title': title,
        'unitPrice': unitPrice,
        'imageUrl': imageUrl,
        'sellerName': sellerName,
        'sellerUid': sellerUid,
        'sellerInitials': sellerInitials,
        'sellerRating': sellerRating,
        'locationLabel': locationLabel,
        'ratingValue': ratingValue,
        'reviewsCount': reviewsCount,
        'soldCount': soldCount,
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
      if (v is String) return int.tryParse(v.trim()) ?? fallback;
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

    final soldCount = _soldCountFromRaw(raw, asInt, asStr);

    return CatalogProduct(
      id: asStr(raw['id'], key),
      title: title,
      unitPrice: asInt(raw['unitPrice']),
      imageUrl: asStr(
        raw['imageUrl'],
        'https://images.unsplash.com/photo-1560472354-b33ff0c44a43',
      ),
      sellerName: seller,
      sellerUid: asStr(raw['sellerUid']),
      sellerInitials: sellerInitials,
      sellerRating: asDouble(raw['sellerRating'], 4.8),
      locationLabel: asStr(raw['locationLabel'], 'Indonesia'),
      ratingValue: asDouble(raw['ratingValue'], 4.5),
      reviewsCount: asInt(raw['reviewsCount']),
      soldCount: soldCount,
      soldLabel: asStr(raw['soldLabel'], '$soldCount terjual'),
      stock: asInt(raw['stock'], 1),
      category: asStr(raw['category'], 'Lainnya'),
      condition: asStr(raw['condition'], 'Bekas'),
      description: asStr(raw['description']),
      weightLabel: asStr(raw['weightLabel'], '-'),
    );
  }

  static int _soldCountFromRaw(
    Map<dynamic, dynamic> raw,
    int Function(dynamic, [int]) asInt,
    String Function(dynamic, [String]) asStr,
  ) {
    if (raw.containsKey('soldCount')) {
      return asInt(raw['soldCount']);
    }
    final label = asStr(raw['soldLabel'], '');
    final match = RegExp(r'(\d+)').firstMatch(label);
    if (match != null) {
      return int.tryParse(match.group(1)!) ?? 0;
    }
    return 0;
  }
}
