import 'package:flutter/foundation.dart';

import '../data/catalog_data.dart' show formatIdr;
import 'chat_seller_notify.dart';
import 'push_notification_service.dart';

/// Push + data FCM ke penjual saat ada pesanan baru (pola fasum / chat).
abstract final class OrderSellerNotify {
  static Future<void> notifyNewOrder({
    required String storeName,
    required String orderId,
    required String buyerName,
    required String productTitle,
    required int total,
  }) async {
    final store = storeName.trim();
    if (store.isEmpty) return;

    final buyer = buyerName.trim().isNotEmpty ? buyerName.trim() : 'Pembeli';
    final product = productTitle.trim().isNotEmpty ? productTitle : 'produk';
    final title = 'Pesanan baru — $orderId';
    final body = '$buyer memesan $product (${formatIdr(total)})';

    final push = await sendNotificationToTopicDetailed(
      topic: ChatSellerNotify.sellerTopic(store),
      title: title,
      body: body,
      senderName: buyer,
      data: {
        'type': 'order',
        'orderId': orderId,
        'title': title,
        'body': body,
        'senderName': buyer,
      },
    );
    if (kDebugMode && !push.ok) {
      debugPrint('OrderSellerNotify gagal: ${push.error}');
    }
  }
}
