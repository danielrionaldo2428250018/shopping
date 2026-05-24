import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/catalog_data.dart';
import '../utils/green_computing.dart';
import '../utils/l10n_helpers.dart';
import '../utils/notify_debouncer.dart';
import '../models/catalog_product.dart';
import '../services/catalog_rtdb_service.dart';
import '../services/chat_rtdb_service.dart';
import '../utils/store_name_match.dart';
import '../services/push_notification_service.dart';

/// Sinkron katalog barang dari Realtime Database ke [kCatalogProducts].
class CatalogProvider extends ChangeNotifier {
  CatalogProvider({
    required bool firebaseReady,
    required SharedPreferences prefs,
  }) : _prefs = prefs {
    _debouncer = NotifyDebouncer(
      delay: GreenComputing.providerNotifyDebounce(
        GreenComputing.readEcoFromPrefs(prefs),
      ),
    );
    if (firebaseReady) {
      attachFirebase();
    } else {
      _loading = false;
    }
  }

  /// Langganan RTDB — dipanggil setelah [Firebase.initializeApp] (startup non-blocking).
  void attachFirebase() {
    if (_sub != null || _subscribeTimer != null) return;
    if (Firebase.apps.isEmpty) return;
    _loading = true;
    _error = null;
    notifyListeners();

    final eco = GreenComputing.readEcoFromPrefs(_prefs);
    _subscribeTimer = Timer(GreenComputing.catalogSubscribeDelay(eco), () {
      _subscribeTimer = null;
      if (_sub != null) return;
      _subscribe();
    });
  }

  void retryConnection() {
    _sub?.cancel();
    _sub = null;
    _subscribeTimer?.cancel();
    _subscribeTimer = null;
    _catalogSignature = null;
    attachFirebase();
  }

  Future<bool> _ensureFirebaseReady() async {
    if (Firebase.apps.isEmpty) return false;
    attachFirebase();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;
    try {
      await user.getIdToken(true);
      return true;
    } catch (e) {
      if (kDebugMode) debugPrint('_ensureFirebaseReady getIdToken: $e');
      return false;
    }
  }

  CatalogProduct _withCurrentSellerUid(CatalogProduct product) {
    final uid = FirebaseAuth.instance.currentUser?.uid.trim();
    if (uid == null || uid.isEmpty) return product;
    if (product.sellerUid == uid) return product;
    return product.copyWith(sellerUid: uid);
  }

  final SharedPreferences _prefs;
  late final NotifyDebouncer _debouncer;
  Timer? _subscribeTimer;

  StreamSubscription<List<CatalogProduct>>? _sub;
  bool _loading = true;
  String? _error;
  String? _catalogSignature;

  bool get loading => _loading;
  String? get error => _error;

  List<CatalogProduct> get products =>
      List<CatalogProduct>.unmodifiable(kCatalogProducts);

  static String _signature(List<CatalogProduct> list) {
    if (list.isEmpty) return '';
    final buf = StringBuffer();
    for (final p in list) {
      buf
        ..write(p.id)
        ..write(':')
        ..write(p.stock)
        ..write('|');
    }
    return buf.toString();
  }

  void _applyCatalog(List<CatalogProduct> list) {
    final sig = _signature(list);
    if (sig == _catalogSignature && !_loading) return;
    _catalogSignature = sig;
    kCatalogProducts
      ..clear()
      ..addAll(list);
    _loading = false;
    _error = null;
    _debouncer.schedule(notifyListeners);
  }

  void _subscribe() {
    _sub = CatalogRtdbService.watchProducts().listen(
      _applyCatalog,
      onError: (Object e, StackTrace st) {
        if (kDebugMode) {
          debugPrint('Catalog RTDB error: $e\n$st');
        }
        _loading = false;
        _error = e.toString();
        _debouncer.schedule(notifyListeners);
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
      final toSave = _withCurrentSellerUid(product);
      final id = await CatalogRtdbService.saveProduct(toSave);
      final saved = toSave.copyWith(id: id);
      final existing = kCatalogProducts.indexWhere((p) => p.id == id);
      if (existing >= 0) {
        kCatalogProducts[existing] = saved;
      } else {
        kCatalogProducts.insert(0, saved);
      }
      _catalogSignature = null;
      _error = null;
      notifyListeners();
      if (notifySubscribers) {
        try {
          final loc = appLocalizationsFromPrefs(_prefs);
          await sendNotificationToTopic(
            title: loc.productNewNotification,
            body: toSave.title,
            senderName: toSave.sellerName,
          );
        } catch (e, st) {
          if (kDebugMode) {
            debugPrint('push notifikasi produk baru gagal (produk tersimpan): $e\n$st');
          }
        }
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

  Future<bool> updateProduct(
    CatalogProduct product, {
    String? claimSellerUid,
  }) async {
    try {
      if (!await _ensureFirebaseReady()) {
        _error = 'Firebase Auth belum siap. Login ulang lalu coba lagi.';
        notifyListeners();
        return false;
      }
      var toSave = product;
      final uid =
          claimSellerUid?.trim() ?? FirebaseAuth.instance.currentUser?.uid;
      if (uid != null && uid.isNotEmpty) {
        if (toSave.sellerUid.isEmpty) {
          toSave = toSave.copyWith(sellerUid: uid);
        } else if (toSave.sellerUid != uid) {
          _error = 'permission-denied';
          notifyListeners();
          return false;
        }
      }
      toSave = _withCurrentSellerUid(toSave);
      await CatalogRtdbService.updateProduct(toSave);
      final i = kCatalogProducts.indexWhere((p) => p.id == toSave.id);
      if (i >= 0) {
        kCatalogProducts[i] = toSave;
      }
      _catalogSignature = null;
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
          _catalogSignature = null;
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

  Future<bool> deleteProduct(
    String id, {
    String? claimSellerUid,
    String? sellerStoreName,
  }) async {
    try {
      if (!await _ensureFirebaseReady()) {
        _error = 'Firebase Auth belum siap. Login ulang lalu coba lagi.';
        notifyListeners();
        return false;
      }
      final uid =
          claimSellerUid?.trim() ?? FirebaseAuth.instance.currentUser?.uid.trim();
      if (uid == null || uid.isEmpty) {
        _error = 'auth';
        notifyListeners();
        return false;
      }

      final store = sellerStoreName?.trim();
      if (store != null && store.isNotEmpty) {
        await ChatRtdbService.registerSellerAccount(
          storeName: store,
          sellerUid: uid,
        );
      }

      final idx = kCatalogProducts.indexWhere((p) => p.id == id);
      if (idx >= 0) {
        final p = kCatalogProducts[idx];
        final slug = storeNameSlug(p.sellerName);
        if (slug.isNotEmpty && p.sellerUid != uid) {
          await CatalogRtdbService.claimProductOwnership(
            productId: id,
            sellerUid: uid,
            sellerSlug: slug,
          );
          kCatalogProducts[idx] = p.copyWith(sellerUid: uid);
        } else if (slug.isNotEmpty && p.sellerUid == uid) {
          await CatalogRtdbService.claimProductOwnership(
            productId: id,
            sellerUid: uid,
            sellerSlug: slug,
          );
        }
      }

      await CatalogRtdbService.removeProduct(id);
      kCatalogProducts.removeWhere((p) => p.id == id);
      _catalogSignature = null;
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
      _catalogSignature = null;
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
    _subscribeTimer?.cancel();
    _debouncer.dispose();
    super.dispose();
  }
}
