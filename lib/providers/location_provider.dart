import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/openstreetmap_nominatim.dart';

/// Lokasi pengguna (ringkas): koordinat + kota, disimpan lokal.
///
/// Dipakai untuk opsi pengiriman "Ambil sendiri" (hanya 1 kota).
class LocationProvider extends ChangeNotifier {
  LocationProvider(this._prefs) {
    _load();
  }

  final SharedPreferences _prefs;

  static const _kLat = 'user_loc_lat_v1';
  static const _kLon = 'user_loc_lon_v1';
  static const _kCity = 'user_loc_city_v1';
  static const _kUpdatedAt = 'user_loc_updated_at_v1';

  double? _lat;
  double? _lon;
  String _city = '';
  DateTime? _updatedAt;

  double? get lat => _lat;
  double? get lon => _lon;
  String get city => _city;
  DateTime? get updatedAt => _updatedAt;

  bool get hasCity => _city.trim().isNotEmpty;

  void _load() {
    _lat = _prefs.getDouble(_kLat);
    _lon = _prefs.getDouble(_kLon);
    _city = _prefs.getString(_kCity) ?? '';
    final ms = _prefs.getInt(_kUpdatedAt);
    _updatedAt = ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms);
  }

  Future<bool> refreshIfPermitted({Duration maxAge = const Duration(hours: 12)}) async {
    final perm = await Permission.locationWhenInUse.status;
    if (!perm.isGranted && !perm.isLimited) return false;

    if (_updatedAt != null && DateTime.now().difference(_updatedAt!) <= maxAge) {
      return hasCity;
    }

    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );

      final addr = await OpenStreetMapNominatim.reverseAddress(
        pos.latitude,
        pos.longitude,
      );
      final city = _inferCity(addr ?? '');

      _lat = pos.latitude;
      _lon = pos.longitude;
      _city = city;
      _updatedAt = DateTime.now();
      _prefs.setDouble(_kLat, _lat!);
      _prefs.setDouble(_kLon, _lon!);
      _prefs.setString(_kCity, _city);
      _prefs.setInt(_kUpdatedAt, _updatedAt!.millisecondsSinceEpoch);
      notifyListeners();
      return hasCity;
    } catch (e) {
      if (kDebugMode) debugPrint('LocationProvider refresh: $e');
      return false;
    }
  }

  /// Minta izin lokasi lalu refresh (dipakai saat transaksi).
  Future<bool> requestAndRefresh() async {
    final st = await Permission.locationWhenInUse.request();
    if (!st.isGranted && !st.isLimited) return false;
    return refreshIfPermitted(maxAge: Duration.zero);
  }

  static String _inferCity(String displayName) {
    final raw = displayName.trim();
    if (raw.isEmpty) return '';
    final parts = raw.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return '';

    // Heuristik Nominatim Indonesia: cari bagian yang mengandung Kota/Kabupaten.
    for (final p in parts.reversed) {
      final low = p.toLowerCase();
      if (low.contains('kota ') || low.startsWith('kota')) return p;
      if (low.contains('kabupaten') || low.startsWith('kab.')) return p;
      if (low.contains('city') || low.contains('regency')) return p;
    }

    // Fallback: ambil komponen yang biasanya kota (2-4 posisi dari belakang).
    if (parts.length >= 3) return parts[parts.length - 3];
    return parts.last;
  }

  static String normCity(String city) =>
      city.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

  bool isSameCity(String otherCity) {
    final a = normCity(city);
    final b = normCity(otherCity);
    if (a.isEmpty || b.isEmpty) return false;
    return a == b || a.contains(b) || b.contains(a);
  }
}

