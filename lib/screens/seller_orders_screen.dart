import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/catalog_data.dart';
import '../models/order_status.dart';
import '../models/shop_order.dart';
import '../providers/orders_provider.dart';
import '../providers/seller_applications_provider.dart';
import '../utils/app_screen_style.dart';
import '../utils/l10n_helpers.dart';
import '../utils/order_flow_l10n.dart';
import '../widgets/app_network_image.dart';

/// Pesanan masuk untuk penjual — kemas, kirim, atau batalkan.
class SellerOrdersScreen extends StatefulWidget {
  const SellerOrdersScreen({super.key});

  static const route = '/seller-orders';
  static const Color _purple = Color(0xFF7B42F6);

  @override
  State<SellerOrdersScreen> createState() => _SellerOrdersScreenState();
}

class _SellerOrdersScreenState extends State<SellerOrdersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _prepare());
  }

  Future<void> _prepare() async {
    if (!mounted) return;
    final orders = context.read<OrdersProvider>();
    await orders.ensureSellerRtdbLinked();
    if (!mounted) return;
    orders.refreshSellerSubscriptions();
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;
    final orders = context.watch<OrdersProvider>().sellerOrders;
    final store = context.watch<SellerApplicationsProvider>().myApprovedStore;

    return Scaffold(
      backgroundColor: appScaffoldBackground(context),
      appBar: AppBar(
        title: Text(orderSellerOrdersTitle(loc)),
        backgroundColor: SellerOrdersScreen._purple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => context.read<OrdersProvider>().refreshSellerSubscriptions(),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: orders.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade400),
                    const SizedBox(height: 12),
                    Text(
                      loc.noOrders,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    if (store != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Toko: ${store.storeName}\nPastikan pembeli login & buat pesanan baru setelah APK terbaru.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade600, height: 1.4),
                      ),
                    ],
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: appPageInsets(context, top: 12, bottom: 24),
              itemCount: orders.length,
              itemBuilder: (context, i) => _SellerOrderCard(order: orders[i]),
            ),
    );
  }
}

class _SellerOrderCard extends StatelessWidget {
  const _SellerOrderCard({required this.order});

  final ShopOrder order;

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;
    final orders = context.read<OrdersProvider>();
    final line = order.lines.first;
    final status = order.status;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  order.id,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Chip(
                  label: Text(
                    orderStatusLabel(loc, status),
                    style: const TextStyle(fontSize: 11),
                  ),
                ),
              ],
            ),
            Text(
              '${order.buyerName} • ${formatIdr(order.total)}',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: AppNetworkImage(
                    url: line.imageUrl,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${line.title} × ${line.quantity}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            if (order.trackingNumber != null) ...[
              const SizedBox(height: 8),
              Text(
                loc.trackingNumber(order.trackingNumber!),
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              ),
            ],
            const SizedBox(height: 12),
            if (status == OrderStatus.processing)
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    orders.sellerStartPacking(order.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(orderStatusLabel(loc, OrderStatus.packing)),
                      ),
                    );
                  },
                  child: Text(orderStartPackingBtn(loc)),
                ),
              ),
            if (status == OrderStatus.packing) ...[
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    orders.sellerFinishPacking(order.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          orderStatusLabel(loc, OrderStatus.inProcess),
                        ),
                      ),
                    );
                  },
                  child: Text(orderFinishPackingBtn(loc)),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _confirmCancel(context, order.id),
                  child: Text(orderCancelOrderBtn(loc)),
                ),
              ),
            ],
            if (status == OrderStatus.inProcess)
              Text(
                orderCannotCancelInProcess(loc),
                style: TextStyle(fontSize: 12, color: Colors.orange.shade800),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmCancel(BuildContext context, String orderId) async {
    final loc = context.l10n;
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(orderCancelOrderBtn(loc)),
        content: Text(orderCancelConfirmQ(loc)),
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
    if (yes != true || !context.mounted) return;
    context.read<OrdersProvider>().sellerCancelOrder(orderId);
  }
}
