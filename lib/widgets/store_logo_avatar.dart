import 'package:flutter/material.dart';

import '../utils/store_initials.dart';

/// Avatar toko dari inisial nama (tanpa unggah foto logo).
class StoreLogoAvatar extends StatelessWidget {
  const StoreLogoAvatar({
    super.key,
    required this.storeName,
    this.radius = 36,
    this.backgroundColor,
  });

  final String storeName;
  final double radius;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final initials = storeInitialsFromName(storeName);
    final bg = backgroundColor ?? storeAvatarBackgroundColor(storeName);
    final fontSize = initials.length <= 1
        ? radius * 0.9
        : initials.length == 2
            ? radius * 0.55
            : radius * 0.42;

    return CircleAvatar(
      radius: radius,
      backgroundColor: bg,
      child: Text(
        initials,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: storeAvatarTextColor(storeName),
          letterSpacing: initials.length > 1 ? 0.5 : 0,
        ),
      ),
    );
  }
}
