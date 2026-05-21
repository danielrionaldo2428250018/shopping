/// Konfigurasi FCM + REST API [shopping-cloud] (pola sama fasum-cloud / fasum).
abstract final class FcmConfig {
  /// Topic yang disubscribe di [app_notifications.dart].
  static const String topic = 'preloved-shopping';

  /// URL deploy Vercel shopping-cloud (ganti setelah deploy).
  static const String cloudApiBaseUrl = 'https://shopping-cloud-vert.vercel.app';

  static const String defaultSenderName = 'PreLoved';
}
