import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/reward_catalog_item.dart';

/// Katalog hadiah / voucher — admin bisa tambah, ubah, nonaktifkan.
class RewardsCatalogProvider extends ChangeNotifier {
  RewardsCatalogProvider(this._prefs) {
    _restoreOrSeed();
  }

  final SharedPreferences _prefs;
  static const _kCatalog = 'rewards_catalog_v1';

  final List<RewardCatalogItem> _items = [];

  List<RewardCatalogItem> get items => List.unmodifiable(_items);

  List<RewardCatalogItem> get activeItems =>
      _items.where((e) => e.active).toList();

  void _restoreOrSeed() {
    final raw = _prefs.getString(_kCatalog);
    if (raw != null && raw.isNotEmpty) {
      try {
        final list = jsonDecode(raw) as List<dynamic>;
        _items
          ..clear()
          ..addAll(
            list.map(
              (e) => RewardCatalogItem.fromJson(
                e as Map<String, dynamic>,
              ),
            ),
          );
        notifyListeners();
        return;
      } catch (_) {}
    }
    _seed();
    _persist();
  }

  void _seed() {
    _items.addAll([
      const RewardCatalogItem(
        id: 'voucher-ongkir-50',
        title: 'Voucher ongkir Rp 15.000',
        description: 'Potongan ongkir untuk 1x checkout (min. belanja Rp 100rb).',
        pointCost: 150,
        voucherCode: 'POINONGKIR15',
      ),
      const RewardCatalogItem(
        id: 'voucher-diskon-10',
        title: 'Diskon 10% (maks Rp 50rb)',
        description: 'Berlaku untuk kategori Fashion & Electronics.',
        pointCost: 300,
        voucherCode: 'POIN10OFF',
      ),
      const RewardCatalogItem(
        id: 'voucher-eco-bag',
        title: 'Tas belanja ramah lingkungan',
        description: 'Ambil di event PreLoved atau kirim ke alamat profil.',
        pointCost: 500,
      ),
      const RewardCatalogItem(
        id: 'voucher-premium',
        title: 'Gratis biaya layanan 1 bulan',
        description: 'Untuk member setia — tanpa biaya admin penjual.',
        pointCost: 1200,
        voucherCode: 'POINVIP1M',
      ),
    ]);
  }

  void _persist() {
    _prefs.setString(
      _kCatalog,
      jsonEncode(_items.map((e) => e.toJson()).toList()),
    );
  }

  void addItem(RewardCatalogItem item) {
    _items.add(item);
    _persist();
    notifyListeners();
  }

  void updateItem(RewardCatalogItem item) {
    final i = _items.indexWhere((e) => e.id == item.id);
    if (i < 0) return;
    _items[i] = item;
    _persist();
    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((e) => e.id == id);
    _persist();
    notifyListeners();
  }

  void setActive(String id, bool active) {
    final i = _items.indexWhere((e) => e.id == id);
    if (i < 0) return;
    _items[i] = _items[i].copyWith(active: active);
    _persist();
    notifyListeners();
  }
}
