import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/catalog_data.dart';
import '../l10n/app_localizations.dart';
import '../models/catalog_product.dart';
import '../providers/wishlist_provider.dart';
import '../providers/catalog_provider.dart';
import '../utils/l10n_helpers.dart';

/// Wishlist user biasa — grid + filter ringkas.
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({
    super.key,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  static const Color _purple = Color(0xFF7B42F6);

  bool _gridView = true;

  /// 0 default, 1 harga naik, 2 harga turun, 3 A–Z
  int _sortMode = 0;

  String _sortLabel(AppLocalizations loc) {
    switch (_sortMode) {
      case 1:
        return loc.sortPriceLow;
      case 2:
        return loc.sortPriceHigh;
      default:
        return loc.sortRelevance;
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<CatalogProvider>();
    final loc = context.l10n;
    final wl = context.watch<WishlistProvider>();
    var items = kCatalogProducts
        .where((p) => wl.has(p.id))
        .toList();
    switch (_sortMode) {
      case 1:
        items.sort((a, b) => a.unitPrice.compareTo(b.unitPrice));
        break;
      case 2:
        items.sort((a, b) => b.unitPrice.compareTo(a.unitPrice));
        break;
      case 3:
        items.sort((a, b) => a.title.compareTo(b.title));
        break;
      default:
        break;
    }

    return Scaffold(
            body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loc.favorites,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          loc.productCount(items.length),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor:
                          _gridView ? _purple : Colors.grey.shade200,
                    ),
                    onPressed: () =>
                        setState(() => _gridView = true),
                    icon: Icon(
                      Icons.grid_view_rounded,
                      color:
                          _gridView ? Colors.white : Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor:
                          !_gridView ? _purple : Colors.grey.shade200,
                    ),
                    onPressed: () =>
                        setState(() => _gridView = false),
                    icon: Icon(
                      Icons.view_list_rounded,
                      color: !_gridView
                          ? Colors.white
                          : Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
              child: Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () async {
                      final v = await showModalBottomSheet<int>(
                        context: context,
                        builder: (ctx) => SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: Text(loc.sortWishlist),
                              ),
                              ListTile(
                                title: Text(loc.sortRelevance),
                                trailing: _sortMode == 0
                                    ? Icon(Icons.check, color: _purple)
                                    : null,
                                onTap: () => Navigator.pop(ctx, 0),
                              ),
                              ListTile(
                                title: Text(loc.sortPriceLow),
                                trailing: _sortMode == 1
                                    ? Icon(Icons.check, color: _purple)
                                    : null,
                                onTap: () => Navigator.pop(ctx, 1),
                              ),
                              ListTile(
                                title: Text(loc.sortPriceHigh),
                                trailing: _sortMode == 2
                                    ? Icon(Icons.check, color: _purple)
                                    : null,
                                onTap: () => Navigator.pop(ctx, 2),
                              ),
                            ],
                          ),
                        ),
                      );
                      if (v != null) {
                        setState(() => _sortMode = v);
                      }
                    },
                    icon: Icon(
                      Icons.filter_list_rounded,
                      color: _purple,
                      size: 18,
                    ),
                    label: Text(loc.sort),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _purple,
                      side:
                          const BorderSide(color: _purple, width: 1.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    loc.sortOrderLabel(_sortLabel(loc)),
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.favorite_border_rounded,
                              size: 72,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              loc.emptyFavorites,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              loc.startShoppingHint,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                    )
                  : (_gridView ? _buildGrid(items) : _buildList(items)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(List<CatalogProduct> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        itemCount: items.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.64,
        ),
        itemBuilder: (context, i) =>
            _ProductTile(product: items[i]),
      ),
    );
  }

  Widget _buildList(List<CatalogProduct> items) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final item = items[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              '/product-detail',
              arguments: item.id,
            ),
            child: Container(
              height: 132,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Image.network(
                      item.imageUrl,
                      fit: BoxFit.cover,
                      height: 132,
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            formatIdr(item.unitPrice),
                            style: const TextStyle(
                              color: _purple,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          _metaRow(item),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _metaRow(CatalogProduct item) {
    return Row(
      children: [
        Icon(Icons.place_outlined, size: 14, color: Colors.grey.shade600),
        Text(
          ' ${item.locationLabel}',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
        const SizedBox(width: 8),
        const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFFC107)),
        Text(
          ' ${item.ratingValue.toStringAsFixed(1)}',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
      ],
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({
    required this.product,
  });

  final CatalogProduct product;

  static const Color _purple = Color(0xFF7B42F6);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/product-detail',
        arguments: product.id,
      ),
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
              flex: 4,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          context.read<WishlistProvider>().toggle(product.id);
                        },
                        icon: const Icon(
                          Icons.favorite_rounded,
                          size: 18,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 8,
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        product.soldLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatIdr(product.unitPrice),
                    style: const TextStyle(
                      color: _purple,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.place_outlined,
                        size: 13,
                        color: Colors.grey.shade600,
                      ),
                      Expanded(
                        child: Text(
                          ' ${product.locationLabel}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: Color(0xFFFFC107),
                      ),
                      Text(
                        ' ${product.ratingValue.toStringAsFixed(1)}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
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
    );
  }
}
