import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/catalog_data.dart';
import '../models/cart_line.dart';
import '../models/order_status.dart';
import '../models/shop_order.dart';
import '../services/catalog_rtdb_service.dart';
import '../services/chat_rtdb_service.dart';
import '../services/orders_rtdb_service.dart';
import '../utils/loyalty_points.dart';
import '../services/app_notifications.dart';
import '../services/chat_seller_notify.dart';
import '../services/order_seller_notify.dart';
import '../utils/store_name_match.dart';
import 'auth_provider.dart';
import 'cart_provider.dart';
import 'inbox_messages_provider.dart';
import 'seller_applications_provider.dart';

class OrdersProvider extends ChangeNotifier {
  OrdersProvider(this._prefs) {
    _restoreOrSeed();
  }

  final SharedPreferences _prefs;
  AuthProvider? _auth;
  SellerApplicationsProvider? _sellers;
  InboxMessagesProvider? _inbox;

  static const _kOrders = 'orders_data_v2';
  static const _kNext = 'orders_next_id_v1';

  final List<ShopOrder> _orders = [];
  final List<ShopOrder> _sellerOrders = [];

  StreamSubscription<List<ShopOrder>>? _buyerSub;
  StreamSubscription<List<ShopOrder>>? _sellerSub;
  final Map<String, StreamSubscription<List<ShopOrder>>> _sellerSlugSubs = {};
  String? _boundBuyerUid;
  String? _boundSellerUid;
  Set<String> _boundSellerSlugs = {};
  List<ShopOrder> _sellerOrdersByUid = [];
  List<ShopOrder> _sellerOrdersBySlug = [];
  final Map<String, List<ShopOrder>> _slugOrderCache = {};
  Set<String> _cloudSellerSlugs = {};
  Set<String> _knownSellerOrderIds = {};
  String? _sellerLinkPassUid;
  bool _sellerLinkRunning = false;

  List<ShopOrder> get orders => List.unmodifiable(_orders);
  List<ShopOrder> get sellerOrders => List.unmodifiable(_sellerOrders);

  int get sellerPendingCount => _sellerOrders
      .where(
        (o) =>
            o.status == OrderStatus.processing ||
            o.status == OrderStatus.packing,
      )
      .length;

  int get totalEcoPoints => _orders
      .where((o) => o.status != OrderStatus.cancelled)
      .fold(0, (sum, o) => sum + o.ecoPointsEarned);

  int _nextId = 1;

  void bindAuth(AuthProvider auth) {
    if (_auth == auth) return;
    _auth?.removeListener(_onAuthChanged);
    _auth = auth;
    auth.addListener(_onAuthChanged);
    _onAuthChanged();
  }

  void bindInbox(InboxMessagesProvider inbox) {
    _inbox = inbox;
  }

  void bindSellers(SellerApplicationsProvider sellers) {
    if (_sellers == sellers) return;
    _sellers?.removeListener(_onAuthChanged);
    _sellers = sellers;
    sellers.addListener(_onAuthChanged);
    _onAuthChanged();
  }

  void attachFirebase() {
    if (Firebase.apps.isEmpty) return;
    _onAuthChanged();
  }

  /// Daftarkan toko di RTDB + dengarkan semua indeks pesanan penjual.
  Future<void> ensureSellerRtdbLinked() async {
    final uid = _auth?.uid?.trim() ??
        FirebaseAuth.instance.currentUser?.uid.trim();
    final store = _sellers?.myApprovedStore;
    if (uid == null || uid.isEmpty) return;
    try {
      if (store != null) {
        await ChatSellerNotify.linkSellerUid(
          storeName: store.storeName,
          sellerUid: uid,
        );
      }
      final registered = <String>{};
      for (final p in kCatalogProducts) {
        final ownsProduct = p.sellerUid.trim() == uid;
        final matchesStore = store != null &&
            storeNamesMatch(p.sellerName, store.storeName);
        if (!ownsProduct && !matchesStore) continue;
        final name = p.sellerName.trim();
        if (name.isEmpty || registered.contains(name)) continue;
        registered.add(name);
        await ChatRtdbService.registerSellerAccount(
          storeName: name,
          sellerUid: uid,
        );
      }
      _cloudSellerSlugs = await ChatRtdbService.slugsForSellerUid(uid);
    } catch (e) {
      if (kDebugMode) debugPrint('ensureSellerRtdbLinked: $e');
    }
    _boundSellerSlugs = {};
    _onAuthChanged();
  }

