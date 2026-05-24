import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_branding.dart';
import '../models/seller_application.dart';
import '../providers/seller_applications_provider.dart';
import '../services/openstreetmap_nominatim.dart';
import '../utils/l10n_helpers.dart';

/// Peta satu titik toko — geocoding & tile OSM baru jalan setelah pengguna zoom/ketuk.
class StoreLocationMap extends StatefulWidget {
  const StoreLocationMap({
    super.key,
    required this.store,
    this.height = 200,
    this.autoActivate = false,
  });

  final SellerApplication store;
  final double height;

  /// Muat peta segera (halaman toko untuk pembeli).
  final bool autoActivate;

  @override
  State<StoreLocationMap> createState() => _StoreLocationMapState();
}

class _StoreLocationMapState extends State<StoreLocationMap> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    if (widget.autoActivate) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _activateMap());
    }
  }

  bool _mapActivated = false;
  bool _loading = false;
  double? _lat;
  double? _lng;
  String? _status;

  String get _addressLine =>
      '${widget.store.streetAddress}, ${widget.store.city}';

  void _activateMap() {
    if (_mapActivated) return;
    setState(() => _mapActivated = true);
    _resolveLocation();
  }

  Future<void> _resolveLocation() async {
    final loc = context.l10n;
    final lat = widget.store.latitude;
    final lng = widget.store.longitude;

    if (lat != null && lng != null) {
      if (!mounted) return;
      setState(() {
        _lat = lat;
        _lng = lng;
        _loading = false;
        _status = _addressLine;
      });
      return;
    }

    if (kIsWeb) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _status = loc.mapWebCorsHint;
      });
      return;
    }

    setState(() {
      _loading = true;
      _status = loc.mapGeocoding;
    });

    final place = await OpenStreetMapNominatim.geocodeAddress(
      '$_addressLine, Indonesia',
    );

    if (!mounted) return;

    if (place == null) {
      setState(() {
        _loading = false;
        _status = loc.mapAddressNotFound;
      });
      return;
    }

    await context.read<SellerApplicationsProvider>().updateSellerCoordinates(
          widget.store.id,
          place.lat,
          place.lon,
        );

    if (!mounted) return;
    setState(() {
      _lat = place.lat;
      _lng = place.lon;
      _loading = false;
      _status = place.rawDisplayName;
    });
  }

  Future<void> _openExternalMap() async {
    final lat = _lat;
    final lng = _lng;
    if (lat == null || lng == null) return;
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

  Widget _buildActivatePlaceholder(BuildContext context) {
    final loc = context.l10n;
    return GestureDetector(
      onTap: _activateMap,
      onScaleStart: (details) {
        if (details.pointerCount >= 2) _activateMap();
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: widget.height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.map_outlined,
              size: 40,
              color: Colors.grey.shade500,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _addressLine,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                loc.storeMapZoomHint,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapView() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        height: widget.height,
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: LatLng(_lat!, _lng!),
            initialZoom: 15,
            minZoom: 3,
            maxZoom: 18,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all,
            ),
            onMapReady: () {
              _mapController.move(LatLng(_lat!, _lng!), 15);
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.shopping',
              maxZoom: 19,
            ),
            MarkerLayer(
              markers: [
                Marker(
                  width: 44,
                  height: 44,
                  point: LatLng(_lat!, _lng!),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.storefront_rounded,
                    color: AppBranding.seedColor,
                    size: 40,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(
              Icons.location_on_rounded,
              size: 20,
              color: AppBranding.seedColor,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                loc.storeLocationTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            if (_lat != null && _lng != null)
              IconButton(
                onPressed: _openExternalMap,
                tooltip: loc.mapOpenOsmTooltip,
                icon: const Icon(Icons.open_in_new_rounded, size: 20),
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (!_mapActivated)
          _buildActivatePlaceholder(context)
        else if (_loading)
          SizedBox(
            height: widget.height,
            child: const Center(child: CircularProgressIndicator()),
          )
        else if (_lat == null || _lng == null)
          SizedBox(
            height: widget.height,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  _status ?? loc.mapAddressNotFound,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ),
            ),
          )
        else
          _buildMapView(),
        if (_mapActivated &&
            !_loading &&
            _status != null &&
            _lat != null) ...[
          const SizedBox(height: 6),
          Text(
            _status!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ],
    );
  }
}
