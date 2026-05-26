import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/order_status.dart';
import '../models/shop_order.dart';
import '../providers/orders_provider.dart';
import '../providers/reviews_provider.dart';
import '../providers/user_profile_provider.dart';
import '../utils/l10n_helpers.dart';
import '../utils/order_flow_l10n.dart';

/// Dialog ulasan satu produk dalam pesanan.
Future<bool> showOrderReviewDialog(
  BuildContext context, {
  required ShopOrder order,
  required OrderLineSnapshot line,
}) async {
  final loc = context.l10n;
  final reviews = context.read<ReviewsProvider>();

  if (order.status != OrderStatus.completed) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(loc.reviewOrderNotCompleted)),
    );
    return false;
  }

  if (reviews.hasReviewForOrderProduct(
    orderId: order.id,
    productId: line.productId,
  )) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(loc.reviewAlreadySubmitted)),
    );
    return false;
  }

  final name = context.read<UserProfileProvider>().displayNameOrDefault;
  final textCtrl = TextEditingController();
  var rating = 5;

  final submitted = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: Text(orderReviewTitle(loc)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                line.title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                order.id,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  final star = i + 1;
                  return IconButton(
                    onPressed: () => setState(() => rating = star),
                    icon: Icon(
                      star <= rating
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      color: Colors.amber,
                      size: 32,
                    ),
                  );
                }),
              ),
              TextField(
                controller: textCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: orderReviewHint(loc),
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(loc.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(orderReviewSubmit(loc)),
          ),
        ],
      ),
    ),
  );

  if (submitted != true || !context.mounted) {
    textCtrl.dispose();
    return false;
  }

  final reviewText = textCtrl.text.trim();
  textCtrl.dispose();
  if (reviewText.isEmpty) return false;

  final sellerName = line.storeName.trim().isNotEmpty
      ? line.storeName
      : order.sellerStoreName;

  final ok = await reviews.addReview(
    name: name,
    review: reviewText,
    rating: rating,
    orderId: order.id,
    productId: line.productId,
    sellerName: sellerName,
  );

  if (!context.mounted) return ok;

  if (!ok) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(loc.reviewAlreadySubmitted)),
    );
    return false;
  }

  context.read<OrdersProvider>().markProductReviewed(order.id, line.productId);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(loc.reviewThankYou)),
  );
  return true;
}

/// Ulas semua produk dalam pesanan yang belum diulas (setelah diterima).
Future<void> showOrderReviewFlow(
  BuildContext context, {
  required ShopOrder order,
}) async {
  if (order.status != OrderStatus.completed) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.reviewOrderNotCompleted)),
    );
    return;
  }

  final reviews = context.read<ReviewsProvider>();
  final seen = <String>{};
  final lines = <OrderLineSnapshot>[];
  for (final line in order.lines) {
    if (line.productId.isEmpty || !seen.add(line.productId)) continue;
    if (reviews.hasReviewForOrderProduct(
      orderId: order.id,
      productId: line.productId,
    )) {
      continue;
    }
    lines.add(line);
  }

  if (lines.isEmpty) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.reviewAlreadySubmitted)),
    );
    return;
  }

  for (final line in lines) {
    if (!context.mounted) return;
    final fresh = context.read<OrdersProvider>().orderById(order.id) ?? order;
    await showOrderReviewDialog(context, order: fresh, line: line);
  }
}
