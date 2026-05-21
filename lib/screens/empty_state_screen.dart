import 'package:flutter/material.dart';

class EmptyStateScreen
    extends StatelessWidget {

  final String title;
  final String subtitle;
  final IconData icon;

  const EmptyStateScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          Colors.white,

      body: Center(
        child: Padding(
          padding:
              const EdgeInsets.all(
            24,
          ),

          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [

              Container(
                padding:
                    const EdgeInsets.all(
                  34,
                ),

                decoration:
                    BoxDecoration(
                  color:
                      const Color(
                    0xFF7F3DFF,
                  ).withOpacity(
                    0.1,
                  ),

                  shape:
                      BoxShape.circle,
                ),

                child: Icon(
                  icon,

                  size: 90,

                  color:
                      const Color(
                    0xFF7F3DFF,
                  ),
                ),
              ),

              const SizedBox(height: 34),

              Text(
                title,

                textAlign:
                    TextAlign.center,

                style: const TextStyle(
                  fontSize: 32,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 18),

              Text(
                subtitle,

                textAlign:
                    TextAlign.center,

                style: TextStyle(
                  color:
                      Colors.grey.shade700,

                  fontSize: 16,

                  height: 1.7,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}