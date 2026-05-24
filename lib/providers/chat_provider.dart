import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/chat_inbox_mode.dart';
import '../models/chat_models.dart';
import '../services/chat_rtdb_service.dart';
import '../services/chat_seller_notify.dart';
import '../utils/store_name_match.dart';
import 'auth_provider.dart';
import 'inbox_messages_provider.dart';
import 'seller_applications_provider.dart';
import 'user_profile_provider.dart';

/// Daftar & kirim obrolan real-time (RTDB), disinkron ke [InboxMessagesProvider].
class ChatProvider extends ChangeNotifier {
  ChatProvider({required this.firebaseReady}) {
    if (firebaseReady) {
      attachFirebase();
    } else {
      _lastError = 'Firebase tidak aktif';
    }
  }

  final bool firebaseReady;
  bool _firebaseAttached = false;

  /// Mulai langganan obrolan setelah Firebase siap.
  void attachFirebase() {
    if (_firebaseAttached) return;
    _firebaseAttached = true;
    _lastError = null;
    _threadSub = ChatRtdbService.watchThreads().listen(
      _onThreads,
      onError: (e) {
        _lastError = '$e';
        if (kDebugMode) debugPrint('chat threads error: $e');
        notifyListeners();
      },
    );
    notifyListeners();
  }

  bool get _chatLive => firebaseReady || _firebaseAttached;

  StreamSubscription<List<ChatThreadMeta>>? _threadSub;
  StreamSubscription<Set<String>>? _sellerIndexSub;
  StreamSubscription<List<ChatThreadMeta>>? _sellerInboxSub;
  List<ChatThreadMeta> _allThreads = [];
  List<ChatThreadMeta> _sellerInboxThreads = [];
  Set<String> _sellerThreadIds = {};
  final Set<String> _sellerStoreNames = {};
  String? _lastError;

  AuthProvider? _auth;
  SellerApplicationsProvider? _sellers;
  UserProfileProvider? _profile;
  InboxMessagesProvider? _inbox;

  String? get lastError => _lastError;
  bool get isReady => _chatLive;
  int get totalThreadCount => _allThreads.length;

  int get unreadChatCount =>
      myThreads.where((t) => t.isUnreadForUid(_auth?.uid)).length;

  int unreadForMode(ChatInboxMode mode) =>
      threadsForMode(mode).where((t) => t.isUnreadForUid(_auth?.uid)).length;

  bool threadIsSellerSide(ChatThreadMeta t) {
    final uid = _auth?.uid;
    if (uid == null) return false;
    if (t.sellerUid == uid) return true;
    if (_sellerThreadIds.contains(t.id)) return true;
    for (final name in _sellerStoreNames) {
      if (storeNamesMatch(t.sellerName, name)) return true;
    }
    return false;
  }

  List<ChatThreadMeta> threadsForMode(ChatInboxMode mode) {
    final uid = _auth?.uid;
    if (uid == null || uid.isEmpty) return const [];

    return myThreads.where((t) {
      switch (mode) {
        case ChatInboxMode.buyer:
          return t.buyerUid == uid;
        case ChatInboxMode.seller:
          return t.buyerUid != uid && threadIsSellerSide(t);
        case ChatInboxMode.all:
          return true;
      }
    }).toList();
  }

  List<ChatThreadMeta> get myThreads {
    final uid = _auth?.uid;
    if (uid == null || uid.isEmpty) return const [];

    final seen = <String>{};
    final out = <ChatThreadMeta>[];
    void add(ChatThreadMeta t) {
      if (seen.add(t.id)) out.add(t);
    }

    for (final t in _allThreads) {
      if (_threadBelongsToUser(t, uid)) add(t);
    }
    for (final t in _sellerInboxThreads) {
      add(t);
    }
    out.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return out;
  }

  bool _threadBelongsToUser(ChatThreadMeta t, String uid) {
    if (t.buyerUid == uid) return true;
    if (t.sellerUid == uid) return true;
    if (_sellerThreadIds.contains(t.id)) return true;

    for (final name in _sellerStoreNames) {
      if (storeNamesMatch(t.sellerName, name)) return true;
    }
    return false;
  }

  bool get _actsAsSeller =>
      _auth?.isSeller == true ||
      (_sellers?.myApprovedStores.isNotEmpty ?? false);

  void bindAuth(AuthProvider auth) {
    _auth = auth;
    auth.addListener(_onAuthChanged);
    _onAuthChanged();
  }

