import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/catalog_data.dart';
import '../models/shop_order.dart';
import '../providers/orders_provider.dart';
import '../utils/l10n_helpers.dart';
import 'order_invoice_screen.dart';

/// Pesanan user — tab + kartu; data dari pesanan demo + checkout baru.
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({
    super.key,
  });

  @override
  State<OrdersScreen> createState() =>
      _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  static const Color _purple = Color(0xFF7B42F6);

  int _tab = 0;

  static Color _statusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'Processing':
        return Colors.orange;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  static String _fmtDate(DateTime d) {
    const m = <int, String>{
      1: 'Jan',
      2: 'Feb',
      3: 'Mar',
      4: 'Apr',
      5: 'May',
      6: 'Jun',
      7: 'Jul',
      8: 'Aug',
      9: 'Sep',
      10: 'Oct',
      11: 'Nov',
      12: 'Dec',
    };
    return '${m[d.month]} ${d.day}, ${d.year}';
  }

  List<ShopOrder> _filtered(List<ShopOrder> all) {
    if (_tab == 0) return all;
    if (_tab == 1) {
      return all.where((o) => o.status == 'Processing').toList();
    }
    return all.where((o) => o.status == 'Completed').toList();
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;
    final orders = context.watch<OrdersProvider>().orders;
    final list = _filtered(orders);
    final pending =
        orders.where((o) => o.status == 'Processing').length;
    final done =
        orders.where((o) => o.status == 'Completed').length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF7435F8),
                  Color(0xFFA97DFF),
                ],
              ),
            ),
            padding: EdgeInsets.fromLTRB(
              8,
              MediaQuery.paddingOf(context).top + 8,
              16,
              22,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor:
                        Colors.white.withValues(alpha: 0.2),
                  ),
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  color: Colors.white,
                  iconSize: 18,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loc.myOrders,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        loc.orders,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _pill(loc.ordersTabAll(orders.length), 0),
                  const SizedBox(width: 10),
                  _pill(loc.ordersTabPending(pending), 1),
                  const SizedBox(width: 10),
                  _pill(loc.ordersTabCompleted(done), 2),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
              itemCount: list.length,
              itemBuilder: (context, i) {
                final itemLoc = context.l10n;
                final o = list[i];
                final stColor = _statusColor(o.status);

                IconData statusIcon =
                    Icons.more_horiz_rounded;
                if (o.status == 'Completed') {
                  statusIcon =
                      Icons.check_circle_outline_rounded;
                } else if (o.status ==
                    'Processing') {
                  statusIcon =
                      Icons.local_shipping_outlined;
                } else if (o.status == 'Cancelled') {
                  statusIcon = Icons.cancel_outlined;
                }

                final line = o.lines.first;

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        OrderInvoiceScreen.route,
                        arguments: o.id,
                      );
                    },
                    child: Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            o.id,
                            style: const TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            _fmtDate(o.createdAt),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  stColor.withValues(alpha: 0.12),
                              borderRadius:
                                  BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  statusIcon,
                                  size: 14,
                                  color: stColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  orderStatusLabel(itemLoc, o.status),
                                  style: TextStyle(
                                    color: stColor,
                                    fontWeight:
                                        FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(12),
                            child: Image.network(
                              line.imageUrl,
                              width: 72,
                              height: 72,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  Container(
                                width: 72,
                                height: 72,
                                color: Colors.grey.shade200,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  line.title,
                                  style: const TextStyle(
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  line.storeName,
                                  style: TextStyle(
                                    color: Colors
                                        .grey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${formatIdr(line.unitPrice)} × ${line.quantity}',
                                  style: const TextStyle(
                                    color: _purple,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  itemLoc.orderTotalAmount(formatIdr(o.total)),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (o.trackingNumber != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding:
                              const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius:
                                BorderRadius.circular(10),
                          ),
                          child: Text(
                            itemLoc.trackingNumber(o.trackingNumber!),
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          if (o.status ==
                              'Completed') ...[
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/reviews',
                                    arguments: {'orderId': o.id},
                                  );
                                },
                                style: ElevatedButton
                                    .styleFrom(
                                  backgroundColor:
                                      _purple,
                                  elevation: 0,
                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                              12,
                                            ),
                                  ),
                                ),
                                child: Text(
                                  loc.orderReviewBtn,
                                  style: TextStyle(
                                    color:
                                        Colors.white,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Expanded(
                            child:
                                OutlinedButton(
                              onPressed: () {
                                if (o.status ==
                                    'Processing') {
                                  context
                                      .read<
                                          OrdersProvider>()
                                      .ensureTracking(
                                        o.id,
                                      );
                                  final cur = context
                                      .read<
                                          OrdersProvider>()
                                      .orders
                                      .firstWhere(
                                        (e) =>
                                            e.id ==
                                            o.id,
                                      );
                                  showDialog<void>(
                                    context: context,
                                    builder:
                                        (ctx) =>
                                            AlertDialog(
                                      title: Text(loc.orderTrackPackage),
                                      content: Text(
                                        loc.orderTrackingNumber(
                                          cur.trackingNumber ?? '-',
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(ctx),
                                          child: Text(loc.close),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  Navigator.pushNamed(
                                    context,
                                    '/product-detail',
                                    arguments: o
                                        .lines
                                        .first
                                        .productId,
                                  );
                                }
                              },
                              style: OutlinedButton
                                  .styleFrom(
                                foregroundColor:
                                    _purple,
                                side: const BorderSide(
                                  color:
                                      _purple,
                                ),
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                            12,
                                          ),
                                ),
                              ),
                              child: Text(
                                o.status == 'Processing'
                                    ? loc.orderTrackOrder
                                    : loc.orderBuyAgain,
                              ),
                            ),
                          ),
                          if (o.status ==
                              'Processing') ...[
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: () async {
                                final ok =
                                    await showDialog<
                                        bool>(
                                  context: context,
                                  builder:
                                      (ctx) =>
                                          AlertDialog(
                                    title: Text(loc.orderCancelQ),
                                    content: Text(loc.orderCancelBody),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(ctx, false),
                                        child: Text(loc.no),
                                      ),
                                      FilledButton(
                                        onPressed: () =>
                                            Navigator.pop(ctx, true),
                                        child: Text(loc.orderCancelConfirm),
                                      ),
                                    ],
                                  ),
                                );
                                if (ok == true &&
                                    context.mounted) {
                                  context
                                      .read<
                                          OrdersProvider>()
                                      .cancelOrder(
                                        o.id,
                                      );
                                  ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(
                                    SnackBar(
                                      content: Text(loc.orderCancelledSnack),
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                loc.orderCancelBtn,
                                style:
                                    TextStyle(
                                  color: Colors.grey
                                      .shade800,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _pill(String label, int idx) {
    final selected = _tab == idx;
    return GestureDetector(
      onTap: () => setState(() => _tab = idx),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: selected ? _purple : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected ? _purple : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