  void refreshSellerSubscriptions() {
    _sellerLinkPassUid = null;
    _boundSellerUid = null;
    _boundSellerSlugs = {};
    _onAuthChanged();
    final uid = _auth?.uid?.trim() ??
        FirebaseAuth.instance.currentUser?.uid.trim();
    if (uid != null && uid.isNotEmpty) {
      unawaited(ensureSellerRtdbLinked());
    }
  }

  Set<String> _sellerSlugsToWatch(String sellerUid) {
    final slugs = <String>{..._cloudSellerSlugs};
    final store = _sellers?.myApprovedStore;
    final canonical = store?.storeName.trim() ?? '';
    if (canonical.isNotEmpty) {
      slugs.add(storeNameSlug(canonical));
    }
    for (final p in kCatalogProducts) {
      final matchesStore =
          canonical.isNotEmpty && storeNamesMatch(p.sellerName, canonical);
      final ownsProduct = p.sellerUid.trim() == sellerUid;
      if (!matchesStore && !ownsProduct) continue;
      final s = storeNameSlug(p.sellerName);
      if (s.isNotEmpty) slugs.add(s);
    }
    return slugs;
  }

  void _onAuthChanged() {
    final uid = _auth?.uid?.trim() ??
        FirebaseAuth.instance.currentUser?.uid.trim();
    if (uid == null || uid.isEmpty) {
      _buyerSub?.cancel();
      _sellerSub?.cancel();
      for (final sub in _sellerSlugSubs.values) {
        sub.cancel();
      }
      _sellerSlugSubs.clear();
      _boundBuyerUid = null;
      _boundSellerUid = null;
      _boundSellerSlugs = {};
      _sellerLinkPassUid = null;
      _sellerLinkRunning = false;
      _cloudSellerSlugs = {};
      return;
    }
    if (_boundBuyerUid != uid) {
      _boundBuyerUid = uid;
      _buyerSub?.cancel();
      _buyerSub = OrdersRtdbService.watchBuyerOrders(uid).listen(
        _applyBuyerOrders,
        onError: (Object e) {
          if (kDebugMode) debugPrint('buyerOrders error: $e');
        },
      );
    }

    final approvedStore = _sellers?.myApprovedStore;
    final isSeller = approvedStore != null ||
        _auth?.hasApprovedSellerAccess == true;
    final sellerUid = isSeller ? uid : null;
    final slugs =
        isSeller && sellerUid != null ? _sellerSlugsToWatch(sellerUid) : <String>{};

    if (isSeller &&
        sellerUid != null &&
        sellerUid.isNotEmpty &&
        _sellerLinkPassUid != sellerUid &&
        !_sellerLinkRunning) {
      _sellerLinkRunning = true;
      unawaited(
        ensureSellerRtdbLinked().whenComplete(() {
          _sellerLinkPassUid = sellerUid;
          _sellerLinkRunning = false;
        }),
      );
    }

    if (_boundSellerUid != sellerUid) {
      _boundSellerUid = sellerUid;
      _sellerSub?.cancel();
      _sellerOrdersByUid = [];
      if (sellerUid != null && sellerUid.isNotEmpty) {
        _sellerSub = OrdersRtdbService.watchSellerOrders(sellerUid).listen(
          (list) {
            _sellerOrdersByUid = list;
            _mergeSellerOrders();
          },
          onError: (Object e) {
            if (kDebugMode) debugPrint('sellerOrders error: $e');
          },
        );
      } else {
        _mergeSellerOrders();
      }
    }

    if (_boundSellerSlugs != slugs) {
      _boundSellerSlugs = Set<String>.from(slugs);
      for (final sub in _sellerSlugSubs.values) {
        sub.cancel();
      }
      _sellerSlugSubs.clear();
      _sellerOrdersBySlug = [];
      for (final slug in slugs) {
        _slugOrderCache[slug] = [];
        _sellerSlugSubs[slug] =
            OrdersRtdbService.watchSellerOrdersByStore(slug).listen(
          (list) => _onSellerSlugOrders(slug, list),
          onError: (Object e) {
            if (kDebugMode) {
              debugPrint('sellerOrdersByStore/$slug error: $e');
            }
          },
        );
      }
      _mergeSellerOrders();
    }
  }

