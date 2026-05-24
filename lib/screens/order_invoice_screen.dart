import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/catalog_data.dart';
import '../models/order_status.dart';
import '../providers/orders_provider.dart';
import '../utils/l10n_helpers.dart';
import '../widgets/app_network_image.dart';
import '../widgets/order_review_dialog.dart';

/// Invoice / ringkasan pesanan dari My Orders.
class OrderInvoiceScreen extends StatelessWidget {
  const OrderInvoiceScreen({
    super.key,
    required this.orderId,
  });

  final String orderId;

  static const route = '/order-invoice';

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;
    final order = context.watch<OrdersProvider>().orderById(orderId);

    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: Text(loc.myOrders)),
        body: Center(child: Text(loc.noOrders)),
      );
    }

    final o = order;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.myOrders),
      ),
      bottomNavigationBar: o.status == OrderStatus.inProcess
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: FilledButton.icon(
                  onPressed: () async {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(loc.orderConfirmReceivedQ),
                        content: Text(loc.orderConfirmReceivedBody),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: Text(loc.no),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: Text(loc.orderConfirmReceivedBtn),
                          ),
                        ],
                      ),
                    );
                    if (ok != true || !context.mounted) return;
                    final ordersProv = context.read<OrdersProvider>();
                    final done = ordersProv.completeOrder(orderId);
                    if (!context.mounted) return;
                    if (done) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(loc.orderCompletedSnack)),
                      );
                      final updated = ordersProv.orderById(orderId);
                      if (updated != null && !updated.reviewed) {
                        await showOrderReviewDialog(context, order: updated);
                      }
                    }
                  },
                  icon: const Icon(Icons.check_circle_outline_rounded),
                  label: Text(loc.orderConfirmReceivedBtn),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            )
          : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    o.id,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    loc.orderDate(_fmt(o.createdAt)),
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    orderStatusLabel(loc, o.status),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: o.status == OrderStatus.completed
                          ? Colors.green.shade700
                          : Colors.grey.shade800,
                    ),
                  ),
                  if (o.completedAt != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      loc.orderCompletedAt(_fmt(o.completedAt!)),
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  if (o.trackingNumber != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      loc.trackingNumber(o.trackingNumber!),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              loc.productsLabel,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            ...o.lines.map((line) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: AppNetworkImage(
                        url: line.imageUrl,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            line.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            line.storeName,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${line.quantity} × ${formatIdr(line.unitPrice)}',
                          ),
                        ],
                      ),
                    ),
                    Text(
                      formatIdr(line.unitPrice * line.quantity),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _row(loc.subtotalLine(o.lines.length), formatIdr(o.subtotal)),
                  _row(loc.shippingSection, formatIdr(o.shippingFee)),
                  if (o.discount > 0)
                    _row(loc.promoCode, '- ${formatIdr(o.discount)}'),
                  const Divider(height: 20),
                  _row(
                    loc.totalPayment,
                    formatIdr(o.total),
                    bold: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _fmt(DateTime d) =>
      '${d.day}/${d.month}/${d.year} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  Widget _row(String a, String b, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(a),
          Text(
            b,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.w500,
              fontSize: bold ? 17 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
