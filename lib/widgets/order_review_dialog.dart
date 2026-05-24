import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/shop_order.dart';
import '../providers/orders_provider.dart';
import '../providers/reviews_provider.dart';
import '../providers/user_profile_provider.dart';
import '../utils/l10n_helpers.dart';
import '../utils/order_flow_l10n.dart';

/// Dialog ulasan setelah pesanan selesai.
Future<void> showOrderReviewDialog(
  BuildContext context, {
  required ShopOrder order,
}) async {
  final loc = context.l10n;
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
              Text(order.primaryProductTitle),
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
    return;
  }

  final review = textCtrl.text.trim();
  textCtrl.dispose();
  if (review.isEmpty) return;

  context.read<ReviewsProvider>().addReview(
        name: name,
        review: review,
        rating: rating,
        orderId: order.id,
        productId: order.primaryProductId,
      );
  context.read<OrdersProvider>().markReviewed(order.id);

  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(orderReviewSubmit(loc))),
  );
}