  void _onAuthChanged() {
    _resubscribeSellerStreams();
    unawaited(_collectSellerStoreNames());
    notifyListeners();
  }

  void bindSellers(SellerApplicationsProvider sellers) {
    _sellers?.removeListener(_onSellersChanged);
    _sellers = sellers;
    sellers.addListener(_onSellersChanged);
    _onSellersChanged();
  }

  void _onSellersChanged() {
    unawaited(_collectSellerStoreNames());
    for (final store in _sellers?.myApprovedStores ?? const []) {
      if (_auth?.isLoggedIn == true && store.storeName.trim().isNotEmpty) {
        unawaited(registerSellerForPush(store.storeName));
      }
    }
    notifyListeners();
  }

  Future<void> _collectSellerStoreNames() async {
    _sellerStoreNames.clear();
    for (final store in _sellers?.myApprovedStores ?? const []) {
      final name = store.storeName.trim();
      if (name.isNotEmpty) _sellerStoreNames.add(name);
    }

    final uid = _auth?.uid;
    if (uid != null && _chatLive) {
      try {
        final fromRtdb = await ChatRtdbService.storeNamesForSellerUid(uid);
        _sellerStoreNames.addAll(fromRtdb);
      } catch (e) {
        if (kDebugMode) debugPrint('storeNamesForSellerUid: $e');
      }
    }
    notifyListeners();
  }

  void _resubscribeSellerStreams() {
    _sellerIndexSub?.cancel();
    _sellerIndexSub = null;
    _sellerInboxSub?.cancel();
    _sellerInboxSub = null;
    _sellerThreadIds = {};
    _sellerInboxThreads = [];

    final uid = _auth?.uid;
    if (!_chatLive || uid == null || uid.isEmpty) return;

    _sellerIndexSub = ChatRtdbService.watchSellerThreadIds(uid).listen(
      (ids) {
        _sellerThreadIds = ids;
        _syncInboxMirror();
        notifyListeners();
      },
      onError: (e) {
        _lastError = '$e';
        if (kDebugMode) debugPrint('sellerThreads error: $e');
        notifyListeners();
      },
    );

    if (_actsAsSeller) {
      _sellerInboxSub = ChatRtdbService.watchSellerInbox(uid).listen(
        (list) {
          _sellerInboxThreads = list;
          _syncInboxMirror();
          notifyListeners();
        },
        onError: (e) {
          _lastError = '$e';
          if (kDebugMode) debugPrint('sellerInbox error: $e');
          notifyListeners();
        },
      );
    }
  }

  void bindProfile(UserProfileProvider profile) {
    _profile = profile;
  }

  void bindInbox(InboxMessagesProvider inbox) {
    _inbox = inbox;
  }

  void _onThreads(List<ChatThreadMeta> list) {
    _allThreads = list;
    _lastError = null;
    _syncInboxMirror();
    notifyListeners();
  }

  void _syncInboxMirror() {
    final inbox = _inbox;
    final uid = _auth?.uid;
    if (inbox == null || uid == null) return;
    inbox.syncFromChatThreads(
      threadsForMode(ChatInboxMode.buyer),
      uid,
      (t) => displayNameForThread(t, ChatInboxMode.buyer),
    );
  }

  String displayNameForThread(ChatThreadMeta t, ChatInboxMode mode) {
    switch (mode) {
      case ChatInboxMode.buyer:
        return t.sellerName.trim().isNotEmpty ? t.sellerName : 'Penjual';
      case ChatInboxMode.seller:
        return t.buyerName.trim().isNotEmpty ? t.buyerName : 'Pembeli';
      case ChatInboxMode.all:
        final uid = _auth?.uid;
        if (uid != null && t.buyerUid == uid) {
          return t.sellerName.trim().isNotEmpty ? t.sellerName : 'Penjual';
        }
        return t.buyerName.trim().isNotEmpty ? t.buyerName : 'Pembeli';
    }
  }

