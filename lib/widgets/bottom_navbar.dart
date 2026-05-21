import 'package:flutter/material.dart';

import '../utils/l10n_helpers.dart';

class BottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;

    final surface = Theme.of(context).colorScheme.surface;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _item(index: 0, icon: Icons.home, title: loc.home),
          _item(index: 1, icon: Icons.location_on_outlined, title: loc.map),
          _item(index: 2, icon: Icons.favorite_border, title: loc.saved),
          _item(index: 3, icon: Icons.person_outline, title: loc.profile),
        ],
      ),
    );
  }

  Widget _item({
    required int index,
    required IconData icon,
    required String title,
  }) {
    final active = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: active
                  ? const Color(0xFF7F3DFF).withOpacity(0.12)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: active ? const Color(0xFF7F3DFF) : Colors.grey,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              color: active ? const Color(0xFF7F3DFF) : Colors.grey,
              fontWeight: active ? FontWeight.bold : null,
            ),
          ),
        ],
      ),
    );
  }
}