  void _onSellerSlugOrders(String slug, List<ShopOrder> list) {
    _slugOrderCache[slug] = list;
    _sellerOrdersBySlug = _slugOrderCache.values.expand((e) => e).toList();
    _mergeSellerOrders();
  }

  void _mergeSellerOrders() {
    final prevIds = Set<String>.from(_knownSellerOrderIds);
    final byId = <String, ShopOrder>{};
    for (final o in _sellerOrdersByUid) {
      byId[o.id] = o;
    }
    for (final o in _sellerOrdersBySlug) {
      byId[o.id] = o;
    }
    _sellerOrders
      ..clear()
      ..addAll(byId.values)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    for (final o in _sellerOrders) {
      if (!prevIds.contains(o.id)) {
        _notifySellerInbox(o);
      }
    }
    _knownSellerOrderIds = _sellerOrders.map((o) => o.id).toSet();
    notifyListeners();
  }

  void _applyBuyerOrders(List<ShopOrder> remote) {
    if (remote.isNotEmpty) {
      _orders
        ..clear()
        ..addAll(remote);
      _persist();
    }
    notifyListeners();
  }

  String? _currentBuyerUid() =>
      _auth?.uid?.trim() ?? FirebaseAuth.instance.currentUser?.uid.trim();

  /// UID penjual dari produk, katalog segar, atau peta `sellerAccounts`.
  Future<String> _resolveSellerUid({
    required String storeName,
    String? fromProduct,
    Iterable<String> productIds = const [],
  }) async {
    final direct = fromProduct?.trim() ?? '';
    if (direct.isNotEmpty) return direct;

    for (final id in productIds) {
      final fresh = catalogProductById(id);
      if (fresh != null && fresh.sellerUid.trim().isNotEmpty) {
        return fresh.sellerUid.trim();
      }
      final fromRtdb = await CatalogRtdbService.fetchSellerUidForProduct(id);
      if (fromRtdb != null && fromRtdb.isNotEmpty) {
        return fromRtdb;
      }
    }

    final fromRegistry = await ChatRtdbService.findSellerUidByStoreName(storeName);
    if (fromRegistry != null && fromRegistry.isNotEmpty) {
      return fromRegistry;
    }

    // Toko disetujui di perangkat ini — pakai UID login penjual saat ini.
    final store = _sellers?.myApprovedStore;
    if (store != null && storeNamesMatch(store.storeName, storeName)) {
      final me = _currentBuyerUid();
      if (me != null && me.isNotEmpty) return me;
    }

    return '';
  }