  String initialsFor(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  /// Sinkronkan obrolan penjual dari RTDB (panggil saat buka layar Pesan).
  Future<void> refreshSellerInbox() async {
    if (!_chatLive) {
      _lastError = 'Firebase tidak aktif';
      notifyListeners();
      return;
    }
    final uid = _auth?.uid;
    if (uid == null) {
      _lastError = 'Belum login';
      notifyListeners();
      return;
    }

    try {
      await _collectSellerStoreNames();

      for (final store in _sellers?.myApprovedStores ?? const []) {
        if (store.storeName.trim().isNotEmpty) {
          await registerSellerForPush(store.storeName);
        }
      }

      await ChatRtdbService.rebuildSellerThreadIndexForUid(uid);

      _allThreads = await ChatRtdbService.fetchAllThreads();

      final ids = await ChatRtdbService.fetchSellerThreadIds(uid);
      _sellerThreadIds = ids;
      _sellerInboxThreads = await ChatRtdbService.fetchThreadsByIds(ids);

      _lastError = null;
      _syncInboxMirror();
      notifyListeners();
    } catch (e) {
      _lastError = '$e';
      if (kDebugMode) debugPrint('refreshSellerInbox: $e');
      notifyListeners();
    }
  }

  Future<String?> openThreadWithSeller({
    required String sellerName,
    String? productId,
    String? productTitle,
  }) async {
    if (!_chatLive) {
      _lastError = 'Firebase tidak aktif';
      notifyListeners();
      return null;
    }

    final auth = _auth;
    if (auth == null || !auth.isLoggedIn || auth.uid == null) {
      _lastError = 'Belum login';
      return null;
    }

    final buyerUid = auth.uid!;
    final buyerName =
        _profile?.displayNameOrDefault ?? auth.displayName ?? 'Pembeli';

    var resolvedSeller = sellerName.trim();
    final app = _sellers?.approvedStoreBySellerName(sellerName);
    if (app != null && app.storeName.trim().isNotEmpty) {
      resolvedSeller = app.storeName.trim();
    }

    final threadId = ChatRtdbService.threadIdFor(
      buyerUid: buyerUid,
      sellerName: resolvedSeller,
    );

    var sellerUid = await ChatRtdbService.lookupSellerUid(resolvedSeller);

    for (final store in _sellers?.myApprovedStores ?? const []) {
      if (storeNamesMatch(store.storeName, resolvedSeller)) {
        sellerUid = auth.uid;
        break;
      }
    }

    try {
      await ChatRtdbService.ensureThread(
        threadId: threadId,
        buyerUid: buyerUid,
        buyerName: buyerName,
        sellerName: resolvedSeller,
        sellerUid: sellerUid,
        productId: productId,
        productTitle: productTitle,
      );
      _lastError = null;
      _syncInboxMirror();
      return threadId;
    } catch (e) {
      _lastError = '$e';
      if (kDebugMode) debugPrint('openThread: $e');
      notifyListeners();
      return null;
    }
  }

  Future<bool> sendMessage({
    required String threadId,
    required String text,
  }) async {
    final auth = _auth;
    if (auth == null || auth.uid == null || !_chatLive) return false;

    final name =
        _profile?.displayNameOrDefault ?? auth.displayName ?? 'User';

    try {
      await ChatRtdbService.sendMessage(
        threadId: threadId,
        text: text,
        senderUid: auth.uid!,
        senderName: name,
      );
      _lastError = null;

      final meta = await ChatRtdbService.getThreadMeta(threadId);
      if (meta != null) {
        _syncInboxMirror();
        if (meta.buyerUid == auth.uid) {
          await ChatSellerNotify.notifySeller(
            storeName: meta.sellerName,
            buyerName: name,
            messagePreview: text,
          );
        }
      }
      return true;
    } catch (e) {
      _lastError = '$e';
      if (kDebugMode) debugPrint('sendMessage: $e');
      notifyListeners();
      return false;
    }
  }

  Future<void> registerSellerForPush(String storeName) async {
    final uid = _auth?.uid;
    if (uid == null || storeName.trim().isEmpty || !_chatLive) return;

    await ChatSellerNotify.subscribeSellerStore(storeName);
    await ChatSellerNotify.linkSellerUid(
      storeName: storeName,
      sellerUid: uid,
    );
    await ChatRtdbService.rebuildSellerThreadIndex(
      storeName: storeName,
      sellerUid: uid,
    );
    _sellerStoreNames.add(storeName.trim());
  }

  @override
  void dispose() {
    _threadSub?.cancel();
    _sellerIndexSub?.cancel();
    _sellerInboxSub?.cancel();
    _auth?.removeListener(_onAuthChanged);
    _sellers?.removeListener(_onSellersChanged);
    super.dispose();
  }
}
