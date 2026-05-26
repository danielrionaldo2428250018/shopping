import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/catalog_data.dart';
import '../services/review_catalog_sync.dart';
import '../utils/store_name_match.dart';

/// Ulasan pembeli — disimpan lokal; rating produk/toko disinkron ke katalog.
class ReviewsProvider extends ChangeNotifier {
  ReviewsProvider(this._prefs) {
    _restore();
  }

  final SharedPreferences _prefs;
  static const _kReviews = 'user_reviews_v2';

  final List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items =>
      List.unmodifiable(_items);

  void _restore() {
    _items.clear();
    _prefs.remove('user_reviews_v1');
    final raw = _prefs.getString(_kReviews) ?? _prefs.getString('user_reviews_v1');
    if (raw == null || raw.isEmpty) {
      notifyListeners();
      return;
    }
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      for (final e in list) {
        if (e is Map<String, dynamic>) {
          _items.add(e);
        } else if (e is Map) {
          _items.add(Map<String, dynamic>.from(e));
        }
      }
    } catch (_) {
      _prefs.remove(_kReviews);
    }
    notifyListeners();
  }

  void _persist() {
    _prefs.setString(_kReviews, jsonEncode(_items));
  }

  List<Map<String, dynamic>> reviewsForProduct(String productId) {
    if (productId.isEmpty) return const [];
    return _items
        .where((e) => (e['productId'] as String?) == productId)
        .toList();
  }

  ({double avg, int count}) productRatingSummary(String productId) {
    final list = reviewsForProduct(productId);
    if (list.isEmpty) return (avg: 0.0, count: 0);
    var sum = 0;
    for (final e in list) {
      sum += (e['rating'] as num?)?.toInt() ?? 0;
    }
    return (avg: sum / list.length, count: list.length);
  }

  /// Rata-rata bintang toko dari semua ulasan produk penjual ini.
  ({double avg, int count}) sellerRatingSummary(String sellerName) {
    final key = sellerName.trim();
    if (key.isEmpty) return (avg: 0.0, count: 0);

    final matched = _items.where((e) {
      final stored = (e['sellerName'] as String?)?.trim() ?? '';
      if (stored.isNotEmpty && storeNamesMatch(stored, key)) return true;
      final pid = (e['productId'] as String?)?.trim() ?? '';
      if (pid.isEmpty) return false;
      final p = catalogProductById(pid);
      return p != null && storeNamesMatch(p.sellerName, key);
    }).toList();

    if (matched.isEmpty) return (avg: 0.0, count: 0);
    var sum = 0;
    for (final e in matched) {
      sum += (e['rating'] as num?)?.toInt() ?? 0;
    }
    return (avg: sum / matched.length, count: matched.length);
  }

  bool hasReviewForOrderProduct({
    required String orderId,
    required String productId,
  }) {
    if (orderId.isEmpty || productId.isEmpty) return false;
    return _items.any(
      (e) =>
          e['orderId'] == orderId && e['productId'] == productId,
    );
  }

  bool hasReviewForOrder(String orderId) {
    if (orderId.isEmpty) return false;
    return _items.any((e) => e['orderId'] == orderId);
  }

  Future<bool> addReview({
    required String name,
    required String review,
    required int rating,
    required String orderId,
    required String productId,
    required String sellerName,
  }) async {
    final oid = orderId.trim();
    final pid = productId.trim();
    if (oid.isEmpty || pid.isEmpty) return false;
    if (hasReviewForOrderProduct(orderId: oid, productId: pid)) {
      return false;
    }

    final stars = rating.clamp(1, 5);
    final text = review.trim();
    if (text.isEmpty) return false;

    _items.insert(0, {
      'name': name,
      'review': text,
      'rating': stars,
      'orderId': oid,
      'productId': pid,
      'sellerName': sellerName.trim(),
      'at': DateTime.now().toIso8601String(),
    });
    _persist();

    await ReviewCatalogSync.applyAfterReview(
      reviews: this,
      productId: pid,
      sellerName: sellerName,
    );
    notifyListeners();
    return true;
  }

  void clearAll() {
    _items.clear();
    _prefs.remove(_kReviews);
    _prefs.remove('user_reviews_v1');
    notifyListeners();
  }
}
