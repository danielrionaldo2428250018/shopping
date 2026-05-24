import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import '../constants/firebase_rtdb_config.dart';
import '../data/catalog_data.dart';
import '../models/catalog_product.dart';

/// Baca/tulis produk ke Firebase Realtime Database.
class CatalogRtdbService {
  static FirebaseDatabase? _database;

  static FirebaseDatabase get _db {
    _database ??= FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: FirebaseRtdbConfig.databaseUrl,
    );
    return _database!;
  }

  static DatabaseReference get _productsRef =>
      _db.ref(FirebaseRtdbConfig.productsPath);

  static Stream<List<CatalogProduct>> watchProducts() {
    return _productsRef.onValue.map(_parseSnapshot);
  }

  static List<CatalogProduct> _parseSnapshot(DatabaseEvent event) {
    final value = event.snapshot.value;
    if (value == null) return [];

    if (value is! Map) return [];

    final list = <CatalogProduct>[];
    value.forEach((key, raw) {
      if (raw is Map) {
        list.add(CatalogProduct.fromRtdb(key.toString(), raw));
      }
    });

    list.sort((a, b) => b.id.compareTo(a.id));
    return list;
  }

  static Future<String> saveProduct(CatalogProduct product) async {
    final ref = _productsRef.push();
    final id = ref.key!;
    final data = product.toRtdbMap()..['id'] = id;
    await ref.set(data);
    if (kDebugMode) {
      debugPrint('RTDB products/$id tersimpan');
    }
    return id;
  }

  static Future<void> updateProduct(CatalogProduct product) async {
    final data = product.toRtdbMap()..['id'] = product.id;
    await _productsRef.child(product.id).set(data);
    if (kDebugMode) {
      debugPrint('RTDB products/${product.id} diperbarui');
    }
  }

  static Future<void> removeProduct(String id) async {
    await _productsRef.child(id).remove();
  }

  static int _asInt(dynamic v, [int fallback = 0]) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? fallback;
    return fallback;
  }

  static int _soldCountFromMap(Map<dynamic, dynamic> raw) {
    if (raw.containsKey('soldCount')) {
      return _asInt(raw['soldCount']);
    }
    final label = raw['soldLabel']?.toString() ?? '';
    final match = RegExp(r'(\d+)').firstMatch(label);
    if (match != null) {
      return int.tryParse(match.group(1)!) ?? 0;
    }
    return 0;
  }

  static Future<int?> fetchStock(String productId) async {
    if (productId.isEmpty) return null;
    final snap = await _productsRef.child(productId).get();
    if (!snap.exists || snap.value is! Map) return null;
    return _asInt((snap.value as Map)['stock']);
  }

  /// Kurangi stok dan tambah jumlah terjual (satu transaksi RTDB).
  static Future<bool> recordPurchase({
    required String productId,
    required int quantity,
  }) async {
    if (quantity <= 0) return true;
    final ref = _productsRef.child(productId);
    final result = await ref.runTransaction((current) {
      if (current is! Map) return Transaction.abort();
      final raw = Map<String, dynamic>.from(
        current.map((k, v) => MapEntry(k.toString(), v)),
      );
      final stock = _asInt(raw['stock']);
      if (stock < quantity) return Transaction.abort();

      final newSold = _soldCountFromMap(raw) + quantity;
      raw['stock'] = stock - quantity;
      raw['soldCount'] = newSold;
      raw['soldLabel'] = formatProductSoldLabel(newSold);
      if (!raw.containsKey('sellerUid')) {
        raw['sellerUid'] = '';
      }
      return Transaction.success(raw);
    });
    if (kDebugMode && !result.committed) {
      final remote = await fetchStock(productId);
      debugPrint(
        'recordPurchase gagal id=$productId qty=$quantity remoteStock=$remote',
      );
    }
    return result.committed;
  }

  /// Hapus seluruh node `products` di RTDB.
  static Future<void> clearAllProducts() async {
    await _productsRef.remove();
    if (kDebugMode) {
      debugPrint('RTDB products/ dikosongkan');
    }
  }
}
