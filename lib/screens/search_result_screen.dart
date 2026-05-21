import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_branding.dart';
import '../utils/l10n_helpers.dart';
import '../providers/catalog_provider.dart';
import '../data/catalog_data.dart';
import '../models/catalog_product.dart';

/// Hasil pencarian / filter kategori / urutan dari **pencarian foto**.
class SearchResultScreen extends StatefulWidget {
  const SearchResultScreen({
    super.key,
    this.initialQuery = '',
    this.categoryFilter,
    this.imageRankedProductIds,
  });

  final String initialQuery;
  final String? categoryFilter;

  /// Urutan ID produk dari pencarian visual (foto).
  final List<String>? imageRankedProductIds;

  @override
  State<SearchResultScreen> createState() =>
      _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  late TextEditingController _ctrl;
  late String _sort; // relevance | price_low | price_high

  bool get _imageMode =>
      widget.imageRankedProductIds != null &&
      widget.imageRankedProductIds!.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initialQuery);
    _sort = 'relevance';
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _applySort(List<CatalogProduct> sorted) {
    switch (_sort) {
      case 'price_low':
        sorted.sort((a, b) => a.unitPrice.compareTo(b.unitPrice));
        break;
      case 'price_high':
        sorted.sort((a, b) => b.unitPrice.compareTo(a.unitPrice));
        break;
      default:
        break;
    }
  }

  List<CatalogProduct> _results() {
    if (_imageMode) {
      final out = <CatalogProduct>[];
      for (final id in widget.imageRankedProductIds!) {
        final p = catalogProductById(id);
        if (p != null) out.add(p);
      }
      if (out.isEmpty) return List<CatalogProduct>.from(kCatalogProducts);
      final sorted = List<CatalogProduct>.from(out);
      _applySort(sorted);
      return sorted;
    }

    List<CatalogProduct> list;
    if (widget.categoryFilter != null &&
        widget.categoryFilter!.isNotEmpty) {
      list = catalogByCategory(widget.categoryFilter!);
    } else {
      list = catalogSearch(_ctrl.text);
    }
    final sorted = List<CatalogProduct>.from(list);
    _applySort(sorted);
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    context.watch<CatalogProvider>();
    final loc = context.l10n;
    final results = _results();

    return Scaffold(
            appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: TextField(
            controller: _ctrl,
            readOnly: _imageMode,
            decoration: InputDecoration(
              hintText: _imageMode
                  ? loc.searchPhotoSortHint
                  : loc.searchProductsHint,
              filled: true,
              fillColor: const Color(0xFFEEEEEE),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              prefixIcon: Icon(
                _imageMode ? Icons.photo_camera_rounded : Icons.search_rounded,
                color: AppBranding.seedColor,
              ),
            ),
            onSubmitted: (_) {
              if (!_imageMode) setState(() {});
            },
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            initialValue: _sort,
            onSelected: (v) => setState(() => _sort = v),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'relevance',
                child: Text(loc.sortRelevance),
              ),
              PopupMenuItem(
                value: 'price_low',
                child: Text(loc.sortPriceLow),
              ),
              PopupMenuItem(
                value: 'price_high',
                child: Text(loc.sortPriceHigh),
              ),
            ],
            icon: const Icon(Icons.sort_rounded),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(
              '${loc.productCount(results.length)}'
              '${widget.categoryFilter != null ? ' · ${widget.categoryFilter}' : ''}'
              '${_imageMode ? ' · cocok foto' : ''}',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: results.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          loc.noProductsYet,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: results.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.68,
                    ),
                    itemBuilder: (context, index) {
                      final p = results[index];
                      return _ProductTile(
                        product: p,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({
    required this.product,
  });

  final CatalogProduct product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/product-detail',
          arguments: product.id,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
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
                    product.imageUrl,
                    fit: BoxFit.cover,
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
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
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
                  const SizedBox(height: 6),
                  Text(
                    formatIdr(product.unitPrice),
                    style: const TextStyle(
                      color: AppBranding.accentDeep,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
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
