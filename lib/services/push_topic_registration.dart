import 'package:flutter/foundation.dart';

import 'app_notifications.dart';
import 'chat_seller_notify.dart';

/// Daftarkan topic FCM pembeli + toko penjual setelah login / Firebase siap.
Future<void> registerUserPushTopics({
  String? buyerUid,
  Iterable<String> sellerStoreNames = const [],
}) async {
  await requestFcmNotificationPermission();

  final uid = buyerUid?.trim() ?? '';
  if (uid.isNotEmpty) {
    await ChatSellerNotify.subscribeBuyer(uid);
  }

  final seen = <String>{};
  for (final raw in sellerStoreNames) {
    final name = raw.trim();
    if (name.isEmpty) continue;
    final key = name.toLowerCase();
    if (!seen.add(key)) continue;
    await ChatSellerNotify.subscribeSellerStore(name);
  }

  if (kDebugMode) {
    debugPrint(
      'Push topics: buyer=${uid.isNotEmpty} sellerStores=${seen.length}',
    );
  }
}
