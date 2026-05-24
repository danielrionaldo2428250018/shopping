import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import '../constants/firebase_rtdb_config.dart';
import '../models/chat_models.dart';
import '../utils/store_name_match.dart';

/// Obrolan real-time pembeli ↔ penjual di RTDB (tanpa Firebase Storage).
class ChatRtdbService {
  static FirebaseDatabase? _database;

  static FirebaseDatabase get _db {
    _database ??= FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: FirebaseRtdbConfig.databaseUrl,
    );
    return _database!;
  }

  static DatabaseReference get _chatsRef =>
      _db.ref(FirebaseRtdbConfig.chatsPath);

  static DatabaseReference get _sellerAccountsRef =>
      _db.ref(FirebaseRtdbConfig.sellerAccountsPath);

  static DatabaseReference get _sellerThreadsRef =>
      _db.ref(FirebaseRtdbConfig.sellerThreadsPath);

  static String threadIdFor({
    required String buyerUid,
    required String sellerName,
  }) {
    final safeSlug = storeNameSlug(sellerName);
    return '${buyerUid}_${safeSlug.isEmpty ? 'seller' : safeSlug}';
  }

  /// UID penjual yang pernah login & mendaftar topic toko ini.
  static Future<String?> lookupSellerUid(String storeName) async {
    final slug = storeNameSlug(storeName);
    if (slug.isEmpty) return null;
    final snap = await _sellerAccountsRef.child(slug).get();
    if (!snap.exists || snap.value is! Map) return null;
    final uid = (snap.value as Map)['uid'] as String?;
    return uid?.trim().isNotEmpty == true ? uid!.trim() : null;
  }

  static Future<void> registerSellerAccount({
    required String storeName,
    required String sellerUid,
  }) async {
    final slug = storeNameSlug(storeName);
    if (slug.isEmpty) return;
    await _sellerAccountsRef.child(slug).set({
      'uid': sellerUid,
      'storeName': storeName.trim(),
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Nama toko yang terhubung ke [sellerUid] di RTDB.
  static Future<Set<String>> storeNamesForSellerUid(String sellerUid) async {
    final snap = await _sellerAccountsRef.get();
    if (!snap.exists || snap.value is! Map) return {};
    final names = <String>{};
    final root = snap.value as Map;
    for (final raw in root.values) {
      if (raw is! Map) continue;
      final uid = (raw['uid'] as String?)?.trim();
      if (uid != sellerUid) continue;
      final name = (raw['storeName'] as String?)?.trim();
      if (name != null && name.isNotEmpty) names.add(name);
    }
    return names;
  }

  static Future<void> indexThreadForSeller({
    required String sellerUid,
    required String threadId,
    int? updatedAtMs,
  }) async {
    if (sellerUid.isEmpty || threadId.isEmpty) return;
    await _sellerThreadsRef.child(sellerUid).child(threadId).set({
      'updatedAt': updatedAtMs ?? DateTime.now().millisecondsSinceEpoch,
    });
  }

  static Future<List<ChatThreadMeta>> fetchAllThreads() async {
    final snap = await _chatsRef.get();
    if (!snap.exists || snap.value is! Map) return [];

    final list = <ChatThreadMeta>[];
    final root = snap.value as Map;
    for (final entry in root.entries) {
      final raw = entry.value;
      if (raw is! Map) continue;
      final meta = raw['meta'];
      if (meta is Map) {
        list.add(ChatThreadMeta.fromRtdb(entry.key.toString(), meta));
      }
    }
    list.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return list;
  }

  static Future<List<ChatThreadMeta>> fetchThreadsByIds(
    Iterable<String> threadIds,
  ) async {
    final list = <ChatThreadMeta>[];
    for (final id in threadIds) {
      final meta = await getThreadMeta(id);
      if (meta != null) list.add(meta);
    }
    list.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return list;
  }

  /// Muat thread dari indeks penjual (tidak bergantung pada filter nama toko).
  static Stream<List<ChatThreadMeta>> watchSellerInbox(String sellerUid) {
    return watchSellerThreadIds(sellerUid).asyncMap(fetchThreadsByIds);
  }

  /// Indeks ulang semua obrolan milik UID penjual.
  static Future<void> rebuildSellerThreadIndexForUid(String sellerUid) async {
    if (sellerUid.isEmpty) return;

    final names = await storeNamesForSellerUid(sellerUid);
    for (final name in names) {
      await rebuildSellerThreadIndex(
        storeName: name,
        sellerUid: sellerUid,
      );
    }

    final snap = await _chatsRef.get();
    if (!snap.exists || snap.value is! Map) return;

    for (final entry in (snap.value as Map).entries) {
      final raw = entry.value;
      if (raw is! Map) continue;
      final meta = raw['meta'];
      if (meta is! Map) continue;
      final uid = (meta['sellerUid'] as String?)?.trim() ?? '';
      if (uid != sellerUid) continue;
      final threadId = entry.key.toString();
      await indexThreadForSeller(
        sellerUid: sellerUid,
        threadId: threadId,
        updatedAtMs: meta['updatedAt'] is int
            ? meta['updatedAt'] as int
            : DateTime.now().millisecondsSinceEpoch,
      );
    }
  }

  static Future<Set<String>> fetchSellerThreadIds(String sellerUid) async {
    if (sellerUid.isEmpty) return {};
    final snap = await _sellerThreadsRef.child(sellerUid).get();
    if (!snap.exists || snap.value is! Map) return {};
    return (snap.value as Map).keys.map((k) => k.toString()).toSet();
  }

  static Stream<Set<String>> watchSellerThreadIds(String sellerUid) {
    if (sellerUid.isEmpty) {
      return Stream<Set<String>>.value({});
    }
    return _sellerThreadsRef.child(sellerUid).onValue.map((event) {
      final value = event.snapshot.value;
      if (value == null || value is! Map) return <String>{};
      return value.keys.map((k) => k.toString()).toSet();
    });
  }

  /// Daftarkan semua thread toko ini ke indeks penjual.
  static Future<void> rebuildSellerThreadIndex({
    required String storeName,
    required String sellerUid,
  }) async {
    if (sellerUid.isEmpty) return;
    final snap = await _chatsRef.get();
    if (!snap.exists || snap.value is! Map) return;

    final now = DateTime.now().millisecondsSinceEpoch;
    final root = snap.value as Map;
    for (final entry in root.entries) {
      final raw = entry.value;
      if (raw is! Map) continue;
      final meta = raw['meta'];
      if (meta is! Map) continue;
      final name = meta['sellerName'] as String? ?? '';
      if (!storeNamesMatch(name, storeName)) continue;
      final threadId = entry.key.toString();
      await _chatsRef.child(threadId).child('meta').update({
        'sellerUid': sellerUid,
      });
      await indexThreadForSeller(
        sellerUid: sellerUid,
        threadId: threadId,
        updatedAtMs: meta['updatedAt'] is int
            ? meta['updatedAt'] as int
            : now,
      );
    }
  }

  static Stream<List<ChatThreadMeta>> watchThreads() {
    return _chatsRef.onValue.map((event) {
      final value = event.snapshot.value;
      if (value == null || value is! Map) return <ChatThreadMeta>[];

      final list = <ChatThreadMeta>[];
      value.forEach((key, raw) {
        if (raw is! Map) return;
        final meta = raw['meta'];
        if (meta is Map) {
          list.add(ChatThreadMeta.fromRtdb(key.toString(), meta));
        }
      });
      list.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return list;
    });
  }

  static Stream<List<ChatMessage>> watchMessages(String threadId) {
    return _chatsRef
        .child(threadId)
        .child('messages')
        .onValue
        .map((event) {
      final value = event.snapshot.value;
      if (value == null || value is! Map) return <ChatMessage>[];

      final list = <ChatMessage>[];
      value.forEach((key, raw) {
        if (raw is Map) {
          list.add(ChatMessage.fromRtdb(key.toString(), raw));
        }
      });
      list.sort((a, b) => a.sentAt.compareTo(b.sentAt));
      return list;
    });
  }

  static Future<void> ensureThread({
    required String threadId,
    required String buyerUid,
    required String buyerName,
    required String sellerName,
    String? sellerUid,
    String? productId,
    String? productTitle,
  }) async {
    final metaRef = _chatsRef.child(threadId).child('meta');
    final snap = await metaRef.get();
    if (snap.exists) {
      if (sellerUid != null && sellerUid.isNotEmpty) {
        await metaRef.update({'sellerUid': sellerUid});
        await indexThreadForSeller(
          sellerUid: sellerUid,
          threadId: threadId,
        );
      }
      return;
    }

    final meta = ChatThreadMeta(
      id: threadId,
      buyerUid: buyerUid,
      buyerName: buyerName,
      sellerName: sellerName,
      sellerUid: sellerUid,
      productId: productId,
      productTitle: productTitle,
      updatedAt: DateTime.now(),
    );
    await metaRef.set(meta.toRtdbMap());
    if (sellerUid != null && sellerUid.isNotEmpty) {
      await indexThreadForSeller(sellerUid: sellerUid, threadId: threadId);
    }
    if (kDebugMode) debugPrint('RTDB chat thread dibuat: $threadId');
  }

  static Future<void> sendMessage({
    required String threadId,
    required String text,
    required String senderUid,
    required String senderName,
  }) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final now = DateTime.now();
    final msgRef = _chatsRef.child(threadId).child('messages').push();
    await msgRef.set({
      'text': trimmed,
      'senderUid': senderUid,
      'senderName': senderName,
      'sentAt': now.millisecondsSinceEpoch,
    });

    final metaRef = _chatsRef.child(threadId).child('meta');
    final metaSnap = await metaRef.get();
    var sellerUid = '';
    var buyerUid = '';
    var storeName = '';
    if (metaSnap.exists && metaSnap.value is Map) {
      final meta = metaSnap.value as Map;
      sellerUid = (meta['sellerUid'] as String?)?.trim() ?? '';
      buyerUid = (meta['buyerUid'] as String?)?.trim() ?? '';
      storeName = (meta['sellerName'] as String?)?.trim() ?? '';
      if (sellerUid.isEmpty && storeName.isNotEmpty) {
        sellerUid = (await lookupSellerUid(storeName)) ?? '';
      }
      if (sellerUid.isEmpty && storeName.isNotEmpty) {
        sellerUid =
            (await _linkThreadToRegisteredSellers(threadId, storeName)) ?? '';
      }
    }

    final metaUpdate = <String, dynamic>{
      'lastMessage': trimmed,
      'updatedAt': now.millisecondsSinceEpoch,
      'lastSenderUid': senderUid,
      if (sellerUid.isNotEmpty) 'sellerUid': sellerUid,
    };
    if (buyerUid.isNotEmpty && senderUid == buyerUid) {
      metaUpdate['buyerName'] = senderName;
    }

    await metaRef.update(metaUpdate);

    if (sellerUid.isNotEmpty) {
      await indexThreadForSeller(
        sellerUid: sellerUid,
        threadId: threadId,
        updatedAtMs: now.millisecondsSinceEpoch,
      );
    }
  }

  /// Cari penjual terdaftar di RTDB yang namanya cocok dengan toko di thread.
  static Future<String?> _linkThreadToRegisteredSellers(
    String threadId,
    String storeName,
  ) async {
    final snap = await _sellerAccountsRef.get();
    if (!snap.exists || snap.value is! Map) return null;

    for (final raw in (snap.value as Map).values) {
      if (raw is! Map) continue;
      final registeredStore = (raw['storeName'] as String?)?.trim() ?? '';
      final uid = (raw['uid'] as String?)?.trim() ?? '';
      if (uid.isEmpty || registeredStore.isEmpty) continue;
      if (!storeNamesMatch(registeredStore, storeName)) continue;

      await _chatsRef.child(threadId).child('meta').update({'sellerUid': uid});
      await indexThreadForSeller(sellerUid: uid, threadId: threadId);
      if (kDebugMode) {
        debugPrint('Thread $threadId → penjual $uid ($registeredStore)');
      }
      return uid;
    }
    return null;
  }

  static Future<ChatThreadMeta?> getThreadMeta(String threadId) async {
    final snap = await _chatsRef.child(threadId).child('meta').get();
    if (!snap.exists || snap.value is! Map) return null;
    return ChatThreadMeta.fromRtdb(
      threadId,
      Map<dynamic, dynamic>.from(snap.value as Map),
    );
  }

  static Future<ChatThreadMeta?> findThreadMetaByStore(String storeName) async {
    final snap = await _chatsRef.get();
    if (!snap.exists || snap.value is! Map) return null;
    final root = snap.value as Map;
    for (final entry in root.entries) {
      final raw = entry.value;
      if (raw is! Map) continue;
      final meta = raw['meta'];
      if (meta is! Map) continue;
      final m = ChatThreadMeta.fromRtdb(entry.key.toString(), meta);
      if (storeNamesMatch(m.sellerName, storeName)) return m;
    }
    return null;
  }

  /// Tautkan UID Firebase penjual ke thread yang sellerName-nya cocok.
  static Future<void> linkSellerUidForStore(
    String storeName,
    String sellerUid,
  ) async {
    final snap = await _chatsRef.get();
    if (!snap.exists || snap.value is! Map) return;

    final root = snap.value as Map;
    for (final entry in root.entries) {
      final raw = entry.value;
      if (raw is! Map) continue;
      final meta = raw['meta'];
      if (meta is! Map) continue;
      final name = meta['sellerName'] as String? ?? '';
      if (storeNamesMatch(name, storeName)) {
        final threadId = entry.key.toString();
        await _chatsRef.child(threadId).child('meta').update({
          'sellerUid': sellerUid,
        });
        await indexThreadForSeller(
          sellerUid: sellerUid,
          threadId: threadId,
          updatedAtMs: meta['updatedAt'] is int
              ? meta['updatedAt'] as int
              : DateTime.now().millisecondsSinceEpoch,
        );
      }
    }
  }
}
