import 'dart:convert';
import 'dart:math' as math;

import 'package:http/http.dart' as http;

/// Model titik dari hasil pencarian Nominatim (OpenStreetMap).
class OsmPlace {
  OsmPlace({
    required this.title,
    required this.subtitle,
    required this.lat,
    required this.lon,
    required this.rawDisplayName,
  });

  final String title;
  final String subtitle;
  final double lat;
  final double lon;
  final String rawDisplayName;

  /// Jarak dari titik (fromLat, fromLon) ke POI ini (km).
  double distanceKmFrom(double fromLat, double fromLon) {
    return haversineKm(fromLat, fromLon, lat, lon);
  }

  /// Jarak haversine antara dua koordinat (km).
  static double haversineKm(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const r = 6371.0;
    final dLat = _rad(lat2 - lat1);
    final dLon = _rad(lon2 - lon1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_rad(lat1)) *
            math.cos(_rad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return r * c;
  }

  static double _rad(double d) => d * math.pi / 180.0;
}

/// Akses data OSM lewat [Nominatim](https://nominatim.org/release-docs/develop/api/Overview/).
/// Patuhi kebijakan penggunaan: User-Agent wajar, hindari spam request.
class OpenStreetMapNominatim {
  OpenStreetMapNominatim._();

  static const _base = 'https://nominatim.openstreetmap.org';

  /// Header wajib untuk Nominatim (identifikasi aplikasi).
  static const _headers = <String, String>{
    'User-Agent': 'PreLovedShopping/1.0 (Flutter; contact: local-app)',
    'Accept-Language': 'id,en',
  };

  /// Koordinat dari alamat bebas (forward geocoding), dibatasi Indonesia.
  static Future<OsmPlace?> geocodeAddress(
    String query, {
    String countryCodes = 'id',
  }) async {
    final q = query.trim();
    if (q.isEmpty) return null;

    final uri = Uri.parse(
      '$_base/search?format=jsonv2'
      '&q=${Uri.encodeComponent(q)}'
      '&limit=1'
      '&countrycodes=$countryCodes',
    );

    try {
      final res = await http.get(uri, headers: _headers);
      if (res.statusCode != 200) return null;

      final list = jsonDecode(res.body) as List<dynamic>;
      if (list.isEmpty) return null;

      final m = list.first as Map<String, dynamic>;
      final la = double.tryParse(m['lat']?.toString() ?? '');
      final lo = double.tryParse(m['lon']?.toString() ?? '');
      if (la == null || lo == null) return null;

      final full = m['display_name'] as String? ?? q;
      final parts = full.split(',').map((e) => e.trim()).toList();
      final title = parts.isNotEmpty ? parts.first : full;
      final subtitle = parts.length > 2
          ? '${parts[1]}, ${parts[2]}'
          : (parts.length > 1 ? parts[1] : full);

      return OsmPlace(
        title: title,
        subtitle: subtitle,
        lat: la,
        lon: lo,
        rawDisplayName: full,
      );
    } catch (_) {
      return null;
    }
  }

  /// Alamat teks dari koordinat (reverse geocoding).
  static Future<String?> reverseAddress(double lat, double lon) async {
    final uri = Uri.parse(
      '$_base/reverse?format=jsonv2&lat=$lat&lon=$lon',
    );
    try {
      final res = await http.get(uri, headers: _headers);
      if (res.statusCode != 200) return null;
      final j = jsonDecode(res.body) as Map<String, dynamic>;
      return j['display_name'] as String?;
    } catch (_) {
      return null;
    }
  }

  /// POI / tempat di sekitar (search dalam viewbox).
  static Future<List<OsmPlace>> searchNearby({
    required double lat,
    required double lon,
    double delta = 0.04,
    String query = 'shop supermarket mall',
    int limit = 12,
  }) async {
    final minLon = lon - delta;
    final maxLon = lon + delta;
    final minLat = lat - delta;
    final maxLat = lat + delta;
    final viewbox = '$minLon,$maxLat,$maxLon,$minLat';

    final uri = Uri.parse(
      '$_base/search?format=jsonv2'
      '&q=${Uri.encodeComponent(query)}'
      '&bounded=1'
      '&viewbox=$viewbox'
      '&limit=$limit',
    );

    try {
      final res = await http.get(uri, headers: _headers);
      if (res.statusCode != 200) return [];

      final list = jsonDecode(res.body) as List<dynamic>;
      final out = <OsmPlace>[];

      for (final item in list) {
        final m = item as Map<String, dynamic>;
        final la = double.tryParse(m['lat']?.toString() ?? '');
        final lo = double.tryParse(m['lon']?.toString() ?? '');
        if (la == null || lo == null) continue;

        final full = m['display_name'] as String? ?? 'Tempat';
        final parts = full.split(',').map((e) => e.trim()).toList();
        final title = parts.isNotEmpty ? parts.first : full;
        final subtitle = parts.length > 2
            ? '${parts[1]}, ${parts[2]}'
            : (parts.length > 1 ? parts[1] : full);

        out.add(
          OsmPlace(
            title: title,
            subtitle: subtitle,
            lat: la,
            lon: lo,
            rawDisplayName: full,
          ),
        );
      }
      return out;
    } catch (_) {
      return [];
    }
  }
}
