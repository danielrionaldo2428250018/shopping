import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/reviews_provider.dart';
import '../utils/app_screen_style.dart';
import '../utils/l10n_helpers.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({
    super.key,
    this.orderId,
  });

  final String? orderId;

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;
    final reviews = context.watch<ReviewsProvider>().items;
    final filtered = orderId == null
        ? reviews
        : reviews
            .where((r) => r['orderId']?.toString() == orderId)
            .toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          orderId != null ? '${loc.reviews} • $orderId' : loc.reviews,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: filtered.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.rate_review_outlined,
                      size: 72,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      loc.emptyReviews,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: appMutedTextColor(context),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      loc.emptyReviewsHint,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: appMutedTextColor(context),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final review = filtered[index];
                final rating = review['rating'] as int? ?? 0;
                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: appCardColor(context),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: appBorderColor(context)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review['name']?.toString() ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: List.generate(5, (i) {
                          return Icon(
                            i < rating
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            size: 18,
                            color: Colors.amber.shade700,
                          );
                        }),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        review['review']?.toString() ?? '',
                        style: TextStyle(
                          color: appMutedTextColor(context),
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
