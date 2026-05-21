/// Satu sumber konfigurasi Firebase untuk app + RTDB + FCM.
abstract final class FirebaseProjectConfig {
  /// Proyek utama app (sama `android/app/google-services.json` & RTDB).
  static const String appProjectId = 'project-uas-44504';

  static const String appMessagingSenderId = '197173737037';

  static const String appStorageBucket =
      'project-uas-44504.firebasestorage.app';

  static const String rtdbProjectId = 'project-uas-44504';

  static const String rtdbDatabaseUrl =
      'https://project-uas-44504-default-rtdb.asia-southeast1.firebasedatabase.app';

  /// shopping-cloud di Vercel memakai service account proyek ini.
  static const String cloudProjectId = 'project-uas-44504';
}
