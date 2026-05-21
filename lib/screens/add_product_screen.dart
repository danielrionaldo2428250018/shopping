import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/catalog_product.dart';
import '../providers/auth_provider.dart';
import '../providers/catalog_provider.dart';
import '../providers/user_profile_provider.dart';
import '../utils/l10n_helpers.dart';
import '../l10n/app_localizations.dart';

/// Form tambah produk — penjual (simpan ke Realtime Database).
class AddProductScreen extends StatefulWidget {
  const AddProductScreen({
    super.key,
  });

  @override
  State<AddProductScreen> createState() =>
      _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  static const Color _purple = Color(0xFF7B42F6);

  final nameCtrl = TextEditingController();
  final priceCtrl = TextEditingController(text: '0');
  final stockCtrl = TextEditingController(text: '0');
  final descCtrl = TextEditingController();

  String? category;
  String condition = 'Like New';
  bool _publishing = false;

  static const _conditions = [
    'Brand New',
    'Like New',
    'Good',
    'Fair',
  ];

  static const _categories = ['Electronics', 'Fashion', 'Home'];

  String _conditionLabel(AppLocalizations loc, String c) {
    switch (c) {
      case 'Brand New':
        return loc.condBrandNew;
      case 'Like New':
        return loc.condLikeNew;
      case 'Good':
        return loc.condGood;
      case 'Fair':
        return loc.condFair;
      default:
        return c;
    }
  }

  String _categoryLabel(AppLocalizations loc, String c) {
    switch (c) {
      case 'Electronics':
        return loc.catElectronics;
      case 'Fashion':
        return loc.catFashion;
      case 'Home':
        return loc.catHome;
      default:
        return c;
    }
  }

  InputDecoration _input(String hint, {String? helper}) {
    return InputDecoration(
      hintText: hint,
      helperText: helper,
      helperMaxLines: 2,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            const BorderSide(color: _purple, width: 1.4),
      ),
    );
  }

  int _parseInt(String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    return int.tryParse(digits) ?? 0;
  }

  Future<void> _publishProduct() async {
    final loc = context.l10n;
    final title = nameCtrl.text.trim();
    if (title.isEmpty) {
      _showSnack(loc.productNameRequired);
      return;
    }
    if (category == null) {
      _showSnack(loc.categoryRequired);
      return;
    }
    final price = _parseInt(priceCtrl.text);
    final stock = _parseInt(stockCtrl.text);
    if (price <= 0) {
      _showSnack(loc.priceRequired);
      return;
    }
    if (stock <= 0) {
      _showSnack(loc.stockRequired);
      return;
    }

    final profile = context.read<UserProfileProvider>();
    final auth = context.read<AuthProvider>();
    final sellerName = auth.displayName?.trim().isNotEmpty == true
        ? auth.displayName!.trim()
        : profile.displayNameOrDefault;
    final initials = sellerName.isNotEmpty
        ? sellerName.substring(0, 1).toUpperCase()
        : 'P';

    final product = CatalogProduct(
      id: '',
      title: title,
      unitPrice: price,
      imageUrl:
          'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=400',
      sellerName: sellerName,
      sellerInitials: initials,
      sellerRating: 4.8,
      locationLabel: 'Indonesia',
      ratingValue: 4.5,
      reviewsCount: 0,
      soldLabel: '0 terjual',
      stock: stock,
      category: category!,
      condition: condition,
      description: descCtrl.text.trim(),
      weightLabel: '-',
    );

    setState(() => _publishing = true);
    final ok =
        await context.read<CatalogProvider>().publishProduct(product: product);
    if (!mounted) return;
    setState(() => _publishing = false);

    if (ok) {
      _showSnack(loc.productPublished);
      Navigator.pop(context);
    } else {
      _showSnack(loc.publishFailed);
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    priceCtrl.dispose();
    stockCtrl.dispose();
    descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(8, 12, 16, 24),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF732EF2),
                          Color(0xFFB28BFF),
                        ],
                      ),
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.white
                                  .withValues(alpha: 0.2),
                            ),
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.chevron_left),
                            color: Colors.white,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            loc.addNewProduct,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            loc.addProductPhotoHint,
                            style: TextStyle(
                              color: Colors.white
                                  .withValues(alpha: 0.88),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            loc.productInfo,
                            style: TextStyle(
                              color: Colors.white
                                  .withValues(alpha: 0.9),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        _card(
                          title: loc.addProduct,
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              AspectRatio(
                                aspectRatio: 1.4,
                                child: DottedUploadBox(
                                  onTap: () {},
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(
                                    Icons.image_outlined,
                                    size: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      loc.addProductPhotoHint,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color:
                                            Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _card(
                          title: loc.productInfo,
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                loc.productName,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: nameCtrl,
                                decoration: _input(
                                  'Enter product name',
                                  helper:
                                      'Use a clear and descriptive name',
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                loc.selectCategory,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                value: category,
                                hint: Text(loc.selectCategory),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding:
                                      const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 4,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: _purple,
                                      width: 1.4,
                                    ),
                                  ),
                                ),
                                items: _categories
                                    .map(
                                      (c) => DropdownMenuItem(
                                        value: c,
                                        child: Text(_categoryLabel(loc, c)),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (v) =>
                                    setState(() => category = v),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          loc.priceLabel,
                                          style: TextStyle(
                                            fontWeight:
                                                FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        TextField(
                                          controller: priceCtrl,
                                          keyboardType:
                                              TextInputType.number,
                                          decoration: _input('0'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          loc.stock,
                                          style: TextStyle(
                                            fontWeight:
                                                FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        TextField(
                                          controller: stockCtrl,
                                          keyboardType:
                                              TextInputType.number,
                                          decoration: _input('0'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                loc.description,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: descCtrl,
                                maxLines: 4,
                                decoration: _input(
                                  'Describe your product in detail...',
                                  helper:
                                      'Include key features, condition, and other important details',
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                loc.condition,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: _conditions.map((c) {
                                  final sel = condition == c;
                                  return ChoiceChip(
                                    label: Text(_conditionLabel(loc, c)),
                                    selected: sel,
                                    onSelected: (_) => setState(
                                      () => condition = c,
                                    ),
                                    selectedColor:
                                        _purple.withValues(alpha: 0.2),
                                    labelStyle: TextStyle(
                                      color: sel
                                          ? _purple
                                          : Colors.black87,
                                      fontWeight: sel
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                    ),
                                    side: BorderSide(
                                      color: sel
                                          ? _purple
                                          : Colors.grey.shade300,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(
                                            12,
                                          ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Material(
            color: Colors.white,
            elevation: 12,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () => Navigator.pop(context),
                        style: FilledButton.styleFrom(
                          backgroundColor: _purple
                              .withValues(alpha: 0.12),
                          foregroundColor: _purple,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          loc.cancel,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: FilledButton(
                        onPressed:
                            _publishing ? null : _publishProduct,
                        style: FilledButton.styleFrom(
                          backgroundColor: _purple,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                        ),
                        child: _publishing
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                loc.publishProduct,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class DottedUploadBox extends StatelessWidget {
  const DottedUploadBox({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey.shade50,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.grey.shade400,
              width: 1.5,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 40,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(height: 8),
                Text(
                  'Upload',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
