import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/catalog_data.dart';
import '../models/catalog_product.dart';
import '../providers/auth_provider.dart';
import '../providers/catalog_provider.dart';
import '../providers/seller_applications_provider.dart';
import '../utils/app_screen_style.dart';
import '../utils/l10n_helpers.dart';
import '../widgets/store_logo_avatar.dart';

/// Dashboard penjual — produk dari Realtime Database (toko Anda).
class StoreDashboardScreen extends StatelessWidget {
  const StoreDashboardScreen({
    super.key,
  });

  static const Color _purple = Color(0xFF7B42F6);

  List<CatalogProduct> _productsForStore(
    String storeName,
    String? displayName,
  ) {
    final keys = <String>{
      if (storeName.isNotEmpty) storeName,
      if (displayName != null && displayName.isNotEmpty) displayName,
    };
    if (keys.isEmpty) return [];
    return kCatalogProducts
        .where((p) => keys.contains(p.sellerName))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<CatalogProvider>();
    final loc = context.l10n;
    final auth = context.watch<AuthProvider>();
    final store = context.watch<SellerApplicationsProvider>().myApprovedStore;
    final storeName = store?.storeName.trim().isNotEmpty == true
        ? store!.storeName.trim()
        : (auth.displayName?.trim() ?? '');
    final products = _productsForStore(
      storeName,
      auth.displayName?.trim(),
    );

    return Scaffold(
            body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF742EF5),
                      Color(0xFFC4A8FF),
                    ],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor:
                                Colors.white.withValues(alpha: 0.22),
                          ),
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.chevron_left_rounded),
                          color: Colors.white,
                          iconSize: 28,
                        ),
                        const Spacer(),
                        Flexible(
                          child: Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(22),
                              onTap: () => Navigator.pushNamed(
                                context,
                                '/add-product',
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.add_rounded,
                                      color: _purple,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        loc.addProduct,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: _purple,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StoreLogoAvatar(
                          storeName: storeName.isNotEmpty
                              ? storeName
                              : loc.myStore,
                          logoUrl: store?.logoUrl,
                          logoPath: store?.logoPath,
                          radius: 40,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                storeName.isNotEmpty
                                    ? storeName
                                    : loc.myStore,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                store?.storeDescription.trim().isNotEmpty ==
                                        true
                                    ? store!.storeDescription.trim()
                                    : loc.settingsSubtitle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.92),
                                  fontSize: 13,
                                  height: 1.35,
                                ),
                              ),
                              if (store?.city.trim().isNotEmpty == true) ...[
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      size: 14,
                                      color: Colors.white
                                          .withValues(alpha: 0.85),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        '${store!.streetAddress}, ${store.city}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white
                                              .withValues(alpha: 0.85),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            child: _MiniStatCard(
                              label: loc.productsLabel,
                              value: '${products.length}',
                              circleColor:
                                  Colors.blue.withValues(alpha: 0.12),
                              icon: Icons.inventory_2_outlined,
                              iconColor: Colors.blue.shade700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _MiniStatCard(
                              label: loc.orders,
                              value: '0',
                              circleColor: Colors.green.withValues(alpha: 0.12),
                              icon: Icons.attach_money_rounded,
                              iconColor: Colors.green.shade700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _MiniStatCard(
                              label: loc.active,
                              value: '${products.where((p) => p.stock > 0).length}',
                              circleColor: _purple.withValues(alpha: 0.12),
                              icon: Icons.visibility_outlined,
                              iconColor: _purple,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              sliver: SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: appCardColor(context),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: appBorderColor(context)),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  loc.storePerformance,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  loc.thisMonth,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (products.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5E9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                Icons.trending_up_rounded,
                                size: 18,
                                color: Colors.green.shade700,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: 0.65,
                          minHeight: 10,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: const AlwaysStoppedAnimation(
                            _purple,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        loc.monthlyTarget,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${loc.productsLabel} (${products.length})',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        loc.viewAll,
                        style: TextStyle(
                          color: _purple,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (products.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 48),
                  child: Column(
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 56,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        loc.noStoreProducts,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        loc.noStoreProductsHint,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/add-product'),
                        style: FilledButton.styleFrom(
                          backgroundColor: _purple,
                        ),
                        child: Text(loc.addProduct),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 0,
              ),
              sliver: SliverList.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final p = products[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: appCardColor(context),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: appBorderColor(context),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withValues(alpha: 0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(12),
                                child: Image.network(
                                  p.imageUrl,
                                  width: 88,
                                  height: 88,
                                  fit: BoxFit.cover,
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
                                        fontWeight:
                                            FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      formatIdr(p.unitPrice),
                                      style: const TextStyle(
                                        color: _purple,
                                        fontWeight:
                                            FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFFE8F5E9,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(
                                          14,
                                        ),
                                      ),
                                      child: Text(
                                        p.stock > 0 ? loc.active : loc.outOfStock,
                                        style: TextStyle(
                                          fontWeight:
                                              FontWeight.bold,
                                          fontSize: 11,
                                          color:
                                              Colors.green.shade700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${loc.stock}: ${p.stock}   •   ${p.soldLabel}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => Navigator.pushNamed(
                                    context,
                                    '/edit-product',
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: _purple,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 8,
                                    ),
                                    side: const BorderSide(
                                      color: _purple,
                                      width: 1.2,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.edit_outlined, size: 18),
                                      const SizedBox(width: 4),
                                      Flexible(
                                        child: Text(
                                          loc.edit,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {},
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 8,
                                    ),
                                    side: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.delete_outline_rounded,
                                        size: 18,
                                        color: Colors.red.shade400,
                                      ),
                                      const SizedBox(width: 4),
                                      Flexible(
                                        child: Text(
                                          loc.delete,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.red.shade400,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  const _MiniStatCard({
    required this.label,
    required this.value,
    required this.circleColor,
    required this.icon,
    required this.iconColor,
  });

  final String label;
  final String value;
  final Color circleColor;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: circleColor,
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade700,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
