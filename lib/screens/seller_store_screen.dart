import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_branding.dart';
import '../data/catalog_data.dart' show formatIdr, kCatalogProducts;
import '../l10n/app_localizations.dart';
import '../models/catalog_product.dart';
import '../models/seller_application.dart';
import '../providers/catalog_provider.dart';
import '../providers/seller_applications_provider.dart';
import '../utils/app_screen_style.dart';
import '../utils/responsive_layout.dart';
import '../utils/l10n_helpers.dart';
import '../utils/store_name_match.dart';
import '../widgets/app_network_image.dart';
import '../widgets/store_location_map.dart';
import '../widgets/store_logo_avatar.dart';

/// Halaman toko pembeli — layout responsif, tanpa tumpang tindih judul.
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
              storeNamesMatch(p.sellerName, sellerName) ||
              storeNamesMatch(p.sellerName, displayName),
        )
        .toList();

    return Scaffold(
      backgroundColor: appScaffoldBackground(context),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _StoreHeader(
              displayName: displayName,
              productCount: products.length,
              store: store,
              loc: loc,
            ),
          ),
          if (store != null &&
              store.streetAddress.trim().isNotEmpty &&
              store.city.trim().isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: appCardColor(context),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: appBorderColor(context)),
                  ),
                  child: StoreLocationMap(
                    store: store,
                    autoActivate: true,
                  ),
                ),
              ),
            ),
          if (products.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.storefront_outlined,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        loc.noProductsYet,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: appMutedTextColor(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                16,
                8,
                16,
                16 + MediaQuery.paddingOf(context).bottom,
              ),
              sliver: SliverGrid(
                gridDelegate: ResponsiveLayout.of(context)
                    .productGridDelegate(),
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

class _StoreHeader extends StatelessWidget {
  const _StoreHeader({
    required this.displayName,
    required this.productCount,
    required this.store,
    required this.loc,
  });

  final String displayName;
  final int productCount;
  final SellerApplication? store;
  final AppLocalizations loc;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: AppBranding.heroGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.fromLTRB(8, top + 4, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            color: Colors.white,
          ),
          const SizedBox(height: 4),
          LayoutBuilder(
            builder: (context, constraints) {
              final narrow = constraints.maxWidth < 340;
              final logo = StoreLogoAvatar(
                storeName: displayName,
                radius: narrow ? 36 : 44,
              );
              final info = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$productCount ${loc.productsLabel}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.92),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (store?.storeDescription.trim().isNotEmpty ==
                      true) ...[
                    const SizedBox(height: 6),
                    Text(
                      store!.storeDescription.trim(),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.88),
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                  ],
                ],
              );

              if (narrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    logo,
                    const SizedBox(height: 14),
                    info,
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  logo,
                  const SizedBox(width: 14),
                  Expanded(child: info),
                ],
              );
            },
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
              child: AppNetworkImage(
                url: product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      formatIdr(product.unitPrice),
                      maxLines: 1,
                      style: TextStyle(
                        color: AppBranding.seedColor,
                        fontWeight: FontWeight.bold,
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
