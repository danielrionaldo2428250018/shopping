import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../constants/fcm_config.dart';
import '../utils/store_name_match.dart';
import 'chat_rtdb_service.dart';
import 'push_notification_service.dart';

/// Notifikasi ke pemilik toko saat pembeli mengirim pesan.
abstract final class ChatSellerNotify {
  static String sellerTopic(String storeName) {
    final slug = storeNameSlug(storeName);
    return '${FcmConfig.sellerTopicPrefix}${slug.isEmpty ? 'store' : slug}';
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

    await sendNotificationToTopic(
      topic: sellerTopic(storeName),
      title: 'Pesan baru — $title',
      body: body,
      senderName: title,
    );
  }
}
