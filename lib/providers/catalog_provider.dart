import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/catalog_data.dart';
import '../models/catalog_product.dart';
import '../services/catalog_rtdb_service.dart';
import '../services/push_notification_service.dart';

/// Sinkron katalog barang dari Realtime Database ke [kCatalogProducts].
class CatalogProvider extends ChangeNotifier {
  CatalogProvider({required bool firebaseReady}) {
    if (firebaseReady) {
      _subscribe();
    }
  }

  StreamSubscription<List<CatalogProduct>>? _sub;
  bool _loading = true;
  String? _error;

  bool get loading => _loading;
  String? get error => _error;

  List<CatalogProduct> get products =>
      List<CatalogProduct>.unmodifiable(kCatalogProducts);

  void _subscribe() {
    _sub = CatalogRtdbService.watchProducts().listen(
      (list) {
        kCatalogProducts
          ..clear()
          ..addAll(list);
        _loading = false;
        _error = null;
        notifyListeners();
      },
      onError: (Object e, StackTrace st) {
        if (kDebugMode) {
          debugPrint('Catalog RTDB error: $e\n$st');
        }
        _loading = false;
        _error = e.toString();
        notifyListeners();
      },
    );
  }

  /// Simpan produk baru + kirim notifikasi topic (shopping-cloud).
  Future<bool> publishProduct({
    required CatalogProduct product,
    bool notifySubscribers = true,
  }) async {
    try {
      final id = await CatalogRtdbService.saveProduct(product);
      if (notifySubscribers) {
        await sendNotificationToTopic(
          title: 'Produk baru di PreLoved',
          body: product.title,
          senderName: product.sellerName,
        );
      }
      if (kDebugMode) debugPrint('publishProduct ok: $id');
      return true;
    } catch (e, st) {
      if (kDebugMode) debugPrint('publishProduct gagal: $e\n$st');
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> clearAllProducts() async {
    try {
      await CatalogRtdbService.clearAllProducts();
      kCatalogProducts.clear();
      _loading = false;
      _error = null;
      notifyListeners();
      return true;
    } catch (e, st) {
      if (kDebugMode) debugPrint('clearAllProducts gagal: $e\n$st');
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
