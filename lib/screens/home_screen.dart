import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_branding.dart';
import '../providers/cart_provider.dart';
import '../providers/inbox_messages_provider.dart';
import '../models/chat_inbox_mode.dart';
import '../providers/chat_provider.dart';
import '../providers/catalog_provider.dart';
import '../providers/settings_prefs_provider.dart';
import '../styles/app_colors_extension.dart';
import '../utils/app_screen_style.dart';
import '../utils/green_computing.dart';
import '../utils/l10n_helpers.dart';
import '../utils/responsive_layout.dart';
import '../widgets/home_product_tile.dart';
import '../widgets/shimmer_widgets.dart';

/// Beranda marketplace barang bekas / preloved.
class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final catalog = context.watch<CatalogProvider>();
    final catalogLoading = catalog.loading;
    final catalogError = catalog.error;
    final ecoMode =
        context.select((SettingsPrefsProvider s) => s.ecoMode);
    final loc = context.l10n;
    final r = ResponsiveLayout.of(context);
    final products = catalog.products;
    final showCatalogShimmer = catalogLoading && products.isEmpty;
    final previewCount = GreenComputing.homeProductCap(
      ecoMode: ecoMode,
      compactScreen: r.isCompact,
    );
    final previewProducts = products.take(previewCount).toList();

    final categories = <Map<String, dynamic>>[
      {
        'icon': Icons.smartphone_rounded,
        'title': loc.catElectronics,
        'bg': const Color(0xFFE3F2FD),
        'fg': const Color(0xFF1976D2),
      },
      {
        'icon': Icons.checkroom_rounded,
        'title': loc.catFashion,
        'bg': const Color(0xFFFCE4EC),
        'fg': const Color(0xFFE91E63),
      },
      {
        'icon': Icons.home_rounded,
        'title': loc.catHome,
        'bg': const Color(0xFFE8F5E9),
        'fg': const Color(0xFF43A047),
      },
      {
        'icon': Icons.chair_rounded,
        'title': loc.catSports,
        'bg': const Color(0xFFFFF3E0),
        'fg': const Color(0xFFF57C00),
      },
    ];

    final colors = appColors(context);
    return Scaffold(
      backgroundColor: appScaffoldBackground(context),
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(
                  r.horizontalPadding,
                  16,
                  r.horizontalPadding,
                  24,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: colors.headerGradient,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                loc.appBrandName,
                                style: TextStyle(
                                  color: colors.onHeader,
                                  fontSize: r.sp(26),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                loc.homeHeroTagline,
                                style: TextStyle(
                                  color: colors.onHeader.withValues(alpha: 0.95),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Consumer<CartProvider>(
                          builder: (context, cart, _) {
                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                IconButton(
                                  style: IconButton.styleFrom(
                                    backgroundColor: colors.headerIconButtonBg,
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/cart');
                                  },
                                  icon: Icon(
                                    Icons.shopping_cart_outlined,
                                    color: colors.onHeader,
                                    size: 24,
                                  ),
                                ),
                                if (cart.itemCount > 0)
                                  Positioned(
                                    right: 4,
                                    top: 4,
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: const BoxDecoration(
                                        color: Colors.redAccent,
                                        shape: BoxShape.circle,
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 18,
                                        minHeight: 18,
                                      ),
                                      child: Text(
                                        '${cart.itemCount > 9 ? '9+' : cart.itemCount}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        Consumer2<InboxMessagesProvider, ChatProvider>(
                          builder: (context, inbox, chat, _) {
                            final n =
                                inbox.unreadCount + chat.unreadChatCount;
                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                IconButton(
                                  style: IconButton.styleFrom(
                                    backgroundColor: colors.headerIconButtonBg,
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/notifications',
                                      arguments: ChatInboxMode.all,
                                    );
                                  },
                                  icon: Icon(
                                    Icons.chat_bubble_outline_rounded,
                                    color: colors.onHeader,
                                    size: 26,
                                  ),
                                ),
                                if (n > 0)
                                  Positioned(
                                    right: 2,
                                    top: 2,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                        vertical: 2,
                                      ),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF25D366),
                                        shape: BoxShape.circle,
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 16,
                                        minHeight: 16,
                                      ),
                                      child: Text(
                                        n > 9 ? '9+' : '$n',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/search');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: appCardElevated(context),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: appMutedTextColor(context)),
                            const SizedBox(width: 12),
                            Text(
                              loc.searchHint,
                              style: TextStyle(
                                color: appMutedTextColor(context),
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: colors.promoGradient,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.recycling_rounded,
                            color: colors.onHeader,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            loc.homePrelovedDeal,
                            style: TextStyle(
                              color: colors.onHeader,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        loc.homeWeekThriftBest,
                        style: TextStyle(
                          color: colors.onHeader,
                          fontSize: r.sp(22),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        loc.homeTrustedSellersLine,
                        style: TextStyle(
                          color: colors.onHeader.withValues(alpha: 0.92),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/categories');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appCardColor(context),
                            foregroundColor: Theme.of(context).colorScheme.primary,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            loc.homeExploreUsedBtn,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Text(
                  loc.shopByCategory,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: appPrimaryText(context),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final c = categories[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/categories');
                        },
                        child: Column(
                          children: [
                            Container(
                              width: r.categoryIconBox,
                              height: r.categoryIconBox,
                              decoration: BoxDecoration(
                                color: c['bg'] as Color,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                c['icon'] as IconData,
                                color: c['fg'] as Color,
                                size: 30,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              c['title'] as String,
                              style: TextStyle(
                                fontSize: r.sp(12),
                                fontWeight: FontWeight.w600,
                                color: appPrimaryText(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        loc.featuredForYou,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: appPrimaryText(context),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/search-results',
                          arguments: '',
                        );
                      },
                      child: Text(
                        loc.seeAll,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppBranding.seedColor,
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
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.storefront_outlined,
                        size: 56,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        catalogError != null
                            ? loc.publishFailed
                            : loc.noProductsYet,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        catalogError != null
                            ? catalogError
                            : loc.noProductsHint,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          height: 1.4,
                          fontSize: 13,
                        ),
                      ),
                      if (catalogError != null) ...[
                        const SizedBox(height: 14),
                        FilledButton.icon(
                          onPressed: () =>
                              context.read<CatalogProvider>().retryConnection(),
                          icon: const Icon(Icons.refresh_rounded),
                          label: Text(loc.retry),
                        ),
                      ],
                    ],
                  ),
                ),
              )
            else if (showCatalogShimmer)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LoadingLagBanner(
                        message: loc.catalogLoadingBanner,
                      ),
                      SizedBox(height: 12),
                      ProductGridShimmer(ecoMode: ecoMode),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                sliver: SliverGrid(
                  gridDelegate: r.productGridDelegate(ecoMode: ecoMode),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final p = previewProducts[index];
                      return HomeProductTile(
                        product: p,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/product-detail',
                            arguments: p.id,
                          );
                        },
                      );
                    },
                    childCount: previewProducts.length,
                  ),
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}
