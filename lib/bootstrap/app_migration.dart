import 'package:shared_preferences/shared_preferences.dart';

/// Migrasi data lokal — jalankan saat versi skema naik agar build baru benar-benar terpakai.
Future<void> runAppMigrations(SharedPreferences prefs) async {
  const currentSchema = 6;
  final stored = prefs.getInt('app_schema_version') ?? 0;
  if (stored >= currentSchema) return;

  await prefs.remove('orders_data_v1');
  await prefs.remove('orders_next_id_v1');
  await prefs.remove('wishlist_ids_v1');
  await prefs.setStringList('wishlist_ids_v1', <String>[]);
  await prefs.remove('user_reviews_v1');

  // Flag lama (v4/v5) tetap ditandai agar tidak dobel-reset.
  await prefs.setBool('app_reset_orders_wishlist_v4', true);
  await prefs.setBool('app_reset_orders_wishlist_v5', true);

  await prefs.setInt('app_schema_version', currentSchema);
}

/// Paksa ulang migrasi (mis. dari Pengaturan) — butuh restart app.
Future<void> forceLocalDataReset(SharedPreferences prefs) async {
  await prefs.setInt('app_schema_version', 0);
  await runAppMigrations(prefs);
}
