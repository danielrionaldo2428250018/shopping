import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import '../constants/firebase_rtdb_config.dart';
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

  static Future<void> removeProduct(String id) async {
    await _productsRef.child(id).remove();
  }

  /// Hapus seluruh node `products` di RTDB.
  static Future<void> clearAllProducts() async {
    await _productsRef.remove();
    if (kDebugMode) {
      debugPrint('RTDB products/ dikosongkan');
    }
  }
}
