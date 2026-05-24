class OrderLineSnapshot {
  const OrderLineSnapshot({
    required this.productId,
    required this.title,
    required this.imageUrl,
    required this.unitPrice,
    required this.quantity,
    required this.storeName,
  });

  final String productId;
  final String title;
  final String imageUrl;
  final int unitPrice;
  final int quantity;
  final String storeName;

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'title': title,
        'imageUrl': imageUrl,
        'unitPrice': unitPrice,
        'quantity': quantity,
        'storeName': storeName,
      };

  factory OrderLineSnapshot.fromJson(Map<String, dynamic> m) {
    return OrderLineSnapshot(
      productId: m['productId'] as String,
      title: m['title'] as String,
      imageUrl: m['imageUrl'] as String,
      unitPrice: (m['unitPrice'] as num).toInt(),
      quantity: (m['quantity'] as num).toInt(),
      storeName: m['storeName'] as String,
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
  });

  final String id;
  final DateTime createdAt;
  final List<OrderLineSnapshot> lines;
  final int subtotal;
  final int shippingFee;
  final int discount;
  final int total;

  /// Processing | Completed | Cancelled
  String status;
  String? trackingNumber;

  /// Waktu pembeli konfirmasi barang sudah diterima.
  DateTime? completedAt;

  /// Poin simbolis dampak lingkungan untuk pembelian ini.
  final int ecoPointsEarned;

  String get primaryProductTitle =>
      lines.isEmpty ? '' : lines.first.title;

  String get primaryImage =>
      lines.isEmpty ? '' : lines.first.imageUrl;

  int get itemCount =>
      lines.fold(0, (s, e) => s + e.quantity);

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
    );
  }
}
