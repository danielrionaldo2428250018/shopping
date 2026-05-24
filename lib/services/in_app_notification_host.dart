import 'dart:async';

import 'package:flutter/foundation.dart';

/// Banner notifikasi di atas layar (saat app terbuka — seperti heads-up fasum).
class InAppNotificationHost extends ChangeNotifier {
  InAppNotificationHost._();
  static final InAppNotificationHost instance = InAppNotificationHost._();

  InAppBanner? _banner;
  Timer? _hideTimer;

  InAppBanner? get banner => _banner;

  void show({
    required String title,
    required String body,
  }) {
    _hideTimer?.cancel();
    _banner = InAppBanner(
      title: title.trim().isNotEmpty ? title.trim() : 'SECO',
      body: body.trim(),
      shownAt: DateTime.now(),
    );
    notifyListeners();
    _hideTimer = Timer(const Duration(seconds: 6), dismiss);
  }

  void dismiss() {
    _hideTimer?.cancel();
    _hideTimer = null;
    if (_banner == null) return;
    _banner = null;
    notifyListeners();
  }
}

class InAppBanner {
  const InAppBanner({
    required this.title,
    required this.body,
    required this.shownAt,
  });

  final String title;
  final String body;
  final DateTime shownAt;
}
