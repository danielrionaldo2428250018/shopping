import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../utils/data_image_cache.dart';
import '../utils/green_computing.dart';

Uint8List? _decodeDataUrlBytes(String dataUrl) {
  try {
    final i = dataUrl.indexOf(',');
    if (i < 0) return null;
    return base64Decode(dataUrl.substring(i + 1));
  } catch (_) {
    return null;
  }
}

/// Gambar jaringan dengan decode memori terbatas — hemat RAM di HP kecil.
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.filterQuality = FilterQuality.low,
    this.memCacheWidth,
    this.lazyLoadLargeDataUrl = true,
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final FilterQuality filterQuality;

  /// Override lebar decode; null = dihitung dari [width] + DPR.
  final int? memCacheWidth;

  /// Jika `true`, data-URL yang sangat besar tidak akan langsung di-decode.
  /// Pengguna bisa tap untuk memuat (menghindari GC berat / UI freeze).
  final bool lazyLoadLargeDataUrl;

  @override
  Widget build(BuildContext context) {
    final w = width;
    final h = height;
    final effectiveLogicalWidth = (w != null && w.isFinite && w > 0) ? w : null;

    Widget child;
    final trimmed = url.trim();
    if (trimmed.isEmpty) {
      child = _placeholder(w, h);
    } else if (trimmed.startsWith('data:image')) {
      final shouldLazy = lazyLoadLargeDataUrl && trimmed.length > 28000;
      child = _DataUrlImage(
        dataUrl: trimmed,
        width: w,
        height: h,
        fit: fit,
        filterQuality: filterQuality,
        memCacheWidth: memCacheWidth ??
            (effectiveLogicalWidth != null
                ? GreenComputing.memCacheWidth(context, effectiveLogicalWidth)
                : null),
        autoLoad: !shouldLazy,
      );
    } else {
      final cacheW = memCacheWidth ??
          (effectiveLogicalWidth != null
              ? GreenComputing.memCacheWidth(context, effectiveLogicalWidth)
              : null);
      child = Image.network(
        trimmed,
        width: w,
        height: h,
        fit: fit,
        filterQuality: filterQuality,
        cacheWidth: cacheW,
        gaplessPlayback: true,
        errorBuilder: (_, __, ___) => _placeholder(w, h),
        loadingBuilder: (_, image, progress) {
          if (progress == null) return image;
          return _placeholder(w, h);
        },
      );
    }

    if (borderRadius != null) {
      child = ClipRRect(borderRadius: borderRadius!, child: child);
    }
    return child;
  }

  Widget _placeholder(double? w, double? h) {
    return Container(
      width: w,
      height: h,
      color: Colors.grey.shade300,
      alignment: Alignment.center,
      child: Icon(
        Icons.image_not_supported_outlined,
        size: (w != null && w < 80) ? 20 : 32,
        color: Colors.grey.shade500,
      ),
    );
  }
}

class _DataUrlImage extends StatefulWidget {
  const _DataUrlImage({
    required this.dataUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.filterQuality = FilterQuality.low,
    this.memCacheWidth,
    this.autoLoad = true,
  });

  final String dataUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final FilterQuality filterQuality;
  final int? memCacheWidth;
  final bool autoLoad;

  @override
  State<_DataUrlImage> createState() => _DataUrlImageState();
}

class _DataUrlImageState extends State<_DataUrlImage> {
  Uint8List? _bytes;
  bool _failed = false;
  bool _activated = false;

  @override
  void initState() {
    super.initState();
    _activated = widget.autoLoad;
    if (_activated) _load();
  }

  @override
  void didUpdateWidget(covariant _DataUrlImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dataUrl != widget.dataUrl) {
      _bytes = null;
      _failed = false;
      _activated = widget.autoLoad;
      if (_activated) _load();
    }
  }

  Future<void> _load() async {
    final cached = DataImageCache.get(widget.dataUrl);
    if (cached != null) {
      if (mounted) setState(() => _bytes = cached);
      return;
    }

    Uint8List? decoded;
    if (widget.dataUrl.length > 48000) {
      decoded = await compute(_decodeDataUrlBytes, widget.dataUrl);
    } else {
      decoded = _decodeDataUrlBytes(widget.dataUrl);
    }

    if (!mounted) return;
    if (decoded == null) {
      setState(() => _failed = true);
      return;
    }
    DataImageCache.put(widget.dataUrl, decoded);
    setState(() => _bytes = decoded);
  }

  @override
  Widget build(BuildContext context) {
    final w = widget.width;
    final h = widget.height;
    if (_failed) {
      return Container(
        width: w,
        height: h,
        color: Colors.grey.shade300,
        alignment: Alignment.center,
        child: Icon(Icons.broken_image_outlined, color: Colors.grey.shade500),
      );
    }
    final bytes = _bytes;
    if (bytes == null) {
      if (!_activated) {
        return GestureDetector(
          onTap: () {
            if (_activated) return;
            setState(() => _activated = true);
            _load();
          },
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: w,
            height: h,
            color: Colors.grey.shade200,
            alignment: Alignment.center,
            child: Builder(
              builder: (context) {
                final compact = (w ?? h ?? 96) < 96;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.image_outlined,
                      color: Colors.grey.shade600,
                      size: compact ? 22 : 26,
                    ),
                    if (!compact) ...[
                      const SizedBox(height: 6),
                      Text(
                        'Tap untuk memuat gambar',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        );
      }
      return Container(
        width: w,
        height: h,
        color: Colors.grey.shade200,
      );
    }
    return Image.memory(
      bytes,
      width: w,
      height: h,
      fit: widget.fit,
      filterQuality: widget.filterQuality,
      cacheWidth: widget.memCacheWidth,
      gaplessPlayback: true,
      errorBuilder: (_, __, ___) => Container(
        width: w,
        height: h,
        color: Colors.grey.shade300,
      ),
    );
  }
}
