import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/app_notifications.dart';

/// Meminta izin inti sekali saat pertama kali aplikasi dibuka:
/// **galeri/foto** (chat, profil, cari dengan foto).
/// **Notifikasi** diminta saat pertama buka app agar popup/heads-up bisa muncul.
/// Lokasi tetap diminta di halaman Map / toggle Settings.
class StartupPermissionsWrapper extends StatefulWidget {
  const StartupPermissionsWrapper({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<StartupPermissionsWrapper> createState() =>
      _StartupPermissionsWrapperState();
}

class _StartupPermissionsWrapperState extends State<StartupPermissionsWrapper> {
  static const _kDone = 'startup_permissions_requested_v1';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _requestCore());
  }

  Future<void> _requestCore() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_kDone) == true) return;

    // Non-blocking: jangan menunda UI pertama.
    unawaited(Permission.photos.request());
    unawaited(ensureNotificationPermission());
    await prefs.setBool(_kDone, true);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
