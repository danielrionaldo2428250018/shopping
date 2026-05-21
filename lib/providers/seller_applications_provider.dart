import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_admin_config.dart';
import '../models/seller_application.dart';
import '../services/push_notification_service.dart';
import '../utils/l10n_helpers.dart';
import '../services/seller_applications_repository.dart';
import 'auth_provider.dart';

/// Pengajuan penjual: **Firestore** bila Firebase aktif, selain itu **SharedPreferences** (tetap jalan).
class SellerApplicationsProvider extends ChangeNotifier {
  SellerApplicationsProvider(this._prefs) {
    if (Firebase.apps.isNotEmpty) {
      _useFirestore = true;
      _repo = SellerApplicationsRepository(FirebaseFirestore.instance);
      _resubscribe();
    } else {
      _useFirestore = false;
      _error = null;
      _restoreLocal();
    }
  }

  final SharedPreferences _prefs;
  static const _kApps = 'seller_applications_v1';

  SellerApplicationsRepository? _repo;
  StreamSubscription<List<SellerApplication>>? _sub;

  final List<SellerApplication> _items = [];
  String? _error;
  bool _useFirestore = false;

  String? get loadError => _error;

  /// Firestore aktif (bukan mode lokal).
  bool get usesFirestore => _useFirestore;

  /// Siap dipakai (lokal selalu true; remote setelah repo ada).
  bool get isReady => _useFirestore ? _repo != null : true;

  List<SellerApplication> get all => List.unmodifiable(_items);

  List<SellerApplication> get pending => _items
      .where((a) => a.status == SellerApplicationStatus.pending)
      .toList();

  List<SellerApplication> get approved => _items
      .where((a) => a.status == SellerApplicationStatus.approved)
      .toList();

  List<SellerApplication> get rejected => _items
      .where((a) => a.status == SellerApplicationStatus.rejected)
      .toList();

  AuthProvider? _auth;

  void _syncApprovedSellerForBoundAuth() {
    final auth = _auth;
    if (auth == null) return;
    final email = auth.accountEmail?.trim().toLowerCase();
    if (email == null || email.isEmpty) return;
    for (final app in approved) {
      if (app.email.trim().toLowerCase() == email) {
        auth.grantSellerRoleForEmail(app.email);
      }
    }
  }

  void bindAuth(AuthProvider auth) {
    if (_auth == auth) return;
    _auth?.removeListener(_onAuthChanged);
    _auth = auth;
    _auth!.addListener(_onAuthChanged);
    _resubscribe();
    _syncApprovedSellerForBoundAuth();
  }

  void _onAuthChanged() {
    _resubscribe();
    _syncApprovedSellerForBoundAuth();
  }

  void _resubscribe() {
    _sub?.cancel();
    _sub = null;
    if (!_useFirestore || _repo == null) return;

    final email = _auth?.accountEmail?.trim().toLowerCase();
    void onList(List<SellerApplication> list) {
      _items
        ..clear()
        ..addAll(list);
      _error = null;
      notifyListeners();
      _syncApprovedSellerForBoundAuth();
    }

    void onError(Object e) {
      _error = 'Firestore: $e';
      notifyListeners();
    }

    if (isAppAdminEmail(email)) {
      _sub = _repo!.watchAll().listen(onList, onError: onError);
    } else if (email != null && email.isNotEmpty) {
      _sub = _repo!.watchByEmail(email).listen(onList, onError: onError);
    } else {
      _items.clear();
      notifyListeners();
    }
  }

  /// Pengajuan terbaru milik akun yang sedang login (bukan admin).
  SellerApplication? get myLatestApplication {
    final email = _auth?.accountEmail?.trim().toLowerCase();
    if (email == null || email.isEmpty) return null;
    final mine = _items.where((a) => a.email.toLowerCase() == email).toList();
    if (mine.isEmpty) return null;
    mine.sort((a, b) => b.submittedAt.compareTo(a.submittedAt));
    return mine.first;
  }

  bool get hasMyApplication => myLatestApplication != null;

  void _restoreLocal() {
    final s = _prefs.getString(_kApps);
    if (s == null || s.isEmpty) {
      notifyListeners();
      return;
    }
    try {
      final list = jsonDecode(s) as List<dynamic>;
      _items.clear();
      for (final e in list) {
        _items.add(SellerApplication.fromJson(e as Map<String, dynamic>));
      }
    } catch (_) {}
    notifyListeners();
    _syncApprovedSellerForBoundAuth();
  }

  void _persistLocal() {
    _prefs.setString(
      _kApps,
      jsonEncode(_items.map((e) => e.toJson()).toList()),
    );
  }

  SellerApplication? findById(String id) {
    try {
      return _items.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  bool hasPendingForEmail(String? email) {
    if (email == null || email.isEmpty) return false;
    final e = email.trim().toLowerCase();
    return _items.any(
      (a) =>
          a.email.toLowerCase() == e &&
          a.status == SellerApplicationStatus.pending,
    );
  }

  /// `true` jika tersimpan ke Firestore; `false` jika fallback lokal (permission/rules).
  Future<bool> submit(SellerApplication application) async {
    if (_useFirestore) {
      if (_repo == null) {
        throw StateError(
          _error ?? 'Firestore tidak tersedia. Periksa firebase_options.dart.',
        );
      }
      _error = null;
      try {
        await _repo!.create(application);
        return true;
      } on FirebaseException catch (e) {
        if (e.code == 'permission-denied') {
          _items.insert(0, application);
          _persistLocal();
          notifyListeners();
          return false;
        }
        rethrow;
      }
    }

    _items.insert(0, application);
    _persistLocal();
    notifyListeners();
    return false;
  }

  Future<void> approve(String id, AuthProvider auth) async {
    if (!auth.isAdmin) {
      throw StateError('admin-only');
    }
    final app = findById(id);
    if (app == null || app.status != SellerApplicationStatus.pending) return;

    if (_useFirestore) {
      if (_repo == null) return;
      await _repo!.approve(id);
    } else {
      app.status = SellerApplicationStatus.approved;
      app.reviewedAt = DateTime.now();
      app.rejectReason = null;
      _persistLocal();
      notifyListeners();
    }
    auth.grantSellerRoleForEmail(app.email);

    final loc = appLocalizationsFromPrefs(_prefs);
    unawaited(
      sendNotificationToTopic(
        title: loc.storeNewNotification,
        body: loc.storeNewNotificationBody(app.storeName),
        senderName: loc.storeNewNotificationSender,
      ),
    );
  }

  Future<void> reject(String id, AuthProvider auth, {String reason = ''}) async {
    if (!auth.isAdmin) {
      throw StateError('admin-only');
    }
    final app = findById(id);
    if (app == null || app.status != SellerApplicationStatus.pending) return;

    if (_useFirestore) {
      if (_repo == null) return;
      await _repo!.reject(id, reason: reason);
    } else {
      app.status = SellerApplicationStatus.rejected;
      app.reviewedAt = DateTime.now();
      app.rejectReason = reason.trim().isEmpty ? null : reason.trim();
      _persistLocal();
      notifyListeners();
    }
  }

  Future<void> updateSellerCoordinates(
    String id,
    double lat,
    double lng,
  ) async {
    final app = findById(id);
    if (app == null) return;

    if (_useFirestore) {
      if (_repo == null) return;
      await _repo!.updateCoordinates(id, lat, lng);
    } else {
      app.latitude = lat;
      app.longitude = lng;
      _persistLocal();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _auth?.removeListener(_onAuthChanged);
    _sub?.cancel();
    super.dispose();
  }
}
