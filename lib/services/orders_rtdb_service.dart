import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import '../constants/firebase_rtdb_config.dart';
import '../models/shop_order.dart';
import '../services/chat_rtdb_service.dart';
import '../utils/store_name_match.dart';

/// Sinkron pesanan pembeli ↔ penjual via Realtime Database.
class OrdersRtdbService {
  static FirebaseDatabase? _database;

  static FirebaseDatabase get _db {
    _database ??= FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: FirebaseRtdbConfig.databaseUrl,
    );
    return _database!;
  }

  static DatabaseReference get _buyerOrdersRef =>
      _db.ref(FirebaseRtdbConfig.buyerOrdersPath);

  static DatabaseReference get _sellerOrdersRef =>
      _db.ref(FirebaseRtdbConfig.sellerOrdersPath);

  static DatabaseReference get _sellerOrdersByStoreRef =>
      _db.ref(FirebaseRtdbConfig.sellerOrdersByStorePath);

  static List<ShopOrder> _parseSnapshot(DatabaseEvent event) {
    final snap = event.snapshot;
    if (!snap.exists || snap.value is! Map) return [];
    final root = snap.value as Map;
    final list = <ShopOrder>[];
    root.forEach((_, raw) {
      if (raw is Map) {
        list.add(
          ShopOrder.fromJson(
            Map<String, dynamic>.from(
              raw.map((k, v) => MapEntry(k.toString(), v)),
            ),
          ),
        );
      }
    });
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  static Stream<List<ShopOrder>> watchBuyerOrders(String buyerUid) {
    if (buyerUid.isEmpty) return Stream.value([]);
    return _buyerOrdersRef.child(buyerUid).onValue.map(_parseSnapshot);
  }

  static Stream<List<ShopOrder>> watchSellerOrders(String sellerUid) {
    if (sellerUid.isEmpty) return Stream.value([]);
    return _sellerOrdersRef.child(sellerUid).onValue.map(_parseSnapshot);
  }

  static Stream<List<ShopOrder>> watchSellerOrdersByStore(String storeSlug) {
    if (storeSlug.isEmpty) return Stream.value([]);
    return _sellerOrdersByStoreRef.child(storeSlug).onValue.map(_parseSnapshot);
  }

  /// Lengkapi UID/slug penjual dari `sellerAccounts` atau produk sebelum simpan.
  static Future<ShopOrder> enrichSellerIdentity(ShopOrder order) async {
    var sellerUid = order.sellerUid.trim();
    final store = order.sellerStoreName.trim();
    var slug = order.sellerSlug.trim();
    if (slug.isEmpty && store.isNotEmpty) {
      slug = storeNameSlug(store);
    }

    if (sellerUid.isEmpty && store.isNotEmpty) {
      final fromRegistry = await ChatRtdbService.findSellerUidByStoreName(store);
      if (fromRegistry != null && fromRegistry.isNotEmpty) {
        sellerUid = fromRegistry;
      }
    }

    if (sellerUid == order.sellerUid && slug == order.sellerSlug) {
      return order;
    }

    final lines = sellerUid.isEmpty
        ? order.lines
        : order.lines
            .map(
              (l) => OrderLineSnapshot(
                productId: l.productId,
                title: l.title,
                imageUrl: l.imageUrl,
                unitPrice: l.unitPrice,
                quantity: l.quantity,
                storeName: l.storeName,
                sellerUid: sellerUid,
              ),
            )
            .toList();
    return ShopOrder(
      id: order.id,
      createdAt: order.createdAt,
      lines: lines,
      subtotal: order.subtotal,
      shippingFee: order.shippingFee,
      discount: order.discount,
      total: order.total,
      status: order.status,
      trackingNumber: order.trackingNumber,
      ecoPointsEarned: order.ecoPointsEarned,
      completedAt: order.completedAt,
      buyerUid: order.buyerUid,
      buyerName: order.buyerName,
      sellerUid: sellerUid,
      sellerSlug: slug,
      sellerStoreName: store.isNotEmpty ? store : order.sellerStoreName,
      reviewedProductIds: order.reviewedProductIds,
    );
  }

  static Future<ShopOrder> saveOrder(ShopOrder order) async {
    if (order.buyerUid.isEmpty) {
      if (kDebugMode) {
        debugPrint('saveOrder: buyerUid kosong, lewati cloud');
      }
      return order;
    }

    final enriched = await enrichSellerIdentity(order);
    final data = enriched.toJson();
    final writes = <Future<void>>[
      _buyerOrdersRef.child(enriched.buyerUid).child(enriched.id).set(data),
    ];
    if (enriched.sellerUid.isNotEmpty) {
      writes.add(
        _sellerOrdersRef.child(enriched.sellerUid).child(enriched.id).set(data),
      );
    }
    final slug = enriched.sellerSlug.isNotEmpty
        ? enriched.sellerSlug
        : storeNameSlug(enriched.sellerStoreName);
    if (slug.isNotEmpty) {
      writes.add(
        _sellerOrdersByStoreRef.child(slug).child(enriched.id).set(data),
      );
    }
    await Future.wait(writes);
    if (kDebugMode) {
      debugPrint(
        'RTDB order ${enriched.id} → buyer + seller ${enriched.sellerUid} + slug $slug',
      );
      if (enriched.sellerUid.isEmpty) {
        debugPrint(
          'Peringatan: sellerUid kosong — penjual harus login sekali agar sellerAccounts terdaftar.',
        );
      }
    }
    return enriched;
  }

  static Future<void> updateOrder(ShopOrder order) async {
    if (order.buyerUid.isEmpty) return;
    final data = order.toJson();
    final writes = <Future<void>>[
      _buyerOrdersRef.child(order.buyerUid).child(order.id).update(data),
    ];
    if (order.sellerUid.isNotEmpty) {
      writes.add(
        _sellerOrdersRef.child(order.sellerUid).child(order.id).update(data),
      );
    }
    final slug = order.sellerSlug.isNotEmpty
        ? order.sellerSlug
        : storeNameSlug(order.sellerStoreName);
    if (slug.isNotEmpty) {
      writes.add(
        _sellerOrdersByStoreRef.child(slug).child(order.id).update(data),
      );
    }
    await Future.wait(writes);
  }
}
