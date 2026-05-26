class OrderLineSnapshot {
  const OrderLineSnapshot({
    required this.productId,
    required this.title,
    required this.imageUrl,
    required this.unitPrice,
    required this.quantity,
    required this.storeName,
    this.sellerUid = '',
  });

  final String productId;
  final String title;
  final String imageUrl;
  final int unitPrice;
  final int quantity;
  final String storeName;
  final String sellerUid;

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'title': title,
        'imageUrl': imageUrl,
        'unitPrice': unitPrice,
        'quantity': quantity,
        'storeName': storeName,
        'sellerUid': sellerUid,
      };

  factory OrderLineSnapshot.fromJson(Map<String, dynamic> m) {
    return OrderLineSnapshot(
      productId: m['productId'] as String,
      title: m['title'] as String,
      imageUrl: m['imageUrl'] as String,
      unitPrice: (m['unitPrice'] as num).toInt(),
      quantity: (m['quantity'] as num).toInt(),
      storeName: m['storeName'] as String,
      sellerUid: m['sellerUid'] as String? ?? '',
    );
  }
}

/// Pesanan setelah checkout / beli langsung.
class ShopOrder {
  ShopOrder({
    required this.id,
    required this.createdAt,
    required this.lines,
    required this.subtotal,
    required this.shippingFee,
    required this.discount,
    required this.total,
    required this.status,
    this.trackingNumber,
    this.ecoPointsEarned = 0,
    this.completedAt,
    this.buyerUid = '',
    this.buyerName = '',
    this.sellerUid = '',
    this.sellerSlug = '',
    this.sellerStoreName = '',
    List<String>? reviewedProductIds,
  }) : reviewedProductIds = reviewedProductIds ?? <String>[];

  final String id;
  final DateTime createdAt;
  final List<OrderLineSnapshot> lines;
  final int subtotal;
  final int shippingFee;
  final int discount;
  final int total;

  /// Processing | Packing | InProcess | Completed | Cancelled
  String status;
  String? trackingNumber;
  DateTime? completedAt;
  final int ecoPointsEarned;

  final String buyerUid;
  final String buyerName;
  final String sellerUid;
  final String sellerSlug;
  final String sellerStoreName;

  /// ID produk yang sudah diulas untuk pesanan ini.
  final List<String> reviewedProductIds;

  bool get reviewed =>
      lines.isNotEmpty &&
      lines.every((l) => reviewedProductIds.contains(l.productId));

  bool isProductReviewed(String productId) =>
      reviewedProductIds.contains(productId);

  List<String> unreviewedProductIds() => lines
      .map((l) => l.productId)
      .where((id) => id.isNotEmpty && !reviewedProductIds.contains(id))
      .toSet()
      .toList();

  String get primaryProductTitle =>
      lines.isEmpty ? '' : lines.first.title;

  String get primaryProductId =>
      lines.isEmpty ? '' : lines.first.productId;

  String get primaryImage =>
      lines.isEmpty ? '' : lines.first.imageUrl;

  int get itemCount =>
      lines.fold(0, (s, e) => s + e.quantity);

  ShopOrder copyWith({
    String? status,
    String? trackingNumber,
    DateTime? completedAt,
    List<String>? reviewedProductIds,
    String? sellerUid,
    String? sellerSlug,
  }) {
    return ShopOrder(
      id: id,
      createdAt: createdAt,
      lines: lines,
      subtotal: subtotal,
      shippingFee: shippingFee,
      discount: discount,
      total: total,
      status: status ?? this.status,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      ecoPointsEarned: ecoPointsEarned,
      completedAt: completedAt ?? this.completedAt,
      buyerUid: buyerUid,
      buyerName: buyerName,
      sellerUid: sellerUid ?? this.sellerUid,
      sellerSlug: sellerSlug ?? this.sellerSlug,
      sellerStoreName: sellerStoreName,
      reviewedProductIds:
          reviewedProductIds ?? List<String>.from(this.reviewedProductIds),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'lines': lines.map((e) => e.toJson()).toList(),
        'subtotal': subtotal,
        'shippingFee': shippingFee,
        'discount': discount,
        'total': total,
        'status': status,
        'trackingNumber': trackingNumber,
        'ecoPointsEarned': ecoPointsEarned,
        'buyerUid': buyerUid,
        'buyerName': buyerName,
        'sellerUid': sellerUid,
        'sellerSlug': sellerSlug,
        'sellerStoreName': sellerStoreName,
        'reviewed': reviewed,
        'reviewedProductIds': reviewedProductIds,
        if (completedAt != null)
          'completedAt': completedAt!.toIso8601String(),
      };

  factory ShopOrder.fromJson(Map<String, dynamic> m) {
    return ShopOrder(
      id: m['id'] as String,
      createdAt: DateTime.parse(m['createdAt'] as String),
      lines: (m['lines'] as List<dynamic>)
          .map((e) => OrderLineSnapshot.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtotal: (m['subtotal'] as num).toInt(),
      shippingFee: (m['shippingFee'] as num).toInt(),
      discount: (m['discount'] as num).toInt(),
      total: (m['total'] as num).toInt(),
      status: m['status'] as String,
      trackingNumber: m['trackingNumber'] as String?,
      ecoPointsEarned: (m['ecoPointsEarned'] as num?)?.toInt() ?? 0,
      completedAt: m['completedAt'] != null
          ? DateTime.tryParse(m['completedAt'] as String)
          : null,
      buyerUid: m['buyerUid'] as String? ?? '',
      buyerName: m['buyerName'] as String? ?? '',
      sellerUid: m['sellerUid'] as String? ?? '',
      sellerSlug: m['sellerSlug'] as String? ?? '',
      sellerStoreName: m['sellerStoreName'] as String? ?? '',
      reviewedProductIds: _parseReviewedProductIds(m),
    );
  }

  static List<String> _parseReviewedProductIds(Map<String, dynamic> m) {
    final raw = m['reviewedProductIds'];
    if (raw is List) {
      return raw.map((e) => e.toString()).where((e) => e.isNotEmpty).toList();
    }
    if (m['reviewed'] == true) {
      final lines = m['lines'];
      if (lines is List && lines.isNotEmpty) {
        final first = lines.first;
        if (first is Map) {
          final id = first['productId']?.toString() ?? '';
          if (id.isNotEmpty) return [id];
        }
      }
    }
    return [];
  }
}
