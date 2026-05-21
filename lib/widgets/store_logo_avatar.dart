import 'dart:io';

import 'package:flutter/material.dart';

import '../constants/app_branding.dart';

/// Avatar/logo toko: URL cloud, file lokal, atau inisial nama.
class StoreLogoAvatar extends StatelessWidget {
  const StoreLogoAvatar({
    super.key,
    required this.storeName,
    this.logoUrl,
    this.logoPath,
    this.radius = 36,
    this.backgroundColor,
  });

  final String storeName;
  final String? logoUrl;
  final String? logoPath;
  final double radius;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final initial = storeName.trim().isNotEmpty
        ? storeName.trim()[0].toUpperCase()
        : '?';
    final bg = backgroundColor ?? Colors.white;

    ImageProvider? provider;
    final url = logoUrl?.trim();
    if (url != null && url.isNotEmpty) {
      provider = NetworkImage(url);
    } else {
      final path = logoPath?.trim();
      if (path != null &&
          path.isNotEmpty &&
          !path.startsWith('http') &&
          File(path).existsSync()) {
        provider = FileImage(File(path));
      }
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: bg,
      backgroundImage: provider,
      child: provider == null
          ? Text(
              initial,
              style: TextStyle(
                fontSize: radius * 0.9,
                fontWeight: FontWeight.bold,
                color: AppBranding.seedColor,
              ),
            )
          : null,
    );
  }
}
