import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_branding.dart';
import '../data/catalog_data.dart';
import '../models/catalog_product.dart';
import '../providers/wishlist_provider.dart';
import '../utils/app_screen_style.dart';
import '../utils/l10n_helpers.dart';
import '../widgets/app_network_image.dart';

/// Kartu produk beranda — terpisah agar rebuild wishlist tidak repaint seluruh grid.
class HomeProductTile extends StatelessWidget {
  const HomeProductTile({
    super.key,
    required this.product,
    required this.onTap,
  });

  final CatalogProduct product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;

    return RepaintBoundary(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: appCardColor(context),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: appBorderColor(context)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    LayoutBuilder(
                      builder: (context, c) {
                        return AppNetworkImage(
                          url: product.imageUrl,
                          width: c.maxWidth,
                          height: c.maxHeight,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Material(
                        color: appCardElevated(context),
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () {
                            context.read<WishlistProvider>().toggle(product.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(loc.wishlistUpdatedSnack)),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Selector<WishlistProvider, bool>(
                              selector: (_, wl) => wl.has(product.id),
                              builder: (_, heart, __) => Icon(
                                heart
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                size: 20,
                                color: heart
                                    ? Colors.redAccent
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 10,
                      bottom: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          product.soldLabel,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      formatIdr(product.unitPrice),
                      style: const TextStyle(
                        color: AppBranding.accentDeep,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
