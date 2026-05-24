import '../config/firebase_project_config.dart';

/// Realtime Database **Project Uas** (sama region dengan console Firebase Anda).
abstract final class FirebaseRtdbConfig {
  static const String projectId = FirebaseProjectConfig.rtdbProjectId;

  static const String databaseUrl = FirebaseProjectConfig.rtdbDatabaseUrl;

  /// Node utama daftar barang di RTDB.
  static const String productsPath = 'products';

  /// Obrolan pembeli ↔ penjual: `chats/{threadId}/meta` + `messages`.
  static const String chatsPath = 'chats';

  /// Pemetaan nama toko → UID penjual (set saat penjual login).
  static const String sellerAccountsPath = 'sellerAccounts';

  /// Indeks thread obrolan per UID penjual: `sellerThreads/{uid}/{threadId}`.
  static const String sellerThreadsPath = 'sellerThreads';

  /// Pesanan pembeli: `buyerOrders/{buyerUid}/{orderId}`.
  static const String buyerOrdersPath = 'buyerOrders';

  /// Pesanan penjual: `sellerOrders/{sellerUid}/{orderId}`.
  static const String sellerOrdersPath = 'sellerOrders';

  /// Cadangan indeks per slug toko: `sellerOrdersByStore/{slug}/{orderId}`.
  static const String sellerOrdersByStorePath = 'sellerOrdersByStore';
}
