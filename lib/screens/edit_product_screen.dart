import 'package:flutter/material.dart';

import 'add_product_screen.dart' show DottedUploadBox;
import '../utils/l10n_helpers.dart';

/// Form edit produk — penjual.
class EditProductScreen extends StatefulWidget {
  const EditProductScreen({
    super.key,
  });

  @override
  State<EditProductScreen> createState() =>
      _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  static const Color _purple = Color(0xFF7B42F6);

  late final TextEditingController nameCtrl;
  late final TextEditingController priceCtrl;
  late final TextEditingController stockCtrl;
  late final TextEditingController descCtrl;

  String? category;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController();
    priceCtrl = TextEditingController(text: '0');
    stockCtrl = TextEditingController(text: '0');
    descCtrl = TextEditingController();
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    priceCtrl.dispose();
    stockCtrl.dispose();
    descCtrl.dispose();
    super.dispose();
  }

  InputDecoration _input(String hint, {String? label}) {
    return InputDecoration(
      labelText: label,
      hintText: hint.isEmpty ? null : hint,
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
                crossAxisAlignment:
                    CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(
                      8,
                      12,
                      16,
                      20,
                    ),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF7428F0),
                          Color(0xFFC1A0FF),
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
                          const SizedBox(height: 10),
                          Text(
                            loc.edit,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            loc.productInfo,
                            style: TextStyle(
                              color: Colors.white.withValues(
                                alpha: 0.9,
                              ),
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
                        Container(
                          width: double.infinity,
                          padding:
                              const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey.shade200,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                loc.productImages,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 14),
                              SizedBox(
                                height: 120,
                                width: double.infinity,
                                child: DottedUploadBox(
                                  onTap: () {},
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding:
                              const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey.shade200,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                loc.productInfo,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: nameCtrl,
                                decoration: _input(
                                  '',
                                  label: loc.productName,
                                ),
                              ),
                              const SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                value: category,
                                hint: Text(loc.selectCategory),
                                decoration:
                                    _input('', label: loc.selectCategory),
                                items: [
                                  DropdownMenuItem(
                                    value: 'Electronics',
                                    child: Text(loc.catElectronics),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Fashion',
                                    child: Text(loc.catFashion),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Home',
                                    child: Text(loc.catHome),
                                  ),
                                ],
                                onChanged: (v) {
                                  if (v != null) {
                                    setState(() => category = v);
                                  }
                                },
                              ),
                              const SizedBox(height: 16),
                              Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: priceCtrl,
                                      keyboardType:
                                          TextInputType.number,
                                      decoration: _input(
                                        '',
                                        label: loc.priceLabel,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextField(
                                      controller: stockCtrl,
                                      keyboardType:
                                          TextInputType.number,
                                      decoration: _input(
                                        '',
                                        label: loc.stock,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: descCtrl,
                                maxLines: 4,
                                decoration: _input(
                                  '',
                                  label: loc.description,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 96),
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
                padding: const EdgeInsets.fromLTRB(
                  16,
                  12,
                  16,
                  16,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () =>
                            Navigator.pop(context),
                        style: FilledButton.styleFrom(
                          backgroundColor: _purple
                              .withValues(alpha: 0.12),
                          foregroundColor: _purple,
                          elevation: 0,
                          padding:
                              const EdgeInsets.symmetric(
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
                      child: FilledButton.icon(
                        onPressed: () =>
                            Navigator.pop(context),
                        icon: const Icon(
                          Icons.save_outlined,
                          color: Colors.white,
                        ),
                        label: Text(
                          loc.save,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: _purple,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding:
                              const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(14),
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
}
