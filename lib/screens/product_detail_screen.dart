import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../data/catalog_data.dart';
import '../models/catalog_product.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/seller_applications_provider.dart';
import '../providers/reviews_provider.dart';
import '../providers/wishlist_provider.dart';
import '../utils/app_screen_style.dart';
import '../utils/green_computing.dart';
import '../utils/responsive_layout.dart';
import '../widgets/app_network_image.dart';
import '../widgets/store_logo_avatar.dart';
import '../providers/settings_prefs_provider.dart';
import '../utils/l10n_helpers.dart';

import 'buy_product_screen.dart';
import 'chat_screen.dart';
import 'seller_store_screen.dart';

String _resolveChatSellerName(BuildContext context, String sellerName) {
  final app = context
      .read<SellerApplicationsProvider>()
      .approvedStoreBySellerName(sellerName);
  final canonical = app?.storeName.trim();
  return (canonical != null && canonical.isNotEmpty) ? canonical : sellerName;
}

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({
    super.key,
    this.productId,
  });

  /// Kosong = pakai produk default katalog.
  final String? productId;

  @override
  State<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  static const Color _purple = Color(0xFF7B39FD);

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final guest = !auth.isLoggedIn;
    final ecoMode =
        context.select((SettingsPrefsProvider s) => s.ecoMode);
    final loc = context.l10n;
    final product = catalogProductOrNull(widget.productId);
    final reviewSummary = product == null
        ? (avg: 0.0, count: 0)
        : context.watch<ReviewsProvider>().productRatingSummary(product.id);
    final productReviews = product == null
        ? <Map<String, dynamic>>[]
        : context.watch<ReviewsProvider>().reviewsForProduct(product.id);
    if (product == null) {
      return Scaffold(
                appBar: AppBar(
          title: Text(loc.productDetails),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  loc.productNotFound,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  loc.catalogEmptyOrInvalid,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(loc.back),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: appScaffoldBackground(context),
      appBar: guest
          ? null
          : AppBar(
              elevation: 0,
              scrolledUnderElevation: 0,
              centerTitle: true,
              title: Text(
                loc.productDetails,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  onPressed: () async {
                    final text =
                        '${product.title} — ${formatIdr(product.unitPrice)}\n'
                        'nearmarket://product/${product.id}';
                    await Share.share(text);
                  },
                  icon: const Icon(Icons.share_outlined),
                ),
                Consumer<WishlistProvider>(
                  builder: (context, wl, _) {
                    final fav = wl.has(product.id);
                    return IconButton(
                      onPressed: () {
                        final was = wl.has(product.id);
                        wl.toggle(product.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              was ? loc.emptyFavorites : loc.favorites,
                            ),
                          ),
                        );
                      },
                      icon: Icon(
                        fav
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: fav ? Colors.redAccent : _purple,
                      ),
                    );
                  },
                ),
              ],
            ),
      bottomNavigationBar: guest
          ? _GuestBottomActions(
              onSignIn: () =>
                  Navigator.pushNamed(context, '/login'),
              onAddToCart: () =>
                  Navigator.pushNamed(context, '/login'),
              onBuy: () =>
                  Navigator.pushNamed(context, '/login'),
            )
          : _LoggedInBottomBar(
              onChat: () {
                final seller = _resolveChatSellerName(
                  context,
                  product.sellerName,
                );
                Navigator.pushNamed(
                  context,
                  '/chat',
                  arguments: ChatRouteArgs(
                    sellerName: seller,
                    sellerInitials: product.sellerInitials,
                    productId: product.id,
                    productTitle: product.title,
                    productPrice: formatIdr(product.unitPrice),
                    productImageUrl: product.imageUrl,
                  ),
                );
              },
              onAddToCart: () {
                context.read<CartProvider>().addProduct(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(loc.addToCart),
                    action: SnackBarAction(
                      label: loc.viewLabel,
                      onPressed: () {
                        Navigator.pushNamed(context, '/cart');
                      },
                    ),
                  ),
                );
              },
              onBuy: () {
                Navigator.pushNamed(
                  context,
                  '/buy-product',
                  arguments: BuyProductRouteArgs(
                    productId: product.id,
                    title: product.title,
                    unitPrice: product.unitPrice,
                    imageUrl: product.imageUrl,
                    sellerName: product.sellerName,
                    stock: product.stock,
                  ),
                );
              },
            ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (guest)
            Material(
              color: const Color(0xFFFFF9E6),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lock_outline_rounded,
                        size: 20,
                        color: Colors.brown.shade700,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          loc.signInToContinue,
                          style: TextStyle(
                            color: Colors.brown.shade800,
                            fontSize: 13,
                            height: 1.35,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ColoredBox(
                        color: Colors.white,
                        child: SizedBox(
                          height: context.r.productHeroHeight,
                          width: double.infinity,
                          child: _ProductHeroImage(
                            imageUrl: product.imageUrl,
                            ecoMode: ecoMode,
                            height: context.r.productHeroHeight,
                          ),
                        ),
                      ),
                      if (guest)
                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              8,
                              4,
                              8,
                              0,
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () =>
                                      Navigator.pop(context),
                                  icon: const Icon(Icons.chevron_left),
                                ),
                                const Spacer(),
                                IconButton(
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () async {
                                    await Clipboard.setData(
                                      ClipboardData(
                                        text:
                                            'nearmarket://product/${product.id}',
                                      ),
                                    );
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text(loc.ok),
                                      ),
                                    );
                                  },
                                  icon:
                                      const Icon(Icons.share_outlined),
                                ),
                                IconButton(
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () => Navigator.pushNamed(
                                    context,
                                    '/login',
                                  ),
                                  icon: Stack(
                                    clipBehavior: Clip.none,
                                    alignment: Alignment.topRight,
                                    children: [
                                      Icon(
                                        Icons.favorite_border,
                                        color: _purple,
                                      ),
                                      Positioned(
                                        top: -4,
                                        right: -4,
                                        child: Icon(
                                          Icons.lock_rounded,
                                          size: 12,
                                          color:
                                              Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  Padding(
                    padding: appPageInsets(context, top: 18, bottom: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _InfoCard(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.title,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  height: 1.35,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    color: Color(0xFFFFC107),
                                    size: 22,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    (reviewSummary.count > 0
                                            ? reviewSummary.avg
                                            : product.ratingValue)
                                        .toStringAsFixed(1),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '  (${reviewSummary.count > 0 ? reviewSummary.count : product.reviewsCount} reviews)',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    '  •  ',
                                    style: TextStyle(
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  Text(
                                    product.soldLabel,
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.end,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        loc.priceDisplay,
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        formatIdr(product.unitPrice),
                                        style: const TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                          color: _purple,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8F5E9),
                                      borderRadius:
                                          BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      product.stock > 0
                                          ? loc.inStock
                                          : loc.outOfStock,
                                      style: TextStyle(
                                        color: product.stock > 0
                                            ? const Color(0xFF2E7D32)
                                            : Colors.red.shade700,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (guest) ...[
                                const SizedBox(height: 12),
                                Text(
                                  '📍 ${product.locationLabel} • '
                                  '⭐ Seller ${product.sellerRating.toStringAsFixed(1)}',
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (!guest) ...[
                          const SizedBox(height: 14),
                          _SellerInfoCard(product: product),
                        ],
                        const SizedBox(height: 14),
                        _infoSection(
                          loc.description,
                          product.description,
                          extra: Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Wrap(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE3F2FD),
                                    borderRadius:
                                        BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.verified_user_outlined,
                                        size: 18,
                                        color: Colors.blue.shade700,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '1 Year Official Warranty',
                                        style: TextStyle(
                                          color: Colors.blue.shade800,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (productReviews.isNotEmpty) ...[
                          const SizedBox(height: 14),
                          _infoSection(
                            'Ulasan pembeli',
                            '',
                            extra: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: productReviews.take(5).map((r) {
                                final rating =
                                    (r['rating'] as num?)?.toInt() ?? 5;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            r['name']?.toString() ?? 'Pembeli',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Spacer(),
                                          Text('★' * rating),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        r['review']?.toString() ?? '',
                                        style: TextStyle(
                                          color: Colors.grey.shade800,
                                          height: 1.35,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                        const SizedBox(height: 14),
                        _specsCard(product),
                        SizedBox(height: guest ? 32 : 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _specsCard(CatalogProduct product) {
    final loc = context.l10n;
    return _InfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.productDetails,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(height: 28),
          _detailRow(loc.condition, product.condition),
          _detailRow(loc.description, product.weightLabel),
          _detailRow(loc.selectCategory, product.category),
          _detailRow(loc.stock, loc.stockLeft(product.stock)),
        ],
      ),
    );
  }

  Widget _infoSection(
    String title,
    String body, {
    Widget? extra,
  }) {
    return _InfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (body.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              body,
              style: TextStyle(
                color: Colors.grey.shade700,
                height: 1.55,
              ),
            ),
          ],
          if (extra != null) ...[
            if (body.isNotEmpty) const SizedBox(height: 10),
            extra,
          ],
        ],
      ),
    );
  }

  Widget _detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appCardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: appBorderColor(context)),
      ),
      child: child,
    );
  }
}

class _SellerInfoCard extends StatelessWidget {
  const _SellerInfoCard({required this.product});

  final CatalogProduct product;

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;
    return Material(
      color: appCardColor(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: appBorderColor(context)),
        ),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  SellerStoreScreen.route,
                  arguments: product.sellerName,
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StoreLogoAvatar(
                    storeName: product.sellerName,
                    radius: 28,
                  ),
                  const SizedBox(width: 14),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.sizeOf(context).width * 0.45,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.sellerName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.place_outlined,
                              size: 16,
                              color: Colors.grey.shade600,
                            ),
                            Flexible(
                              child: Text(
                                ' ${product.locationLabel}',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Icon(
                              Icons.star_rounded,
                              color: Color(0xFFFFC107),
                              size: 18,
                            ),
                            Text(
                              ' ${product.sellerRating.toStringAsFixed(1)}',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            IconButton.filledTonal(
              style: IconButton.styleFrom(
                backgroundColor: appAccentTint(context),
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                final seller = _resolveChatSellerName(
                  context,
                  product.sellerName,
                );
                Navigator.pushNamed(
                  context,
                  '/chat',
                  arguments: ChatRouteArgs(
                    sellerName: seller,
                    sellerInitials: product.sellerInitials,
                    productId: product.id,
                    productTitle: product.title,
                    productPrice: formatIdr(product.unitPrice),
                    productImageUrl: product.imageUrl,
                  ),
                );
              },
              icon: const Icon(Icons.chat_bubble_outline_rounded),
              tooltip: loc.chatSellerTooltip,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductHeroImage extends StatelessWidget {
  const _ProductHeroImage({
    required this.imageUrl,
    required this.ecoMode,
    required this.height,
  });

  final String imageUrl;
  final bool ecoMode;
  final double height;

  @override
  Widget build(BuildContext context) {
    final cacheW = GreenComputing.memCacheWidth(
      context,
      MediaQuery.sizeOf(context).width,
    );
    return AppNetworkImage(
      url: imageUrl,
      fit: BoxFit.contain,
      height: height,
      width: double.infinity,
      filterQuality: FilterQuality.low,
      memCacheWidth: cacheW,
    );
  }
}

class _GuestBottomActions extends StatelessWidget {
  const _GuestBottomActions({
    required this.onSignIn,
    required this.onAddToCart,
    required this.onBuy,
  });

  final VoidCallback onSignIn;
  final VoidCallback onAddToCart;
  final VoidCallback onBuy;

  static const Color _purple = Color(0xFF7C4DFF);

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;
    return Material(
      color: appCardElevated(context),
      elevation: 12,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
          child: Row(
            children: [
              IconButton(
                onPressed: onAddToCart,
                style: IconButton.styleFrom(
                  backgroundColor: appAccentTint(context),
                  foregroundColor: Theme.of(context).colorScheme.primary,
                ),
                icon: const Icon(Icons.add_shopping_cart_outlined),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: onSignIn,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _purple,
                    side: const BorderSide(color: _purple, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    loc.signIn,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: onBuy,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _purple,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.lock_outline_rounded, size: 18),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          loc.buyNow,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold),
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
    );
  }
}

class _LoggedInBottomBar extends StatelessWidget {
  const _LoggedInBottomBar({
    required this.onChat,
    required this.onAddToCart,
    required this.onBuy,
  });

  final VoidCallback onChat;
  final VoidCallback onAddToCart;
  final VoidCallback onBuy;

  static const Color _purple = Color(0xFF7B39FD);

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;
    return Material(
      color: appCardElevated(context),
      elevation: 12,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 12, 10, 16),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onChat,
                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 20),
                  label: Text(
                    loc.chat,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _purple,
                    side: const BorderSide(color: _purple, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onAddToCart,
                  icon: const Icon(Icons.add_shopping_cart_outlined, size: 20),
                  label: Text(
                    loc.addToCart,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _purple,
                    side: const BorderSide(color: _purple, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: onBuy,
                  icon: const Icon(Icons.flash_on_rounded, size: 20),
                  label: Text(
                    loc.buyNow,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _purple,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
