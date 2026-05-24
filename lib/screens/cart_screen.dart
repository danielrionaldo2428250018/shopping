import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/catalog_data.dart';
import '../providers/cart_provider.dart';
import '../utils/app_screen_style.dart';
import '../utils/responsive_layout.dart';
import '../widgets/app_network_image.dart';
import '../utils/l10n_helpers.dart';
import '../widgets/cart_qty_field.dart';

/// Keranjang belanja — ubah qty, hapus, lanjut checkout.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  static const Color _purple = Color(0xFF7B42F6);

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: appScaffoldBackground(context),
      appBar: AppBar(
        title: Text(
          loc.cart,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, _) {
          if (cart.lines.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      loc.emptyCart,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: appPrimaryText(context),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      loc.startShoppingHint,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: appMutedTextColor(context)),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: () {
                        Navigator.popUntil(context, (r) => r.isFirst);
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: scheme.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 14,
                        ),
                      ),
                      child: Text(loc.startShopping),
                    ),
                  ],
                ),
              ),
            );
          }

          final r = ResponsiveLayout.of(context);
          final thumb = r.isCompact ? 84.0 : 100.0;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: appPageInsets(context, top: 12, bottom: 8),
                  itemCount: cart.lines.length,
                  itemBuilder: (context, index) {
                    final line = cart.lines[index];
                    final p = line.product;
                    return Dismissible(
                      key: ValueKey(p.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: Colors.red.shade400,
                        child: const Icon(Icons.delete_outline, color: Colors.white),
                      ),
                      onDismissed: (_) =>
                          cart.removeLine(p.id),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: appCardColor(context),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: appBorderColor(context)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(15),
                              ),
                              child: AppNetworkImage(
                                url: p.imageUrl,
                                width: thumb,
                                height: thumb,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      p.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      formatIdr(p.unitPrice),
                                      style: const TextStyle(
                                        color: _purple,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      p.sellerName,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        CartQtyField(
                                          productId: p.id,
                                          quantity: line.quantity,
                                          maxStock: p.stock,
                                          cart: cart,
                                          accent: _purple,
                                        ),
                                        const Spacer(),
                                        Text(
                                          formatIdr(line.lineTotal),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Material(
                elevation: 12,
                color: appCardElevated(context),
                child: SafeArea(
                  child: Padding(
                    padding: appPageInsets(context, top: 12, bottom: 16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              loc.subtotalLine(cart.itemCount),
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                            Text(
                              formatIdr(cart.subtotal),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/checkout');
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: _purple,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              loc.checkout,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
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
          );
        },
      ),
    );
  }
}
