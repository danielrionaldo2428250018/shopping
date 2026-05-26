/// Konfigurasi FCM + REST API [shopping-cloud] (pola sama fasum-cloud / fasum).
abstract final class FcmConfig {
  /// Topic yang disubscribe di [app_notifications.dart] (broadcast umum).
  static const String topic = 'preloved-shopping';

  /// Awalan topic per toko: `preloved-seller-{slug}` — penjual subscribe saat login.
  static const String sellerTopicPrefix = 'preloved-seller-';

  /// Awalan topic per pembeli: `preloved-buyer-{uid}` — subscribe setelah login.
  static const String buyerTopicPrefix = 'preloved-buyer-';

  /// URL deploy Vercel shopping-cloud (production).
  static const String cloudApiBaseUrl = 'https://shopping-cloud.vercel.app';

  static const String defaultSenderName = 'SECO';
}
