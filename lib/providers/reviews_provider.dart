import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Ulasan pengguna — kosong secara default, isi hanya dari aksi pengguna.
class ReviewsProvider extends ChangeNotifier {
  ReviewsProvider(this._prefs) {
    _restore();
  }

  final SharedPreferences _prefs;
  static const _kReviews = 'user_reviews_v1';

  final List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items =>
      List.unmodifiable(_items);

  void _restore() {
    _items.clear();
    final raw = _prefs.getString(_kReviews);
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

  void addReview({
    required String name,
    required String review,
    required int rating,
    String? orderId,
    String? productId,
  }) {
    _items.insert(0, {
      'name': name,
      'review': review,
      'rating': rating,
      if (orderId != null) 'orderId': orderId,
      if (productId != null && productId.isNotEmpty) 'productId': productId,
      'at': DateTime.now().toIso8601String(),
    });
    _persist();
    notifyListeners();
  }

  void clearAll() {
    _items.clear();
    _prefs.remove(_kReviews);
    notifyListeners();
  }
}
