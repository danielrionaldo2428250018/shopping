import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/catalog_data.dart';
import '../models/cart_line.dart';
import '../models/catalog_product.dart';

class CartProvider extends ChangeNotifier {
  CartProvider(this._prefs) {
    _restore();
  }

  final SharedPreferences _prefs;

  static const _kCart = 'cart_lines_v1';

  final List<CartLine> _lines = [];

  List<CartLine> get lines => List.unmodifiable(_lines);

  int get itemCount =>
      _lines.fold(0, (s, e) => s + e.quantity);

  int get subtotal =>
      _lines.fold(0, (s, e) => s + e.lineTotal);

  bool containsProduct(String productId) =>
      _lines.any((l) => l.product.id == productId);

  void _restore() {
    final s = _prefs.getString(_kCart);
    if (s == null || s.isEmpty) return;
    try {
      final list = jsonDecode(s) as List<dynamic>;
      for (final row in list) {
        final m = row as Map<String, dynamic>;
        final id = m['id'] as String;
        final q = (m['q'] as num).toInt();
        final p = catalogProductById(id);
        if (p != null) {
          final qty = q.clamp(1, p.stock);
          _lines.add(CartLine(product: p, quantity: qty));
        }
      }
      notifyListeners();
    } catch (_) {}
  }

  void _persist() {
    final list = _lines
        .map(
          (l) => {
            'id': l.product.id,
            'q': l.quantity,
          },
        )
        .toList();
    _prefs.setString(_kCart, jsonEncode(list));
  }

  void addProduct(CatalogProduct product, {int quantity = 1}) {
    final i = _lines.indexWhere((l) => l.product.id == product.id);
    if (i >= 0) {
      final line = _lines[i];
      final maxAdd = product.stock - line.quantity;
      final add = quantity.clamp(0, maxAdd);
      if (add <= 0) return;
      line.quantity += add;
    } else {
      final q = quantity.clamp(1, product.stock);
      _lines.add(CartLine(product: product, quantity: q));
    }
    _persist();
    notifyListeners();
  }

  void setQuantity(String productId, int qty) {
    final i = _lines.indexWhere((l) => l.product.id == productId);
    if (i < 0) return;
    final line = _lines[i];
    if (qty <= 0) {
      _lines.removeAt(i);
    } else {
      line.quantity = qty.clamp(1, line.product.stock);
    }
    _persist();
    notifyListeners();
  }

  void removeLine(String productId) {
    _lines.removeWhere((l) => l.product.id == productId);
    _persist();
    notifyListeners();
  }

  void clear() {
    _lines.clear();
    _persist();
    notifyListeners();
  }
}
