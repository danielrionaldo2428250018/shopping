import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_branding.dart';
import '../data/catalog_data.dart';
import '../providers/cart_provider.dart';
import '../providers/inbox_messages_provider.dart';
import '../providers/wishlist_provider.dart';
import '../providers/catalog_provider.dart';
import '../utils/l10n_helpers.dart';

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
  static bool _sessionCatalogRevealDone = false;

  bool _showCatalogShimmer = true;

  @override
  void initState() {
    super.initState();
    if (kCatalogProducts.isEmpty || _sessionCatalogRevealDone) {
      _showCatalogShimmer = false;
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 580));
      if (!mounted) return;
      setState(() {
        _showCatalogShimmer = false;
        _sessionCatalogRevealDone = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    context.watch<CatalogProvider>();
    final loc = context.l10n;
    final products = kCatalogProducts;

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

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: AppBranding.heroGradient,
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
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                loc.homeHeroTagline,
                                style: const TextStyle(
                                  color: Colors.white,
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
                                    backgroundColor:
                                        Colors.white.withValues(alpha: 0.22),
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/cart');
                                  },
                                  icon: const Icon(
                                    Icons.shopping_cart_outlined,
                                    color: Colors.white,
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
                        Consumer<InboxMessagesProvider>(
                          builder: (context, inbox, _) {
                            final n = inbox.unreadCount;
                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                IconButton(
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.white
                                        .withValues(alpha: 0.22),
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/notifications',
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.chat_bubble_outline_rounded,
                                    color: Colors.white,
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
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: Colors.grey.shade600),
                            const SizedBox(width: 12),
                            Text(
                              loc.searchHint,
                              style: TextStyle(
                                color: Colors.grey.shade600,
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
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: AppBranding.promoGradient,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.recycling_rounded,
                            color: Colors.white.withValues(alpha: 0.95),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            loc.homePrelovedDeal,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.95),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        loc.homeWeekThriftBest,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        loc.homeTrustedSellersLine,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.92),
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
                            backgroundColor: Colors.white,
                            foregroundColor: AppBranding.seedColor,
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
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Text(
                  loc.shopByCategory,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(
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
                              width: 64,
                              height: 64,
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
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      loc.featuredForYou,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/search-results',
                          arguments: '',
                        );
                      },
                      child: Text(
                        '${loc.seeAll} (${loc.productCount(kCatalogProducts.length)})',
                        style: const TextStyle(
                          color: AppBranding.seedColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (products.isEmpty)
                Padding(
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
                        loc.noProductsYet,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        loc.noProductsHint,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                )
              else if (_showCatalogShimmer)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LoadingLagBanner(
                        message: loc.catalogLoadingBanner,
                      ),
                      SizedBox(height: 12),
                      ProductGridShimmer(),
                    ],
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.68,
                  ),
                  itemBuilder: (context, index) {
                    final p = products[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/product-detail',
                          arguments: p.id,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(
                                    p.imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: Material(
                                      color: Colors.white,
                                      shape: const CircleBorder(),
                                      child: InkWell(
                                        customBorder: const CircleBorder(),
                                        onTap: () {
                                          context
                                              .read<WishlistProvider>()
                                              .toggle(p.id);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                loc.wishlistUpdatedSnack,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(6),
                                          child: Consumer<WishlistProvider>(
                                            builder: (context, wl, _) {
                                              final heart = wl.has(p.id);
                                              return Icon(
                                                heart
                                                    ? Icons.favorite_rounded
                                                    : Icons
                                                        .favorite_border_rounded,
                                                size: 20,
                                                color: heart
                                                    ? Colors.redAccent
                                                    : Colors.grey.shade600,
                                              );
                                            },
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
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        p.soldLabel,
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
                              padding: const EdgeInsets.fromLTRB(
                                12,
                                10,
                                12,
                                12,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p.title,
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
                                    formatIdr(p.unitPrice),
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
                    );
                  },
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
