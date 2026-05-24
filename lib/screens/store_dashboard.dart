import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/catalog_data.dart';
import '../models/catalog_product.dart';
import '../providers/auth_provider.dart';
import '../providers/seller_applications_provider.dart';
import '../styles/app_colors_extension.dart';
import '../utils/app_screen_style.dart';
import '../utils/catalog_product_access.dart';
import '../utils/catalog_save_failure.dart';
import '../utils/l10n_helpers.dart';
import '../utils/responsive_layout.dart';
import '../providers/catalog_provider.dart';
import '../providers/orders_provider.dart';
import 'seller_orders_screen.dart';
import '../widgets/app_network_image.dart';
import '../widgets/store_location_map.dart';
import '../widgets/store_logo_avatar.dart';
import 'edit_store_screen.dart';

/// Dashboard penjual — produk dari Realtime Database (toko Anda).
class StoreDashboardScreen extends StatefulWidget {
  const StoreDashboardScreen({
    super.key,
  });

  @override
  State<StoreDashboardScreen> createState() => _StoreDashboardScreenState();
}

class _StoreDashboardScreenState extends State<StoreDashboardScreen> {
  static const Color _purple = Color(0xFF7B42F6);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<OrdersProvider>().ensureSellerRtdbLinked();
    });
  }

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
    final sellerOrderCount =
        context.watch<OrdersProvider>().sellerPendingCount;
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

    final colors = appColors(context);
    final r = ResponsiveLayout.of(context);
    return Scaffold(
      backgroundColor: appScaffoldBackground(context),
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: colors.profileHeaderGradient,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final narrow = constraints.maxWidth < 360;
                        final addBtn = Material(
                          color: appCardColor(context),
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
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_rounded,
                                      color: _purple,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      loc.addProduct,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: _purple,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                        if (narrow) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: IconButton(
                                  style: IconButton.styleFrom(
                                    backgroundColor: colors.headerIconButtonBg,
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                  icon: const Icon(Icons.chevron_left_rounded),
                                  color: colors.onHeader,
                                  iconSize: 28,
                                ),
                              ),
                              addBtn,
                            ],
                          );
                        }
                        return Row(
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
                            Flexible(child: addBtn),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StoreLogoAvatar(
                          storeName: storeName.isNotEmpty
                              ? storeName
                              : loc.myStore,
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
                                style: TextStyle(
                                  color: colors.onHeader,
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
                                  color: colors.onHeader.withValues(alpha: 0.92),
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
                                      color: colors.onHeader
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
                    const SizedBox(height: 16),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final stackActions = constraints.maxWidth < 340;
                        final editBtn = _HeaderActionButton(
                          onPressed: () => Navigator.pushNamed(
                            context,
                            EditStoreScreen.route,
                          ),
                          icon: Icons.store_outlined,
                          label: loc.editStore,
                          foregroundColor: colors.onHeader,
                          borderColor:
                              colors.onHeader.withValues(alpha: 0.5),
                        );
                        final deleteBtn = _HeaderActionButton(
                          onPressed: () => _confirmDeleteStore(context),
                          icon: Icons.delete_outline,
                          label: loc.deleteStore,
                          foregroundColor: Colors.red.shade100,
                          borderColor: Colors.red.shade200,
                        );
                        if (stackActions) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              editBtn,
                              const SizedBox(height: 8),
                              deleteBtn,
                            ],
                          );
                        }
                        return Row(
                          children: [
                            Expanded(child: editBtn),
                            const SizedBox(width: 10),
                            Expanded(child: deleteBtn),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final cards = [
                          _MiniStatCard(
                            label: loc.productsLabel,
                            value: '${products.length}',
                            circleColor:
                                Colors.blue.withValues(alpha: 0.12),
                            icon: Icons.inventory_2_outlined,
                            iconColor: Colors.blue.shade700,
                          ),
                          _MiniStatCard(
                            label: loc.orders,
                            value: '$sellerOrderCount',
                            circleColor:
                                Colors.green.withValues(alpha: 0.12),
                            icon: Icons.receipt_long_outlined,
                            iconColor: Colors.green.shade700,
                            onTap: () => Navigator.pushNamed(
                              context,
                              SellerOrdersScreen.route,
                            ),
                          ),
                          _MiniStatCard(
                            label: loc.active,
                            value:
                                '${products.where((p) => p.stock > 0).length}',
                            circleColor: _purple.withValues(alpha: 0.12),
                            icon: Icons.visibility_outlined,
                            iconColor: _purple,
                          ),
                        ];
                        if (constraints.maxWidth < 360 || r.isCompact) {
                          return Column(
                            children: [
                              for (var i = 0; i < cards.length; i++) ...[
                                if (i > 0) const SizedBox(height: 8),
                                cards[i],
                              ],
                            ],
                          );
                        }
                        return IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              for (var i = 0; i < cards.length; i++) ...[
                                if (i > 0) const SizedBox(width: 8),
                                Expanded(child: cards[i]),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (store != null &&
                store.streetAddress.trim().isNotEmpty &&
                store.city.trim().isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                sliver: SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: appCardColor(context),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: appBorderColor(context)),
                    ),
                    child: StoreLocationMap(store: store),
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
                                child: AppNetworkImage(
                                  url: p.imageUrl,
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
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight:
                                            FontWeight.bold,
                                        fontSize: 15,
                                        height: 1.25,
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
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
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
                                          p.stock > 0
                                              ? loc.active
                                              : loc.outOfStock,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight:
                                                FontWeight.bold,
                                            fontSize: 11,
                                            color:
                                                Colors.green.shade700,
                                          ),
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
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final stackBtns = constraints.maxWidth < 300;
                              final editProduct = _ProductActionButton(
                                onPressed: () => Navigator.pushNamed(
                                  context,
                                  '/edit-product',
                                  arguments: p.id,
                                ),
                                icon: Icons.edit_outlined,
                                label: loc.edit,
                                foregroundColor: _purple,
                                borderColor: _purple,
                              );
                              final deleteProduct = _ProductActionButton(
                                onPressed: () =>
                                    _confirmDeleteProduct(context, p),
                                icon: Icons.delete_outline_rounded,
                                label: loc.delete,
                                foregroundColor: Colors.red.shade400,
                                borderColor: Colors.grey.shade300,
                              );
                              if (stackBtns) {
                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    editProduct,
                                    const SizedBox(height: 8),
                                    deleteProduct,
                                  ],
                                );
                              }
                              return Row(
                                children: [
                                  Expanded(child: editProduct),
                                  const SizedBox(width: 8),
                                  Expanded(child: deleteProduct),
                                ],
                              );
                            },
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

