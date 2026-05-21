import 'package:flutter/material.dart';

import '../utils/l10n_helpers.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    super.key,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController controller = PageController();
  int currentIndex = 0;

  List<({IconData icon, String title, String subtitle})> _pages(
    BuildContext context,
  ) {
    final loc = context.l10n;
    return [
      (
        icon: Icons.sell,
        title: loc.onboardingSellTitle,
        subtitle: loc.onboardingSellSubtitle,
      ),
      (
        icon: Icons.shopping_bag,
        title: loc.onboardingBuyTitle,
        subtitle: loc.onboardingBuySubtitle,
      ),
      (
        icon: Icons.eco,
        title: loc.onboardingEcoTitle,
        subtitle: loc.onboardingEcoSubtitle,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;
    final pages = _pages(context);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: controller,
              itemCount: pages.length,
              onPageChanged: (index) {
                setState(() => currentIndex = index);
              },
              itemBuilder: (context, index) {
                final page = pages[index];
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7F3DFF).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          page.icon,
                          size: 100,
                          color: const Color(0xFF7F3DFF),
                        ),
                      ),
                      const SizedBox(height: 50),
                      Text(
                        page.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        page.subtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 16,
                          height: 1.7,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(pages.length, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: currentIndex == index ? 24 : 10,
                height: 10,
                decoration: BoxDecoration(
                  color: currentIndex == index
                      ? const Color(0xFF7F3DFF)
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
              );
            }),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7F3DFF),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  currentIndex == pages.length - 1
                      ? loc.getStarted
                      : loc.skip,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
