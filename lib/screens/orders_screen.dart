import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/catalog_data.dart';
import '../models/shop_order.dart';
import '../providers/orders_provider.dart';
import '../utils/app_screen_style.dart';
import '../widgets/app_network_image.dart';
import '../styles/app_colors_extension.dart';
import '../models/order_status.dart';
import '../utils/l10n_helpers.dart';
import '../utils/order_flow_l10n.dart';
import '../widgets/order_review_dialog.dart';
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
      case OrderStatus.completed:
        return Colors.green;
      case OrderStatus.processing:
        return Colors.orange;
      case OrderStatus.packing:
        return Colors.blue;
      case OrderStatus.inProcess:
        return Colors.deepPurple;
      case OrderStatus.cancelled:
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
      return all
          .where(
            (o) =>
                o.status == OrderStatus.processing ||
                o.status == OrderStatus.packing ||
                o.status == OrderStatus.inProcess,
          )
          .toList();
    }
    return all.where((o) => o.status == OrderStatus.completed).toList();
  }

  Future<void> _confirmOrderReceived(
    BuildContext context,
    String orderId,
  ) async {
    final loc = context.l10n;
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
    final orders = context.read<OrdersProvider>();
    final done = orders.completeOrder(orderId);
    if (!context.mounted) return;
    if (done) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.orderCompletedSnack)),
      );
      final order = orders.orderById(orderId);
      if (order != null && !order.reviewed) {
        await showOrderReviewDialog(context, order: order);
      }
    }
  }

  void _showPlaceholderSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;
    final orders = context.watch<OrdersProvider>().orders;
    final list = _filtered(orders);
    final colors = appColors(context);

    return Scaffold(
      backgroundColor: appScaffoldBackground(context),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colors.profileHeaderGradient,
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
                    backgroundColor: colors.headerIconButtonBg,
                  ),
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  color: colors.onHeader,
                  iconSize: 18,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loc.myOrders,
                        style: TextStyle(
                          color: colors.onHeader,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        loc.orders,
                        style: TextStyle(
                          color: colors.onHeader.withValues(alpha: 0.85),
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
            padding: appPageInsets(context, top: 14, bottom: 6),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _pill(loc.ordersTabAll, 0),
                  const SizedBox(width: 10),
                  _pill(loc.ordersTabPending, 1),
                  const SizedBox(width: 10),
                  _pill(loc.ordersTabCompleted, 2),
                ],
              ),
            ),
          ),
          Expanded(
            child: list.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            size: 72,
                            color: appMutedTextColor(context),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            loc.noOrders,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: appPrimaryText(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
              padding: appPageInsets(context, top: 8, bottom: 28),
              itemCount: list.length,
              itemBuilder: (context, i) {
                final itemLoc = context.l10n;
                final o = list[i];
                final stColor = _statusColor(o.status);

                IconData statusIcon =
                    Icons.more_horiz_rounded;
                if (o.status == OrderStatus.completed) {
                  statusIcon =
                      Icons.check_circle_outline_rounded;
                } else if (o.status == OrderStatus.packing) {
                  statusIcon = Icons.inventory_2_outlined;
                } else if (o.status == OrderStatus.inProcess) {
                  statusIcon = Icons.local_shipping_outlined;
                } else if (o.status == OrderStatus.processing) {
                  statusIcon = Icons.hourglass_top_rounded;
                } else if (o.status == OrderStatus.cancelled) {
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
                    color: appCardColor(context),
                    borderRadius:
                        BorderRadius.circular(16),
                    border: Border.all(color: appBorderColor(context)),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.black.withValues(alpha: appIsDark(context) ? 0.2 : 0.04),
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
                            child: AppNetworkImage(
                              url: line.imageUrl,
                              width: 72,
                              height: 72,
                              fit: BoxFit.cover,
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
                      if (o.status == OrderStatus.processing ||
                          o.status == OrderStatus.packing) ...[
                        const SizedBox(height: 8),
                        Text(
                          o.status == OrderStatus.packing
                              ? orderStatusLabel(itemLoc, OrderStatus.packing)
                              : orderBuyerWaitingPack(itemLoc),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                      if (o.status == OrderStatus.completed &&
                          o.completedAt != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          itemLoc.orderCompletedAt(
                            _fmtDate(o.completedAt!),
                          ),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                      const SizedBox(height: 14),
                      if (o.status == OrderStatus.inProcess) ...[
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () =>
                                _confirmOrderReceived(context, o.id),
                            icon: const Icon(
                              Icons.check_circle_outline_rounded,
                            ),
                            label: Text(itemLoc.orderConfirmReceivedBtn),
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.green.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                      if (o.status == OrderStatus.completed ||
                          o.status == OrderStatus.inProcess) ...[
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _showPlaceholderSnack(
                                  context,
                                  orderComplainPlaceholder(itemLoc),
                                ),
                                child: Text(orderComplainBtn(itemLoc)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _showPlaceholderSnack(
                                  context,
                                  orderReturnPlaceholder(itemLoc),
                                ),
                                child: Text(orderReturnBtn(itemLoc)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                      Row(
                        children: [
                          if (o.status == OrderStatus.completed) ...[
                            if (!o.reviewed)
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () =>
                                      showOrderReviewDialog(context, order: o),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _purple,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: Text(orderReviewSubmit(itemLoc)),
                                ),
                              ),
                            if (!o.reviewed) const SizedBox(width: 8),
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
                                    OrderStatus.inProcess) {
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
                                o.status == OrderStatus.inProcess
                                    ? loc.orderTrackOrder
                                    : loc.orderBuyAgain,
                              ),
                            ),
                          ),
                          if (o.status ==
                              OrderStatus.processing) ...[
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
          color: selected
              ? Theme.of(context).colorScheme.primary
              : appCardColor(context),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected
                ? Theme.of(context).colorScheme.primary
                : appBorderColor(context),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? Theme.of(context).colorScheme.onPrimary
                : appPrimaryText(context),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
