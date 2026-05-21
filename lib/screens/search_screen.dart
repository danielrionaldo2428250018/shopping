import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants/app_branding.dart';
import '../l10n/app_localizations.dart';
import '../services/gemini_product_search.dart';
import '../services/visual_product_search.dart';
import '../utils/loading_delay.dart';
import '../widgets/shimmer_widgets.dart';

/// Pencarian — teks, trending, riwayat, dan **foto (galeri / kamera + Gemini AI)**.
class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();

  final _trending = const <String>[];

  late List<String> _recent;

  @override
  void initState() {
    super.initState();
    _recent = [];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _showPhotoSourceSheet() async {
    final loc = AppLocalizations.of(context);
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                loc.searchWithPhoto,
                style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                loc.photoSearchSubtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.photo_library_outlined),
                ),
                title: Text(loc.chooseFromGallery),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImageAndSearch(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.photo_camera_outlined),
                ),
                title: Text(loc.takePhotoNow),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImageAndSearch(ImageSource.camera);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImageAndSearch(ImageSource source) async {
    final loc = AppLocalizations.of(context);
    if (source == ImageSource.gallery) {
      var photos = await Permission.photos.request();
      if (photos.isDenied) {
        photos = await Permission.photos.request();
      }
      if (!photos.isGranted && !photos.isLimited) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.galleryPermissionRequired)),
        );
        return;
      }
    } else {
      var cam = await Permission.camera.request();
      if (cam.isDenied) {
        cam = await Permission.camera.request();
      }
      if (!cam.isGranted) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.cameraPermissionRequired)),
        );
        return;
      }
    }

    final picker = ImagePicker();
    final x = await picker.pickImage(
      source: source,
      maxWidth: 1024,
      imageQuality: 88,
    );
    if (x == null || !mounted) return;

    if (!mounted) return;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => FullScreenShimmerLoading(
        title: loc.aiMatchingPhoto,
        subtitle: loc.aiMatchingSubtitle,
      ),
    );

    try {
      final bytes = await x.readAsBytes();
      String queryLabel = loc.genericPhotoSearch;
      List<String> ids;

      try {
        final gemini = await withMinimumLoadingDuration(
          GeminiProductSearch.searchByPhotoBytes(bytes),
          minDisplay: const Duration(milliseconds: 480),
        );
        final visual = await VisualProductSearch.rankByPhotoBytes(bytes);
        final merged = GeminiProductSearch.mergeWithVisualFallback(
          geminiIds: gemini.productIds,
          visualRanked: visual,
        );
        ids = merged.map((e) => e.id).toList();
        queryLabel = gemini.detectedName.isNotEmpty
            ? loc.photoSearchQuery(gemini.detectedName)
            : loc.genericPhotoSearch;
      } catch (_) {
        final ranked = await withMinimumLoadingDuration(
          VisualProductSearch.rankByPhotoBytes(bytes),
          minDisplay: const Duration(milliseconds: 480),
        );
        ids = ranked.map((e) => e.id).toList();
      }

      if (!mounted) return;
      Navigator.pop(context);
      Navigator.pushNamed(
        context,
        '/search-results',
        arguments: <String, dynamic>{
          'q': queryLabel,
          'imageRank': ids,
        },
      );
    } catch (e) {
      if (mounted) Navigator.pop(context);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.photoSearchFailed('$e'))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 16, 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEEEEE),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: loc.searchHint,
                          border: InputBorder.none,
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            color: Colors.grey,
                          ),
                        ),
                        onSubmitted: (q) {
                          final trimmed = q.trim();
                          if (trimmed.isEmpty) return;
                          setState(() {
                            _recent = [
                              trimmed,
                              ..._recent.where((e) => e != trimmed),
                            ];
                          });
                          Navigator.pushNamed(
                            context,
                            '/search-results',
                            arguments: trimmed,
                          );
                        },
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: loc.searchPhotoTooltip,
                    style: IconButton.styleFrom(
                      backgroundColor:
                          AppBranding.seedColor.withValues(alpha: 0.15),
                    ),
                    onPressed: _showPhotoSourceSheet,
                    icon: Icon(
                      Icons.photo_camera_rounded,
                      color: AppBranding.seedColor,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Material(
                color: Colors.white,
                elevation: 1,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: _showPhotoSourceSheet,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color:
                                AppBranding.seedColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            Icons.image_search_rounded,
                            size: 28,
                            color: AppBranding.seedColor,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                loc.searchWithPhoto,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                loc.photoSearchCardHint,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade700,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: Colors.grey.shade500,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.trending_up_rounded,
                        color: AppBranding.seedColor,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        loc.trendingNow,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  if (_trending.isEmpty)
                    Text(
                      loc.searchNoTrending,
                      style: TextStyle(color: Colors.grey.shade600),
                    )
                  else
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _trending
                          .map(
                            (t) => GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/search-results',
                                  arguments: t,
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: AppBranding.seedColor
                                      .withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  t,
                                  style: const TextStyle(
                                    color: AppBranding.seedColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        loc.recentSearches,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () => setState(() => _recent = []),
                        child: Text(
                          loc.clearAll,
                          style: const TextStyle(
                            color: AppBranding.seedColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (_recent.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Center(
                        child: Text(
                          loc.noRecentSearches,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                    )
                  else
                    ..._recent.map(
                      (term) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/product-detail',
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 14,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.history_rounded,
                                    color: Colors.grey.shade600,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      term,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.close_rounded,
                                      size: 20,
                                      color: Colors.grey.shade600,
                                    ),
                                    onPressed: () {
                                      setState(
                                        () => _recent.remove(term),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
