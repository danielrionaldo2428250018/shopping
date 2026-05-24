import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../utils/data_image_cache.dart';
import '../utils/green_computing.dart';

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
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final FilterQuality filterQuality;

  /// Override lebar decode; null = dihitung dari [width] + DPR.
  final int? memCacheWidth;

  @override
  Widget build(BuildContext context) {
    final w = width;
    final h = height;

    Widget child;
    final trimmed = url.trim();
    if (trimmed.isEmpty) {
      child = _placeholder(w, h);
    } else if (trimmed.startsWith('data:image')) {
      try {
        var bytes = DataImageCache.get(trimmed);
        if (bytes == null) {
          bytes = Uint8List.fromList(
            base64Decode(trimmed.split(',').last),
          );
          DataImageCache.put(trimmed, bytes);
        }
        final cacheW = memCacheWidth ??
            (w != null ? GreenComputing.memCacheWidth(context, w) : null);
        child = Image.memory(
          bytes,
          width: w,
          height: h,
          fit: fit,
          filterQuality: filterQuality,
          cacheWidth: cacheW,
          gaplessPlayback: true,
          errorBuilder: (_, __, ___) => _placeholder(w, h),
        );
      } catch (_) {
        child = _placeholder(w, h);
      }
    } else {
      final cacheW = memCacheWidth ??
          (w != null ? GreenComputing.memCacheWidth(context, w) : null);
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
