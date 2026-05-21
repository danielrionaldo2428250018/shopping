import '../config/firebase_project_config.dart';

/// Realtime Database **Project Uas** (sama region dengan console Firebase Anda).
abstract final class FirebaseRtdbConfig {
  static const String projectId = FirebaseProjectConfig.rtdbProjectId;

  static const String databaseUrl = FirebaseProjectConfig.rtdbDatabaseUrl;

  /// Node utama daftar barang di RTDB.
  static const String productsPath = 'products';
}
