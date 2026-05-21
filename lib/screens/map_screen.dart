import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_branding.dart';
import '../models/seller_application.dart';
import '../providers/seller_applications_provider.dart';
import '../services/openstreetmap_nominatim.dart';
import '../utils/l10n_helpers.dart';
import 'seller_store_screen.dart';

/// Peta OSM + titik **toko penjual terdaftar** (geocoding alamat pengajuan)
/// dan POI sekitar dari Nominatim.
class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _searchCtrl = TextEditingController();

  SellerApplicationsProvider? _sellerAppsSub;

  bool _loading = true;
  bool _loadingPlaces = false;
  bool _loadingSellers = false;
  bool _locationGranted = false;
  String _status = '';
  double? _lat;
  double? _lng;

  List<OsmPlace> _places = [];

  /// Pengajuan yang sudah disetujui tetapi geocoding gagal (alamat tidak ketemu).
  final Set<String> _geocodeFailedIds = {};

  bool _sellerSyncBusy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initLocation());
  }

  @override
  void dispose() {
    _sellerAppsSub?.removeListener(_onSellerApplicationsChanged);
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSellerApplicationsChanged() {
    if (_lat != null && _lng != null) {
      _syncRegisteredSellerPins();
    }
  }

  Future<void> _syncRegisteredSellerPins() async {
    if (!mounted || kIsWeb || _sellerSyncBusy) return;

    final provider =
        Provider.of<SellerApplicationsProvider>(context, listen: false);
    final needLookup = provider.approved
        .where(
          (a) =>
              (a.latitude == null || a.longitude == null) &&
              !_geocodeFailedIds.contains(a.id),
        )
        .toList();

    if (needLookup.isEmpty) return;

    _sellerSyncBusy = true;
    setState(() => _loadingSellers = true);

    try {
      for (final app in needLookup) {
        await Future<void>.delayed(const Duration(milliseconds: 1100));
        if (!mounted) return;

        final q = '${app.streetAddress}, ${app.city}, Indonesia';
        final place = await OpenStreetMapNominatim.geocodeAddress(q);

        if (!mounted) return;

        if (place != null) {
          await provider.updateSellerCoordinates(app.id, place.lat, place.lon);
        } else {
          setState(() => _geocodeFailedIds.add(app.id));
        }
      }
    } finally {
      _sellerSyncBusy = false;
      if (mounted) setState(() => _loadingSellers = false);
    }
  }

  Future<void> _loadOsmData(double lat, double lon) async {
    final loc = context.l10n;
    setState(() => _loadingPlaces = true);

    if (kIsWeb) {
      setState(() {
        _places = [];
        _status = loc.mapWebCorsHint;
        _loadingPlaces = false;
      });
      await _syncRegisteredSellerPins();
      return;
    }

    try {
      final addr =
          await OpenStreetMapNominatim.reverseAddress(lat, lon);
      if (!mounted) return;
      setState(() {
        if (addr != null && addr.isNotEmpty) {
          _status = addr;
        }
      });

      await Future<void>.delayed(const Duration(seconds: 1));

      var list = await OpenStreetMapNominatim.searchNearby(
        lat: lat,
        lon: lon,
        query: _searchCtrl.text.trim().isEmpty
            ? 'shop supermarket mall'
            : _searchCtrl.text.trim(),
      );

      if (list.isEmpty) {
        list = await OpenStreetMapNominatim.searchNearby(
          lat: lat,
          lon: lon,
          query: 'restaurant cafe',
        );
      }

      if (!mounted) return;
      setState(() {
        _places = list;
        _loadingPlaces = false;
      });

      _mapController.move(LatLng(lat, lon), 14);

      await _syncRegisteredSellerPins();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadingPlaces = false;
        _status = loc.mapLoadOsmFailed;
      });
      await _syncRegisteredSellerPins();
    }
  }

  Future<void> _initLocation() async {
    final loc = context.l10n;
    setState(() {
      _loading = true;
      _status = loc.mapRequestingLocation;
    });

    var perm = await Permission.locationWhenInUse.request();
    if (perm.isDenied) {
      perm = await Permission.locationWhenInUse.request();
    }

    _locationGranted = perm.isGranted || perm.isLimited;

    const jakarta = LatLng(-6.2088, 106.8456);

    if (!_locationGranted) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _lat = jakarta.latitude;
        _lng = jakarta.longitude;
        _status = loc.mapLocationDeniedFallback;
      });
      await _loadOsmData(jakarta.latitude, jakarta.longitude);
      return;
    }

    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _lat = jakarta.latitude;
        _lng = jakarta.longitude;
        _status = loc.mapGpsOffFallback;
      });
      await _loadOsmData(jakarta.latitude, jakarta.longitude);
      return;
    }

    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );
      if (!mounted) return;
      setState(() {
        _loading = false;
        _lat = pos.latitude;
        _lng = pos.longitude;
        _status = loc.mapCoords(
          '${pos.latitude.toStringAsFixed(5)}, ${pos.longitude.toStringAsFixed(5)}',
        );
      });
      await _loadOsmData(pos.latitude, pos.longitude);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _lat = jakarta.latitude;
        _lng = jakarta.longitude;
        _status = loc.mapGpsFailedFallback;
      });
      await _loadOsmData(jakarta.latitude, jakarta.longitude);
    }
  }

  Future<void> _openInBrowserMaps() async {
    final lat = _lat ?? -6.2088;
    final lng = _lng ?? 106.8456;
    final uri = Uri.parse(
      'https://www.openstreetmap.org/?mlat=$lat&mlon=$lng#map=16/$lat/$lng',
    );
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.cannotOpenBrowser)),
      );
    }
  }

  Future<void> _submitSearch() async {
    if (_lat == null || _lng == null) return;
    FocusScope.of(context).unfocus();
    await _loadOsmData(_lat!, _lng!);
  }

  List<SellerApplication> _sellersWithCoords(
    SellerApplicationsProvider prov,
  ) {
    return prov.approved
        .where(
          (a) => a.latitude != null && a.longitude != null,
        )
        .toList();
  }

  List<Marker> _buildMarkers(
    LatLng center,
    List<SellerApplication> sellersOnMap,
  ) {
    final markers = <Marker>[];

    if (_locationGranted && _lat != null && _lng != null) {
      markers.add(
        Marker(
          width: 44,
          height: 44,
          point: LatLng(_lat!, _lng!),
          alignment: Alignment.center,
          child: const Icon(
            Icons.person_pin_circle,
            color: Color(0xFF2196F3),
            size: 40,
          ),
        ),
      );
    }

    for (final s in sellersOnMap) {
      markers.add(
        Marker(
          width: 42,
          height: 42,
          point: LatLng(s.latitude!, s.longitude!),
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                SellerStoreScreen.route,
                arguments: s.storeName,
              );
            },
            child: Icon(
              Icons.storefront_rounded,
              color: AppBranding.seedColor,
              size: 38,
            ),
          ),
        ),
      );
    }

    for (final p in _places) {
      markers.add(
        Marker(
          width: 38,
          height: 38,
          point: LatLng(p.lat, p.lon),
          alignment: Alignment.center,
          child: Icon(
            Icons.store_mall_directory_rounded,
            color: Colors.grey.shade700,
            size: 34,
          ),
        ),
      );
    }

    if (markers.isEmpty) {
      markers.add(
        Marker(
          width: 40,
          height: 40,
          point: center,
          alignment: Alignment.center,
          child: Icon(
            Icons.place_rounded,
            color: Colors.red.shade400,
            size: 36,
          ),
        ),
      );
    }

    return markers;
  }

  Widget _buildMap(List<SellerApplication> sellersOnMap) {
    if (_lat == null || _lng == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white54),
      );
    }

    final center = LatLng(_lat!, _lng!);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: center,
          initialZoom: 14,
          minZoom: 3,
          maxZoom: 19,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.shopping',
            maxZoom: 19,
          ),
          MarkerLayer(markers: _buildMarkers(center, sellersOnMap)),
          RichAttributionWidget(
            alignment: AttributionAlignment.bottomRight,
            attributions: [
              TextSourceAttribution(
                '© OpenStreetMap',
                onTap: () => launchUrl(
                  Uri.parse('https://www.openstreetmap.org/copyright'),
                  mode: LaunchMode.externalApplication,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;
    final sellerApps = context.watch<SellerApplicationsProvider>();
    if (_sellerAppsSub == null) {
      _sellerAppsSub = sellerApps;
      sellerApps.addListener(_onSellerApplicationsChanged);
    }

    final sellersOnMap = _sellersWithCoords(sellerApps);
    final approvedAll = sellerApps.approved;
    final sellersFailed = approvedAll
        .where((a) => _geocodeFailedIds.contains(a.id))
        .toList();

    return Scaffold(
      backgroundColor: AppBranding.scaffoldLight,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: AppBranding.authGradient,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.mapSellersTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    loc.mapLegendHint,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.88),
                      fontSize: 11,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (_loading)
                    const LinearProgressIndicator(
                      backgroundColor: Colors.white24,
                      color: Colors.white,
                    )
                  else
                    Text(
                      _status,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.92),
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                  if (_loadingPlaces || _loadingSellers)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        _loadingSellers
                            ? loc.mapSearchingSellers
                            : loc.mapLoadingNominatim,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 11,
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  Text(
                    loc.mapOsmAttribution,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 11,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: TextField(
                      controller: _searchCtrl,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => _submitSearch(),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.search_rounded,
                          color: Colors.grey.shade600,
                          size: 22,
                        ),
                        hintText: loc.mapSearchPlacesHint,
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 13,
                        ),
                        suffixIcon: IconButton(
                          onPressed: _submitSearch,
                          icon: const Icon(Icons.arrow_forward_rounded),
                          color: AppBranding.seedColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A2744),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: _loading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white54,
                            ),
                          )
                        : _buildMap(sellersOnMap),
                  ),
                  Positioned(
                    right: 12,
                    bottom: 12,
                    child: Material(
                      color: Colors.white,
                      elevation: 4,
                      shape: const CircleBorder(),
                      child: IconButton(
                        onPressed: _openInBrowserMaps,
                        icon: const Icon(Icons.open_in_browser_rounded),
                        color: AppBranding.seedColor,
                        tooltip: loc.mapOpenOsmTooltip,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x12000000),
                    blurRadius: 12,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Center(
                    child: Container(
                      width: 48,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      children: [
                        Text(
                          '${loc.nearbyStores} (${approvedAll.length})',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          loc.mapVerifiedSellers,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (approvedAll.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              loc.mapNoVerifiedSellers,
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          )
                        else ...[
                          ...approvedAll.map((s) {
                            final hasCoord =
                                s.latitude != null && s.longitude != null;
                            final km = hasCoord && _lat != null && _lng != null
                                ? OsmPlace.haversineKm(
                                    _lat!,
                                    _lng!,
                                    s.latitude!,
                                    s.longitude!,
                                  )
                                : null;
                            final failed = _geocodeFailedIds.contains(s.id);
                            final waitingGeo =
                                !hasCoord && !failed;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Material(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      SellerStoreScreen.route,
                                      arguments: s.storeName,
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: AppBranding.seedColor
                                                .withValues(alpha: 0.12),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Icon(
                                            Icons.storefront_rounded,
                                            color: AppBranding.seedColor,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                s.storeName,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '${s.streetAddress}, ${s.city}',
                                                style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              if (hasCoord && km != null)
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.near_me_outlined,
                                                      size: 14,
                                                      color: AppBranding
                                                          .seedColor,
                                                    ),
                                                    Text(
                                                      ' ${loc.mapDistanceFromYou(km.toStringAsFixed(1))}',
                                                      style: TextStyle(
                                                        color: Colors
                                                            .grey.shade700,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              else if (failed)
                                                Text(
                                                  loc.mapAddressNotFound,
                                                  style: TextStyle(
                                                    color:
                                                        Colors.orange.shade800,
                                                    fontSize: 12,
                                                  ),
                                                )
                                              else if (waitingGeo && kIsWeb)
                                                Text(
                                                  loc.mapPinMobileOnly,
                                                  style: TextStyle(
                                                    color:
                                                        Colors.grey.shade600,
                                                    fontSize: 12,
                                                  ),
                                                )
                                              else if (waitingGeo &&
                                                  _loadingSellers)
                                                Text(
                                                  loc.mapGeocoding,
                                                  style: TextStyle(
                                                    color:
                                                        Colors.grey.shade600,
                                                    fontSize: 12,
                                                  ),
                                                )
                                              else if (waitingGeo)
                                                Text(
                                                  loc.mapAwaitingGeocode,
                                                  style: TextStyle(
                                                    color:
                                                        Colors.grey.shade600,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                          if (sellersFailed.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              loc.mapSomeAddressesFailed,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ],
                        const SizedBox(height: 20),
                        Text(
                          loc.mapNearbyPlaces(_places.length),
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (_places.isEmpty && !_loadingPlaces)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              kIsWeb
                                  ? loc.mapWebNominatimUnavailable
                                  : loc.mapNoOsmResults,
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          )
                        else
                          ..._places.map((p) {
                            final km = _lat != null && _lng != null
                                ? p.distanceKmFrom(_lat!, _lng!)
                                : 0.0;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.grey.shade200,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.place_outlined,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          p.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          p.subtitle,
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.near_me_outlined,
                                              size: 14,
                                              color: Colors.grey.shade700,
                                            ),
                                            Text(
                                              ' ~${km.toStringAsFixed(1)} km',
                                              style: TextStyle(
                                                color: Colors.grey.shade700,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
