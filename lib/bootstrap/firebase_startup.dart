import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../firebase_options.dart';
import '../providers/auth_provider.dart';
import '../providers/catalog_provider.dart';
import '../providers/chat_provider.dart';
import '../providers/inbox_messages_provider.dart';
import '../providers/seller_applications_provider.dart';
import '../providers/user_profile_provider.dart';

/// Firebase diinisialisasi setelah [runApp] agar splash Flutter tampil lebih cepat.
class FirebaseStartupScope extends InheritedWidget {
  const FirebaseStartupScope({
    super.key,
    required this.ready,
    required super.child,
  });

  final Future<bool> ready;

  static Future<bool> of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<FirebaseStartupScope>();
    assert(scope != null, 'FirebaseStartupScope tidak ditemukan');
    return scope!.ready;
  }

  @override
  bool updateShouldNotify(FirebaseStartupScope oldWidget) =>
      oldWidget.ready != ready;
}

class FirebaseStartupHost extends StatefulWidget {
  const FirebaseStartupHost({
    super.key,
    required this.prefs,
    required this.child,
  });

  final SharedPreferences prefs;
  final Widget child;

  @override
  State<FirebaseStartupHost> createState() => _FirebaseStartupHostState();
}

class _FirebaseStartupHostState extends State<FirebaseStartupHost> {
  late final Future<bool> _ready;

  @override
  void initState() {
    super.initState();
    _ready = _init();
  }

  Future<bool> _init() async {
    var ok = false;
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await AuthProvider.migrateClearLocalSellerDataForFirestore(
        widget.prefs,
      );
      ok = true;
    } catch (e, st) {
      debugPrint('Firebase init gagal: $e\n$st');
    }

    if (!mounted) return ok;
    if (ok) {
      // Setelah frame berikutnya agar tidak berebut CPU dengan transisi splash → beranda.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.read<CatalogProvider>().attachFirebase();
        context.read<ChatProvider>().attachFirebase();
        _bindAuthAndChat();
      });
    }
    return ok;
  }

  void _bindAuthAndChat() {
    final auth = context.read<AuthProvider>();
    try {
      auth.bindFirebase(FirebaseAuth.instance);
    } catch (e) {
      debugPrint('bindFirebase: $e');
    }
    final apps = context.read<SellerApplicationsProvider>();
    apps.bindAuth(auth);
    apps.bindProfile(context.read<UserProfileProvider>());
    final chat = context.read<ChatProvider>();
    chat.bindAuth(auth);
    chat.bindSellers(apps);
    chat.bindProfile(context.read<UserProfileProvider>());
    chat.bindInbox(context.read<InboxMessagesProvider>());
    final store = apps.myApprovedStore;
    if (auth.isLoggedIn && store != null) {
      unawaited(chat.registerSellerForPush(store.storeName));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FirebaseStartupScope(
      ready: _ready,
      child: widget.child,
    );
  }
}
