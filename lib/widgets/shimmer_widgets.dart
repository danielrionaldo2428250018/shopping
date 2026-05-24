import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/app_screen_style.dart';
import '../utils/l10n_helpers.dart';
import '../utils/responsive_layout.dart';

Color _shimmerBase(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
        ? Colors.grey.shade800
        : Colors.grey.shade300;

Color _shimmerHi(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
        ? Colors.grey.shade600
        : Colors.grey.shade100;

/// Kotak shimmer generik.
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.radius = 12,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final base = _shimmerBase(context);
    final hi = _shimmerHi(context);

    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: hi,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: base,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

/// Grid produk 2 kolom (mirip home / hasil cari).
class ProductGridShimmer extends StatelessWidget {
  const ProductGridShimmer({
    super.key,
    this.itemCount = 4,
    this.ecoMode = false,
  });

  final int itemCount;
  final bool ecoMode;

  @override
  Widget build(BuildContext context) {
    final base = _shimmerBase(context);
    final hi = _shimmerHi(context);
    final r = ResponsiveLayout.of(context);
    final count = ecoMode ? (itemCount > 4 ? 4 : itemCount) : itemCount;

    if (ecoMode) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: count,
        gridDelegate: r.productGridDelegateFixed(ecoMode: true),
        itemBuilder: (_, __) => Container(
          decoration: BoxDecoration(
            color: appCardColor(context),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Expanded(child: Container(color: base)),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 12, width: 120, color: base),
                    const SizedBox(height: 8),
                    Container(height: 10, width: 80, color: base),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      gridDelegate: r.productGridDelegateFixed(ecoMode: false),
      itemBuilder: (_, __) {
        return Container(
          decoration: BoxDecoration(
            color: appCardColor(context),
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: base,
                  highlightColor: hi,
                  child: Container(color: base),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(
                      width: double.infinity,
                      height: 14,
                      radius: 6,
                    ),
                    const SizedBox(height: 6),
                    ShimmerBox(
                      width: 100,
                      height: 16,
                      radius: 6,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Banner kecil "memuat / sinyal lambat".
class LoadingLagBanner extends StatelessWidget {
  const LoadingLagBanner({
    super.key,
    this.message,
  });

  final String? message;

  @override
  Widget build(BuildContext context) {
    final text = message ?? context.l10n.shimmerSlowConnection;
    return Material(
      color: Colors.amber.shade50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.amber.shade800,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.amber.shade900,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dialog layar penuh: shimmer + teks (pencarian foto / data lambat).
class FullScreenShimmerLoading extends StatelessWidget {
  const FullScreenShimmerLoading({
    super.key,
    required this.title,
    this.subtitle,
  });

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final sub = subtitle ?? context.l10n.shimmerFetchingSubtitle;
    return PopScope(
      canPop: false,
      child: Material(
        color: Colors.black54,
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 28),
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  sub,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  child: ProductGridShimmer(itemCount: 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
