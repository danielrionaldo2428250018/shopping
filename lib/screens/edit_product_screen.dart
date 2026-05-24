import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/catalog_data.dart';
import '../models/catalog_product.dart';
import '../providers/auth_provider.dart';
import '../providers/catalog_provider.dart';
import '../providers/seller_applications_provider.dart';
import '../utils/catalog_product_access.dart';
import '../services/image_service.dart';
import '../services/upload_service.dart';
import '../utils/app_screen_style.dart';
import '../utils/l10n_helpers.dart';
import '../utils/upload_error_l10n.dart';
import 'add_product_screen.dart' show DottedUploadBox, ProductPhotoGrid;

/// Form edit produk penjual — simpan ke Realtime Database.
class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key, this.productId});

  final String? productId;

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  CatalogProduct? _product;
  late final TextEditingController nameCtrl;
  late final TextEditingController priceCtrl;
  late final TextEditingController stockCtrl;
  late final TextEditingController descCtrl;

  String? category;
  String? condition;
  final List<File> _newImages = [];
  bool _saving = false;

  static const _conditions = ['Brand New', 'Like New', 'Good', 'Fair'];
  static const _categories = ['Electronics', 'Fashion', 'Home'];

  @override
  void initState() {
    super.initState();
    _product = catalogProductOrNull(widget.productId);
    final p = _product;
    nameCtrl = TextEditingController(text: p?.title ?? '');
    priceCtrl = TextEditingController(text: '${p?.unitPrice ?? 0}');
    stockCtrl = TextEditingController(text: '${p?.stock ?? 0}');
    descCtrl = TextEditingController(text: p?.description ?? '');
    category = p?.category;
    condition = p?.condition ?? 'Like New';
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    priceCtrl.dispose();
    stockCtrl.dispose();
    descCtrl.dispose();
    super.dispose();
  }

  int _parseInt(String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    return int.tryParse(digits) ?? 0;
  }

  Future<void> _showPhotoSourceSheet() async {
    final loc = context.l10n;
    await showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(loc.chooseFromGallery),
              onTap: () {
                Navigator.pop(ctx);
                _pickFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(loc.takePhotoNow),
              onTap: () {
                Navigator.pop(ctx);
                _pickFromCamera();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFromGallery() async {
    final remaining = ImageService.maxProductPhotos - _newImages.length;
    if (remaining <= 0) return;
    var files = await ImageService.pickMultipleFromGallery(max: remaining);
    if (!mounted || files.isEmpty) return;
    setState(() => _newImages.addAll(files));
  }

  Future<void> _pickFromCamera() async {
    if (!await ImageService.ensureCameraAccess()) return;
    final file = await ImageService.pickFromCamera();
    if (!mounted || file == null) return;
    setState(() => _newImages.add(file));
  }

  bool _canManage(CatalogProduct p) {
    final auth = context.read<AuthProvider>();
    final store =
        context.read<SellerApplicationsProvider>().myApprovedStore;
    return canManageCatalogProduct(
      product: p,
      uid: auth.uid,
      accountEmail: auth.resolvedAccountEmail,
      isSeller: auth.isSeller,
      myStoreName: store?.storeName.trim(),
    );
  }

  Future<void> _save() async {
    final loc = context.l10n;
    final p = _product;
    if (p == null) return;
    if (!_canManage(p)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.publishFailed)),
      );
      return;
    }

    final title = nameCtrl.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.productNameRequired)),
      );
      return;
    }
    if (category == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.categoryRequired)),
      );
      return;
    }
    final price = _parseInt(priceCtrl.text);
    final stock = _parseInt(stockCtrl.text);
    if (price <= 0 || stock <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.priceRequired)),
      );
      return;
    }

    setState(() => _saving = true);
    var imageUrl = p.imageUrl;
    if (_newImages.isNotEmpty) {
      try {
        final urls = await UploadService.uploadMultiple(
          _newImages.take(1).toList(),
        );
        if (urls.isNotEmpty) imageUrl = urls.first;
      } on UploadFailure catch (e) {
        if (!mounted) return;
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(uploadFailureMessage(loc, e))),
        );
        return;
      } catch (e) {
        if (kDebugMode) debugPrint('upload edit: $e');
      }
    }

    final auth = context.read<AuthProvider>();
    final claimUid = auth.uid ?? p.sellerUid;
    final updated = p.copyWith(
      title: title,
      unitPrice: price,
      stock: stock,
      imageUrl: imageUrl,
      sellerUid: p.sellerUid.isNotEmpty ? p.sellerUid : claimUid,
      category: category!,
      condition: condition ?? p.condition,
      description: descCtrl.text.trim(),
    );

    final ok =
        await context.read<CatalogProvider>().updateProduct(updated);
    if (!mounted) return;
    setState(() => _saving = false);
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.productUpdated)),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.publishFailed)),
      );
    }
  }

  Future<void> _confirmDelete() async {
    final loc = context.l10n;
    final p = _product;
    if (p == null) return;
    if (!_canManage(p)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.publishFailed)),
      );
      return;
    }
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
    if (yes != true || !mounted) return;

    setState(() => _saving = true);
    final ok = await context.read<CatalogProvider>().deleteProduct(p.id);
    if (!mounted) return;
    setState(() => _saving = false);
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.productDeleted)),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.publishFailed)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;
    final p = _product;

    if (p == null) {
      return Scaffold(
        appBar: AppBar(title: Text(loc.edit)),
        body: Center(child: Text(loc.productNotFound)),
      );
    }

    return Scaffold(
      backgroundColor: appScaffoldBackground(context),
      appBar: AppBar(
        title: Text(loc.edit),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _saving ? null : _confirmDelete,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _newImages.isNotEmpty
                        ? Image.file(
                            _newImages.first,
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            p.imageUrl,
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 100,
                    child: _newImages.isEmpty
                        ? DottedUploadBox(onTap: _showPhotoSourceSheet)
                        : ProductPhotoGrid(
                            files: _newImages,
                            onAdd: _showPhotoSourceSheet,
                            onRemove: (i) =>
                                setState(() => _newImages.removeAt(i)),
                          ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameCtrl,
                    decoration: InputDecoration(
                      labelText: loc.productName,
                      filled: true,
                      fillColor: appCardColor(context),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _categories.contains(category) ? category : null,
                    decoration: InputDecoration(
                      labelText: loc.selectCategory,
                      filled: true,
                      fillColor: appCardColor(context),
                    ),
                    items: _categories
                        .map(
                          (c) => DropdownMenuItem(
                            value: c,
                            child: Text(c),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => category = v),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: priceCtrl,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: loc.priceLabel,
                            filled: true,
                            fillColor: appCardColor(context),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: stockCtrl,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: loc.stock,
                            filled: true,
                            fillColor: appCardColor(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _conditions.contains(condition) ? condition : null,
                    decoration: InputDecoration(
                      labelText: loc.condition,
                      filled: true,
                      fillColor: appCardColor(context),
                    ),
                    items: _conditions
                        .map(
                          (c) => DropdownMenuItem(
                            value: c,
                            child: Text(c),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => condition = v),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descCtrl,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: loc.description,
                      filled: true,
                      fillColor: appCardColor(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: FilledButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(loc.save),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
