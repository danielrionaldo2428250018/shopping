import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../constants/fcm_config.dart';
import '../utils/store_name_match.dart';
import 'chat_rtdb_service.dart';
import 'push_notification_service.dart';

/// Push FCM chat: pembeli → topic toko; penjual → topic pembeli.
abstract final class ChatSellerNotify {
  static String sellerTopic(String storeName) {
    final slug = storeNameSlug(storeName);
    return '${FcmConfig.sellerTopicPrefix}${slug.isEmpty ? 'store' : slug}';
  }

  static String buyerTopic(String buyerUid) {
    final id = buyerUid.trim();
    return '${FcmConfig.buyerTopicPrefix}${id.isEmpty ? 'guest' : id}';
  }

  /// Penjual subscribe topic FCM khusus tokonya (panggil setelah login sebagai seller).
  static Future<void> subscribeSellerStore(String storeName) async {
    final topic = sellerTopic(storeName);
    try {
      await FirebaseMessaging.instance.subscribeToTopic(topic);
      if (kDebugMode) debugPrint('FCM subscribe seller topic: $topic');
    } catch (e) {
      if (kDebugMode) debugPrint('FCM subscribe seller gagal: $e');
    }
  }

  static Future<void> unsubscribeSellerStore(String storeName) async {
    try {
      await FirebaseMessaging.instance
          .unsubscribeFromTopic(sellerTopic(storeName));
    } catch (_) {}
  }

  /// Pembeli subscribe topic FCM pribadi (balasan penjual).
  static Future<void> subscribeBuyer(String buyerUid) async {
    final topic = buyerTopic(buyerUid);
    try {
      await FirebaseMessaging.instance.subscribeToTopic(topic);
      if (kDebugMode) debugPrint('FCM subscribe buyer topic: $topic');
    } catch (e) {
      if (kDebugMode) debugPrint('FCM subscribe buyer gagal: $e');
    }
  }

  static Future<void> unsubscribeBuyer(String buyerUid) async {
    try {
      await FirebaseMessaging.instance.unsubscribeFromTopic(buyerTopic(buyerUid));
    } catch (_) {}
  }

  /// Simpan UID penjual di semua thread toko ini (agar daftar obrolan cocok).
  static Future<void> linkSellerUid({
    required String storeName,
    required String sellerUid,
  }) async {
    await ChatRtdbService.registerSellerAccount(
      storeName: storeName,
      sellerUid: sellerUid,
    );
    await ChatRtdbService.linkSellerUidForStore(storeName, sellerUid);
  }

  /// Kirim push + notifikasi lokal ke topic penjual (pembeli mengirim pesan).
  static Future<void> notifySeller({
    required String storeName,
    required String buyerName,
    required String messagePreview,
  }) async {
    final title = buyerName.trim().isNotEmpty ? buyerName : 'Pembeli';
    final body = messagePreview.length > 120
        ? '${messagePreview.substring(0, 117)}...'
        : messagePreview;

    final push = await sendNotificationToTopicDetailed(
      topic: sellerTopic(storeName),
      title: 'Pesan baru — $title',
      body: body,
      senderName: title,
      data: {
        'type': 'chat',
        'title': 'Pesan baru — $title',
        'body': body,
        'senderName': title,
      },
    );
    if (kDebugMode && !push.ok) {
      debugPrint('ChatSellerNotify seller gagal: ${push.error}');
    }
  }

  /// Kirim push ke topic pembeli (penjual membalas).
  static Future<void> notifyBuyer({
    required String buyerUid,
    required String storeName,
    required String messagePreview,
  }) async {
    if (buyerUid.trim().isEmpty) return;

    final title = storeName.trim().isNotEmpty ? storeName.trim() : 'Penjual';
    final body = messagePreview.length > 120
        ? '${messagePreview.substring(0, 117)}...'
        : messagePreview;

    final push = await sendNotificationToTopicDetailed(
      topic: buyerTopic(buyerUid),
      title: 'Pesan baru — $title',
      body: body,
      senderName: title,
      data: {
        'type': 'chat',
        'title': 'Pesan baru — $title',
        'body': body,
        'senderName': title,
      },
    );
    if (kDebugMode && !push.ok) {
      debugPrint('ChatSellerNotify buyer gagal: ${push.error}');
    }
  }
}