  void _restoreOrSeed() {
    final raw = _prefs.getString(_kOrders);
    if (raw != null && raw.isNotEmpty) {
      try {
        final map = jsonDecode(raw) as Map<String, dynamic>;
        _nextId = map['nextId'] as int? ?? 1;
        final list = map['orders'] as List<dynamic>? ?? [];
        _orders.clear();
        for (final e in list) {
          _orders.add(ShopOrder.fromJson(e as Map<String, dynamic>));
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

  String _newOrderId() {
    final id = 'ORD-${_nextId.toString().padLeft(3, '0')}';
    _nextId++;
    return id;
  }

  Future<void> _pushOrderCloud(ShopOrder order) async {
    if (Firebase.apps.isEmpty) return;
    if (order.buyerUid.isEmpty) {
      if (kDebugMode) {
        debugPrint('saveOrder: buyerUid kosong — login Firebase wajib');
      }
      return;
    }
    try {
      await FirebaseAuth.instance.currentUser?.getIdToken(true);
      await OrdersRtdbService.saveOrder(order);
      if (order.sellerStoreName.trim().isNotEmpty) {
        unawaited(
          OrderSellerNotify.notifyNewOrder(
            storeName: order.sellerStoreName,
            orderId: order.id,
            buyerName: order.buyerName,
            productTitle: order.primaryProductTitle,
            total: order.total,
          ),
        );
      }
    } catch (e, st) {
      if (kDebugMode) debugPrint('saveOrder cloud: $e\n$st');
    }
  }

  void _notifySellerInbox(ShopOrder order) {
    final title = 'Pesanan baru — ${order.id}';
    final preview =
        '${order.buyerName} memesan ${order.primaryProductTitle} (${formatIdr(order.total)})';
    _inbox?.addOrderAlert(
      orderId: order.id,
      title: title,
      preview: preview,
    );
    unawaited(
      presentUserNotification(
        title: title,
        body: preview,
        type: 'order',
        orderId: order.id,
      ),
    );
  }

  Future<({String orderId, int total, int pointsEarned})> addFromCheckout({
    required CartProvider cart,
    required int shippingFee,
    required int discount,
    String? buyerUid,
    String? buyerName,
  }) async {
    final uid = buyerUid ?? _currentBuyerUid() ?? '';
    final name = buyerName ??
        _auth?.displayName ??
        FirebaseAuth.instance.currentUser?.displayName ??
        'Pembeli';

    final byStore = <String, List<CartLine>>{};
    for (final l in cart.lines) {
      byStore.putIfAbsent(l.product.sellerName, () => []).add(l);
    }

    var firstId = '';
    var firstTotal = 0;
    var firstPoints = 0;
    final storeCount = byStore.length;
    var storeIndex = 0;

    for (final entry in byStore.entries) {
      final lines = <OrderLineSnapshot>[];
      var sub = 0;
      var sellerUid = '';
      final productIds = <String>[];
      for (final l in entry.value) {
        final p = l.product;
        productIds.add(p.id);
        if (sellerUid.isEmpty && p.sellerUid.isNotEmpty) {
          sellerUid = p.sellerUid;
        }
        sub += p.unitPrice * l.quantity;
        lines.add(
          OrderLineSnapshot(
            productId: p.id,
            title: p.title,
            imageUrl: p.imageUrl,
            unitPrice: p.unitPrice,
            quantity: l.quantity,
            storeName: p.sellerName,
            sellerUid: p.sellerUid,
          ),
        );
      }
      sellerUid = await _resolveSellerUid(
        storeName: entry.key,
        fromProduct: sellerUid,
        productIds: productIds,
      );
      if (sellerUid.isEmpty) {
        if (kDebugMode) {
          debugPrint(
            'Lewati cloud sellerOrders: UID toko "${entry.key}" tidak dikenal',
          );
        }
      }

      final shipShare = storeCount > 0 ? (shippingFee / storeCount).round() : 0;
      final discShare = storeCount > 0 ? (discount / storeCount).round() : 0;
      final total = sub + shipShare - discShare;
      final id = _newOrderId();
      final eco = loyaltyPointsForPurchaseTotal(total);
      final slug = storeNameSlug(entry.key);

      final resolvedLines = sellerUid.isEmpty
          ? lines
          : lines
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

      final order = ShopOrder(
        id: id,
        createdAt: DateTime.now(),
        lines: resolvedLines,
        subtotal: sub,
        shippingFee: shipShare,
        discount: discShare,
        total: total,
        status: OrderStatus.processing,
        buyerUid: uid,
        buyerName: name,
        sellerUid: sellerUid,
        sellerSlug: slug,
        sellerStoreName: entry.key,
        ecoPointsEarned: eco,
      );
      _orders.insert(0, order);
      await _pushOrderCloud(order);

      if (storeIndex == 0) {
        firstId = id;
        firstTotal = total;
        firstPoints = eco;
      }
      storeIndex++;
    }

    cart.clear();
    _persist();
    notifyListeners();
    return (orderId: firstId, total: firstTotal, pointsEarned: firstPoints);
  }

  Future<({String orderId, int total, int pointsEarned})> addSingleBuy({
    required String productId,
    required int quantity,
    required int shippingFee,
    int discount = 0,
    String? buyerUid,
    String? buyerName,
  }) async {
    final p = catalogProductById(productId);
    if (p == null) {
      return (orderId: '', total: 0, pointsEarned: 0);
    }
    final uid = buyerUid ?? _currentBuyerUid() ?? '';
    final name = buyerName ??
        _auth?.displayName ??
        FirebaseAuth.instance.currentUser?.displayName ??
        'Pembeli';
    final sub = p.unitPrice * quantity;
    final disc = discount.clamp(0, sub);
    final total = sub + shippingFee - disc;
    final id = _newOrderId();
    final eco = loyaltyPointsForPurchaseTotal(total);
    final sellerUid = await _resolveSellerUid(
      storeName: p.sellerName,
      fromProduct: p.sellerUid,
      productIds: [p.id],
    );

    final order = ShopOrder(
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
          sellerUid: sellerUid,
        ),
      ],
      subtotal: sub,
      shippingFee: shippingFee,
      discount: disc,
      total: total,
      status: OrderStatus.processing,
      buyerUid: uid,
      buyerName: name,
      sellerUid: sellerUid,
      sellerSlug: storeNameSlug(p.sellerName),
      sellerStoreName: p.sellerName,
      ecoPointsEarned: eco,
    );
    _orders.insert(0, order);
    await _pushOrderCloud(order);
    _persist();
    notifyListeners();
    return (orderId: id, total: total, pointsEarned: eco);
  }

  ShopOrder? orderById(String id) {
    for (final o in _orders) {
      if (o.id == id) return o;
    }
    for (final o in _sellerOrders) {
      if (o.id == id) return o;
    }
    return null;
  }

  Future<bool> _syncOrder(ShopOrder order) async {
    _persist();
    notifyListeners();
    if (Firebase.apps.isEmpty) return true;
    try {
      await OrdersRtdbService.updateOrder(order);
      return true;
    } catch (e) {
      if (kDebugMode) debugPrint('updateOrder: $e');
      return false;
    }
  }

  bool sellerStartPacking(String orderId) {
    final o = _findSellerOrder(orderId);
    if (o == null || o.status != OrderStatus.processing) return false;
    o.status = OrderStatus.packing;
    unawaited(_syncOrder(o));
    return true;
  }

  bool sellerFinishPacking(String orderId) {
    final o = _findSellerOrder(orderId);
    if (o == null || o.status != OrderStatus.packing) return false;
    o.status = OrderStatus.inProcess;
    o.trackingNumber ??=
        'JNE${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
    unawaited(_syncOrder(o));
    return true;
  }

  bool sellerCancelOrder(String orderId) {
    final o = _findSellerOrder(orderId);
    if (o == null || !OrderStatus.sellerCanCancel(o.status)) return false;
    o.status = OrderStatus.cancelled;
    unawaited(_syncOrder(o));
    _mirrorBuyerOrder(o);
    return true;
  }

  ShopOrder? _findSellerOrder(String id) {
    for (final o in _sellerOrders) {
      if (o.id == id) return o;
    }
    for (final o in _orders) {
      if (o.id == id) return o;
    }
    return null;
  }

  void _mirrorBuyerOrder(ShopOrder o) {
    final i = _orders.indexWhere((x) => x.id == o.id);
    if (i >= 0) {
      _orders[i].status = o.status;
      _orders[i].trackingNumber = o.trackingNumber;
    }
  }

  bool completeOrder(String orderId) {
    final i = _orders.indexWhere((o) => o.id == orderId);
    if (i < 0) return false;
    final o = _orders[i];
    if (!OrderStatus.buyerCanConfirmReceived(o.status)) return false;
    o.status = OrderStatus.completed;
    o.completedAt = DateTime.now();
    unawaited(_syncOrder(o));
    return true;
  }

  void cancelOrder(String orderId) {
    final i = _orders.indexWhere((o) => o.id == orderId);
    if (i < 0) return;
    final o = _orders[i];
    if (!OrderStatus.sellerCanCancel(o.status)) return;
    o.status = OrderStatus.cancelled;
    unawaited(_syncOrder(o));
  }

  bool markReviewed(String orderId) {
    final i = _orders.indexWhere((o) => o.id == orderId);
    if (i < 0) return false;
    _orders[i].reviewed = true;
    unawaited(_syncOrder(_orders[i]));
    return true;
  }

  void clearAll() {
    _orders.clear();
    _sellerOrders.clear();
    _nextId = 1;
    _persist();
    notifyListeners();
  }

  void ensureTracking(String orderId) {
    final i = _orders.indexWhere((o) => o.id == orderId);
    if (i < 0) return;
    final o = _orders[i];
    if (o.status != OrderStatus.inProcess) return;
    o.trackingNumber ??=
        'JNE${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
    unawaited(_syncOrder(o));
  }

  @override
  void dispose() {
    _auth?.removeListener(_onAuthChanged);
    _sellers?.removeListener(_onAuthChanged);
    _buyerSub?.cancel();
    _sellerSub?.cancel();
    for (final sub in _sellerSlugSubs.values) {
      sub.cancel();
    }
    _sellerSlugSubs.clear();
    super.dispose();
  }
}
