import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_branding.dart';
import '../data/catalog_data.dart' show formatIdr, kCatalogProducts;
import '../providers/catalog_provider.dart';
import '../models/catalog_product.dart';
import '../providers/seller_applications_provider.dart';
import '../utils/app_screen_style.dart';
import '../utils/l10n_helpers.dart';
import '../widgets/store_logo_avatar.dart';

/// Halaman toko pembeli — produk dari penjual yang sama.
class SellerStoreScreen extends StatelessWidget {
  const SellerStoreScreen({
    super.key,
    required this.sellerName,
  });

  final String sellerName;

  static const route = '/seller-store';

  @override
  Widget build(BuildContext context) {
    context.watch<CatalogProvider>();
    final loc = context.l10n;
    final store = context
        .watch<SellerApplicationsProvider>()
        .approvedStoreBySellerName(sellerName);
    final displayName =
        store?.storeName.trim().isNotEmpty == true
            ? store!.storeName.trim()
            : sellerName;
    final products = kCatalogProducts
        .where(
          (p) =>
              p.sellerName == sellerName ||
              p.sellerName == displayName,
        )
        .toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 168,
            pinned: true,
            backgroundColor: AppBranding.seedColor,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 16, bottom: 14),
              title: Text(
                displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  shadows: [
                    Shadow(blurRadius: 6, color: Colors.black38),
                  ],
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppBranding.heroGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(16, 56, 16, 16),
                alignment: Alignment.bottomLeft,
                child: Row(
                  children: [
                    StoreLogoAvatar(
                      storeName: displayName,
                      logoUrl: store?.logoUrl,
                      logoPath: store?.logoPath,
                      radius: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${products.length} ${loc.productsLabel.toLowerCase()}',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.95),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (store?.storeDescription.trim().isNotEmpty ==
                              true) ...[
                            const SizedBox(height: 4),
                            Text(
                              store!.storeDescription.trim(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.88),
                                fontSize: 12,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (products.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    loc.noProductsYet,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: appMutedTextColor(context)),
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.72,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, i) => _ProductCard(product: products[i]),
                  childCount: products.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final CatalogProduct product;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: appCardColor(context),
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          '/product-detail',
          arguments: product.id,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Center(
                  child: Icon(Icons.image_not_supported_outlined),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatIdr(product.unitPrice),
                    style: TextStyle(
                      color: AppBranding.seedColor,
                      fontWeight: FontWeight.bold,
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
