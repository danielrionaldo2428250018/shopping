import 'package:flutter/material.dart';

import '../utils/l10n_helpers.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({
    super.key,
    this.orderId,
  });

  /// Dari My Orders → Review (opsional).
  final String? orderId;

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;
    final List<Map<String, dynamic>> reviews = [
      {
        'name': 'Andi',
        'review': loc.reviewSample1,
        'rating': 5,
      },
      {
        'name': 'Rina',
        'review': loc.reviewSample2,
        'rating': 4,
      },
      {
        'name': 'Budi',
        'review': loc.reviewSample3,
        'rating': 5,
      },
    ];

    return Scaffold(

      backgroundColor:
          const Color(0xFFF5F5F5),

      appBar: AppBar(

        backgroundColor:
            Colors.white,

        elevation: 0,

        centerTitle: true,

        iconTheme:
            const IconThemeData(
          color: Colors.black,
        ),

        title: Text(
          orderId != null ? '${loc.reviews} • $orderId' : loc.reviews,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: ListView.builder(

        padding:
            const EdgeInsets.all(
          16,
        ),

        itemCount:
            reviews.length,

        itemBuilder:
            (context, index) {

          final review =
              reviews[index];

          return Container(

            margin:
                const EdgeInsets.only(
              bottom: 16,
            ),

            padding:
                const EdgeInsets.all(
              20,
            ),

            decoration:
                BoxDecoration(
              color: Colors.white,

              borderRadius:
                  BorderRadius.circular(
                24,
              ),
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [

                Row(
                  children: [

                    Container(
                      height: 50,
                      width: 50,

                      decoration:
                          const BoxDecoration(
                        color: Color(
                          0xFFE4D7FF,
                        ),

                        shape:
                            BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.person,
                        color: Color(
                          0xFF7F3DFF,
                        ),
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [

                          Text(
                            review['name']
                                as String,

                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight
                                      .bold,

                              fontSize:
                                  18,
                            ),
                          ),

                          const SizedBox(
                              height:
                                  6),

                          Row(
                            children:
                                List.generate(

                              review['rating']
                                  as int,

                              (index) {

                                return const Icon(
                                  Icons.star,

                                  size: 18,

                                  color:
                                      Colors.orange,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                Text(
                  review['review'] as String,

                  style: TextStyle(
                    color:
                        Colors.grey
                            .shade700,

                    height: 1.6,
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