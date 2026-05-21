import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/catalog_data.dart';
import '../models/shop_order.dart';
import '../utils/loyalty_points.dart';
import 'cart_provider.dart';

class OrdersProvider extends ChangeNotifier {
  OrdersProvider(this._prefs) {
    _restoreOrSeed();
  }

  final SharedPreferences _prefs;

  static const _kOrders = 'orders_data_v1';
  static const _kNext = 'orders_next_id_v1';

  final List<ShopOrder> _orders = [];

  List<ShopOrder> get orders => List.unmodifiable(_orders);

  /// Total poin hijau (pesanan dibatalkan tidak dihitung).
  int get totalEcoPoints => _orders
      .where((o) => o.status != 'Cancelled')
      .fold(0, (sum, o) => sum + o.ecoPointsEarned);

  int _nextId = 1;

  void _restoreOrSeed() {
    final raw = _prefs.getString(_kOrders);
    if (raw != null && raw.isNotEmpty) {
      try {
        final map = jsonDecode(raw) as Map<String, dynamic>;
        _nextId = map['nextId'] as int? ?? 1;
        final list = map['orders'] as List<dynamic>? ?? [];
        _orders.clear();
        for (final e in list) {
          _orders.add(
            ShopOrder.fromJson(e as Map<String, dynamic>),
          );
        }
        notifyListeners();
        return;
      } catch (_) {}
    }
    _orders.clear();
    _nextId = 1;
    _persist();
  }

  void _persist() {
    _prefs.setString(
      _kOrders,
      jsonEncode({
        'nextId': _nextId,
        'orders': _orders.map((e) => e.toJson()).toList(),
      }),
    );
    _prefs.setInt(_kNext, _nextId);
  }

  /// Membuat pesanan; mengembalikan `(orderId, total, pointsEarned)`.
  ({String orderId, int total, int pointsEarned}) addFromCheckout({
    required CartProvider cart,
    required int shippingFee,
    required int discount,
  }) {
    final lines = <OrderLineSnapshot>[];
    for (final l in cart.lines) {
      lines.add(
        OrderLineSnapshot(
          productId: l.product.id,
          title: l.product.title,
          imageUrl: l.product.imageUrl,
          unitPrice: l.product.unitPrice,
          quantity: l.quantity,
          storeName: l.product.sellerName,
        ),
      );
    }
    final sub = cart.subtotal;
    final total = sub + shippingFee - discount;
    final id = 'ORD-${_nextId.toString().padLeft(3, '0')}';
    final eco = loyaltyPointsForPurchaseTotal(total);
    _nextId++;
    _orders.insert(
      0,
      ShopOrder(
        id: id,
        createdAt: DateTime.now(),
        lines: lines,
        subtotal: sub,
        shippingFee: shippingFee,
        discount: discount,
        total: total,
        status: 'Processing',
        trackingNumber: null,
        ecoPointsEarned: eco,
      ),
    );
    cart.clear();
    _persist();
    notifyListeners();
    return (orderId: id, total: total, pointsEarned: eco);
  }

  ({String orderId, int total, int pointsEarned}) addSingleBuy({
    required String productId,
    required int quantity,
    required int shippingFee,
  }) {
    final p = catalogProductById(productId);
    if (p == null) {
      return (orderId: '', total: 0, pointsEarned: 0);
    }
    final sub = p.unitPrice * quantity;
    final total = sub + shippingFee;
    final id = 'ORD-${_nextId.toString().padLeft(3, '0')}';
    final eco = loyaltyPointsForPurchaseTotal(total);
    _nextId++;
    _orders.insert(
      0,
      ShopOrder(
        id: id,
        createdAt: DateTime.now(),
        lines: [
          OrderLineSnapshot(
            productId: p.id,
            title: p.title,
            imageUrl: p.imageUrl,
            unitPrice: p.unitPrice,
            quantity: quantity,
            storeName: p.sellerName,
          ),
        ],
        subtotal: sub,
        shippingFee: shippingFee,
        discount: 0,
        total: total,
        status: 'Processing',
        trackingNumber: null,
        ecoPointsEarned: eco,
      ),
    );
    _persist();
    notifyListeners();
    return (orderId: id, total: total, pointsEarned: eco);
  }

  /// Batalkan pesanan yang masih diproses.
  void cancelOrder(String orderId) {
    final i = _orders.indexWhere((o) => o.id == orderId);
    if (i < 0) return;
    final o = _orders[i];
    if (o.status != 'Processing') return;
    o.status = 'Cancelled';
    _persist();
    notifyListeners();
  }

  /// Untuk demo: beri nomor resi jika belum ada (lacak paket).
  void ensureTracking(String orderId) {
    final i = _orders.indexWhere((o) => o.id == orderId);
    if (i < 0) return;
    final o = _orders[i];
    if (o.status != 'Processing') return;
    o.trackingNumber ??=
        'JNEJT${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}';
    _persist();
    notifyListeners();
  }
}
