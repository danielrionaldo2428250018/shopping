import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/catalog_data.dart';
import '../utils/l10n_helpers.dart';
import '../models/catalog_product.dart';
import '../services/catalog_rtdb_service.dart';
import '../services/push_notification_service.dart';

/// Sinkron katalog barang dari Realtime Database ke [kCatalogProducts].
class CatalogProvider extends ChangeNotifier {
  CatalogProvider({
    required bool firebaseReady,
    required SharedPreferences prefs,
  }) : _prefs = prefs {
    if (firebaseReady) {
      attachFirebase();
    } else {
      _loading = false;
    }
  }

  /// Langganan RTDB — dipanggil setelah [Firebase.initializeApp] (startup non-blocking).
  void attachFirebase() {
    if (_sub != null) return;
    if (Firebase.apps.isEmpty) return;
    _loading = true;
    _error = null;
    notifyListeners();
    _subscribe();
  }

  void retryConnection() {
    _sub?.cancel();
    _sub = null;
    attachFirebase();
  }

  Future<bool> _ensureFirebaseReady() async {
    if (Firebase.apps.isEmpty) return false;
    attachFirebase();
    final user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  final SharedPreferences _prefs;

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
      if (!await _ensureFirebaseReady()) {
        _error = 'Firebase Auth belum siap. Login ulang lalu coba lagi.';
        notifyListeners();
        return false;
      }
      final id = await CatalogRtdbService.saveProduct(product);
      final saved = product.copyWith(id: id);
      final existing = kCatalogProducts.indexWhere((p) => p.id == id);
      if (existing >= 0) {
        kCatalogProducts[existing] = saved;
      } else {
        kCatalogProducts.insert(0, saved);
      }
      _error = null;
      notifyListeners();
      if (notifySubscribers) {
        final loc = appLocalizationsFromPrefs(_prefs);
        await sendNotificationToTopic(
          title: loc.productNewNotification,
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

  Future<bool> updateProduct(CatalogProduct product) async {
    try {
      await CatalogRtdbService.updateProduct(product);
      final i = kCatalogProducts.indexWhere((p) => p.id == product.id);
      if (i >= 0) {
        kCatalogProducts[i] = product;
      }
      _error = null;
      notifyListeners();
      return true;
    } catch (e, st) {
      if (kDebugMode) debugPrint('updateProduct gagal: $e\n$st');
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Kurangi stok dan perbarui terjual di RTDB. `false` jika ada yang gagal.
  Future<bool> fulfillPurchaseStock(
    Iterable<({String productId, int quantity})> lines,
  ) async {
    if (Firebase.apps.isNotEmpty &&
        FirebaseAuth.instance.currentUser == null) {
      _error = 'auth';
      notifyListeners();
      return false;
    }

    var allOk = true;
    for (final line in lines) {
      if (line.productId.isEmpty || line.quantity <= 0) continue;

      final local = catalogProductById(line.productId);
      final remoteStock = Firebase.apps.isNotEmpty
          ? await CatalogRtdbService.fetchStock(line.productId)
          : local?.stock;

      if (remoteStock == null) {
        allOk = false;
        if (kDebugMode) {
          debugPrint('produk tidak ada di RTDB: ${line.productId}');
        }
        continue;
      }

      if (remoteStock < line.quantity) {
        allOk = false;
        if (kDebugMode) {
          debugPrint(
            'stok RTDB=$remoteStock < qty=${line.quantity} untuk ${line.productId}',
          );
        }
        continue;
      }

      if (local != null && local.stock != remoteStock) {
        final i = kCatalogProducts.indexWhere((p) => p.id == line.productId);
        if (i >= 0) {
          kCatalogProducts[i] = local.copyWith(stock: remoteStock);
          notifyListeners();
        }
      }

      try {
        final ok = await CatalogRtdbService.recordPurchase(
          productId: line.productId,
          quantity: line.quantity,
        );
        if (!ok) {
          allOk = false;
          if (kDebugMode) {
            debugPrint(
              'transaksi stok gagal ${line.productId} (-${line.quantity})',
            );
          }
        }
      } catch (e, st) {
        allOk = false;
        if (kDebugMode) {
          debugPrint('fulfillPurchaseStock ${line.productId}: $e\n$st');
        }
      }
    }
    if (allOk) {
      _error = null;
    }
    return allOk;
  }

  Future<bool> deleteProduct(String id) async {
    try {
      await CatalogRtdbService.removeProduct(id);
      kCatalogProducts.removeWhere((p) => p.id == id);
      _error = null;
      notifyListeners();
      return true;
    } catch (e, st) {
      if (kDebugMode) debugPrint('deleteProduct gagal: $e\n$st');
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