Future<void> _confirmDeleteProduct(
  BuildContext context,
  CatalogProduct product,
) async {
  final loc = context.l10n;
  final yes = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(loc.delete),
      content: Text(loc.deleteProductConfirm),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(loc.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(loc.delete),
        ),
      ],
    ),
  );
  if (yes != true || !context.mounted) return;
  final auth = context.read<AuthProvider>();
  final store = context.read<SellerApplicationsProvider>().myApprovedStore;
  final storeName = store?.storeName.trim();
  if (!canManageCatalogProduct(
    product: product,
    uid: auth.uid,
    accountEmail: auth.accountEmail,
    isSeller: auth.hasApprovedSellerAccess,
    myStoreName: storeName?.isNotEmpty == true ? storeName : null,
  )) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(catalogSaveFailureMessage(loc, 'permission-denied')),
      ),
    );
    return;
  }
  final catalog = context.read<CatalogProvider>();
  final ok = await catalog.deleteProduct(
    product.id,
    claimSellerUid: auth.uid,
    sellerStoreName: storeName?.isNotEmpty == true ? storeName : null,
  );
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        ok
            ? loc.productDeleted
            : catalogSaveFailureMessage(loc, catalog.error),
      ),
    ),
  );
}

Future<void> _confirmDeleteStore(BuildContext context) async {
  final loc = context.l10n;
  final yes = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(loc.deleteStore),
      content: Text(loc.deleteStoreConfirm),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(loc.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(loc.delete),
        ),
      ],
    ),
  );
  if (yes != true || !context.mounted) return;
  final ok =
      await context.read<SellerApplicationsProvider>().deleteMyStore();
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(ok ? loc.storeDeleted : loc.publishFailed)),
  );
  if (ok) {
    Navigator.popUntil(context, (r) => r.isFirst);
  }
}

/// Tombol aksi header toko — teks mengecil otomatis agar tidak overflow.
class _HeaderActionButton extends StatelessWidget {
  const _HeaderActionButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.foregroundColor,
    required this.borderColor,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final Color foregroundColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: foregroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        side: BorderSide(color: borderColor),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductActionButton extends StatelessWidget {
  const _ProductActionButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.foregroundColor,
    required this.borderColor,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final Color foregroundColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: foregroundColor,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        side: BorderSide(color: borderColor, width: 1.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: foregroundColor,
                fontWeight: FontWeight.w600,
              ),
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
    this.onTap,
  });

  final String label;
  final String value;
  final Color circleColor;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final child = Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: circleColor,
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
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
    if (onTap == null) return child;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: child,
      ),
    );
  }
}
