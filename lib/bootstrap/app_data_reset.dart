import 'package:shared_preferences/shared_preferences.dart';

/// Sekali jalan: kosongkan pesanan, favorit, ulasan demo di perangkat.
Future<void> runAppDataResetIfNeeded(SharedPreferences prefs) async {
  const flag = 'app_reset_orders_wishlist_v5';
  if (prefs.getBool(flag) == true) return;

  await prefs.remove('orders_data_v1');
  await prefs.remove('orders_next_id_v1');
  await prefs.remove('wishlist_ids_v1');
  await prefs.setStringList('wishlist_ids_v1', []);
  await prefs.remove('user_reviews_v1');

  await prefs.setBool(flag, true);
}
