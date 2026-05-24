import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Saldo poin & total lifetime (untuk level).
class LoyaltyPointsProvider extends ChangeNotifier {
  LoyaltyPointsProvider(this._prefs) {
    _restore();
  }

  final SharedPreferences _prefs;

  static const _kBalance = 'loyalty_balance_v1';
  static const _kLifetime = 'loyalty_lifetime_v1';
  static const _kRedemptions = 'loyalty_redemptions_v1';

  int _balance = 0;
  int _lifetimeEarned = 0;
  final List<Map<String, dynamic>> _redemptionLog = [];

  int get balance => _balance;
  int get lifetimeEarned => _lifetimeEarned;
  List<Map<String, dynamic>> get redemptionLog =>
      List.unmodifiable(_redemptionLog);

  void _restore() {
    _balance = _prefs.getInt(_kBalance) ?? 0;
    _lifetimeEarned = _prefs.getInt(_kLifetime) ?? 0;
    final raw = _prefs.getString(_kRedemptions);
    if (raw != null && raw.isNotEmpty) {
      try {
        final list = jsonDecode(raw) as List<dynamic>;
        _redemptionLog
          ..clear()
          ..addAll(list.map((e) => Map<String, dynamic>.from(e as Map)));
      } catch (_) {}
    }
    notifyListeners();
  }

  void _persist() {
    _prefs.setInt(_kBalance, _balance);
    _prefs.setInt(_kLifetime, _lifetimeEarned);
    _prefs.setString(_kRedemptions, jsonEncode(_redemptionLog));
  }

  /// Tambah poin setelah transaksi berhasil.
  int earnFromPurchase(int totalRupiah, {String? orderId}) {
    final earned = totalRupiah ~/ 1000;
    if (earned <= 0) return 0;
    _balance += earned;
    _lifetimeEarned += earned;
    _persist();
    notifyListeners();
    if (kDebugMode && orderId != null) {
      debugPrint('Loyalty +$earned for $orderId');
    }
    return earned;
  }

  /// Kode voucher poin yang sudah ditukar dan belum dipakai di checkout.
  List<String> unusedRedeemedVoucherCodes() {
    final codes = <String>[];
    for (final r in _redemptionLog) {
      if (r['usedAt'] != null) continue;
      final code = (r['voucherCode'] as String?)?.trim().toUpperCase() ?? '';
      if (code.isEmpty) continue;
      if (!codes.contains(code)) codes.add(code);
    }
    return codes;
  }

  bool isRedeemedVoucherAvailable(String code) {
    final norm = code.trim().toUpperCase();
    if (norm.isEmpty) return false;
    for (final r in _redemptionLog) {
      final c = (r['voucherCode'] as String?)?.trim().toUpperCase() ?? '';
      if (c != norm) continue;
      if (r['usedAt'] != null) return false;
      return true;
    }
    return false;
  }

  bool markVoucherUsed(String code, String orderId) {
    final norm = code.trim().toUpperCase();
    if (norm.isEmpty) return false;
    for (var i = 0; i < _redemptionLog.length; i++) {
      final r = _redemptionLog[i];
      final c = (r['voucherCode'] as String?)?.trim().toUpperCase() ?? '';
      if (c != norm) continue;
      if (r['usedAt'] != null) return false;
      _redemptionLog[i] = {
        ...r,
        'usedAt': DateTime.now().toIso8601String(),
        'usedOrderId': orderId,
      };
      _persist();
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Tukar poin dengan hadiah katalog.
  bool redeem({
    required String rewardId,
    required String title,
    required int pointCost,
    String? voucherCode,
  }) {
    if (pointCost <= 0 || _balance < pointCost) return false;
    _balance -= pointCost;
    _redemptionLog.insert(0, {
      'rewardId': rewardId,
      'title': title,
      'pointCost': pointCost,
      'redeemedAt': DateTime.now().toIso8601String(),
      'voucherCode': voucherCode,
    });
    _persist();
    notifyListeners();
    return true;
  }
}
