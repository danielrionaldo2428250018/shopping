import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_admin_config.dart';
import '../services/google_auth_service.dart';
import '../l10n/app_localizations.dart';
import '../utils/firebase_auth_messages.dart';

/// Autentikasi terpusat — **Firebase Authentication** + status seller lokal.
class AuthProvider extends ChangeNotifier {
  AuthProvider(this._prefs) {
    _restoreSellerEmails();
  }

  final SharedPreferences _prefs;

  static const _kLogged = 'auth_logged_in';
  static const _kEmail = 'auth_email';
  static const _kSeller = 'auth_is_seller';
  static const _kApproved = 'auth_seller_approved_emails';

  FirebaseAuth? _firebaseAuth;
  StreamSubscription<User?>? _authSub;
  bool _firebaseBound = false;

  bool _isLoggedIn = false;
  bool _isSeller = false;
  String? _accountEmail;
  String? _displayName;
  String? _uid;
  final Set<String> _sellerApprovedEmails = <String>{};

  bool get isLoggedIn => _isLoggedIn;
  bool get isSeller => _isSeller;
  bool get isAdmin => isAppAdminUser(email: resolvedAccountEmail, uid: _uid);

  /// Email dari Firebase Auth (termasuk provider password/google).
  String? get resolvedAccountEmail {
    final cached = _accountEmail;
    if (cached != null && cached.isNotEmpty) return cached;
    final user = _firebaseAuth?.currentUser;
    if (user == null) return null;
    return _emailFromFirebaseUser(user);
  }
  String? get accountEmail => _accountEmail;
  String? get displayName => _displayName;
  String? get uid => _uid;
  bool get usesFirebaseAuth => _firebaseBound;

  static Future<void> migrateClearLocalSellerDataForFirestore(
    SharedPreferences prefs,
  ) async {
    const kDone = 'seller_firestore_v1_done';
    if (prefs.getBool(kDone) == true) return;
    await prefs.remove('seller_applications_v1');
    await prefs.setString(_kApproved, jsonEncode(<String>[]));
    await prefs.setBool(_kSeller, false);
    await prefs.setBool(kDone, true);
  }

  void _restoreSellerEmails() {
    final raw = _prefs.getString(_kApproved);
    if (raw != null && raw.isNotEmpty) {
      try {
        final list = jsonDecode(raw) as List<dynamic>;
        _sellerApprovedEmails
          ..clear()
          ..addAll(list.cast<String>());
      } catch (_) {}
    }
  }

  /// Hubungkan ke [FirebaseAuth] — panggil sekali setelah Firebase.initializeApp.
  void bindFirebase(FirebaseAuth firebaseAuth) {
    _firebaseAuth = firebaseAuth;
    _firebaseBound = true;
    _authSub?.cancel();
    _authSub = firebaseAuth.authStateChanges().listen(_applyFirebaseUser);
    _applyFirebaseUser(firebaseAuth.currentUser);
  }

  static String? _emailFromFirebaseUser(User user) {
    final direct = user.email?.trim().toLowerCase();
    if (direct != null && direct.isNotEmpty) return direct;
    for (final info in user.providerData) {
      final e = info.email?.trim().toLowerCase();
      if (e != null && e.isNotEmpty) return e;
    }
    return null;
  }

  void _applyFirebaseUser(User? user) {
    if (user != null && !user.isAnonymous) {
      _isLoggedIn = true;
      _uid = user.uid;
      _accountEmail = _emailFromFirebaseUser(user);
      _displayName = user.displayName?.trim();
      _isSeller = _accountEmail != null &&
          _sellerApprovedEmails.contains(_accountEmail);
    } else {
      _isLoggedIn = false;
      _isSeller = false;
      _accountEmail = null;
      _displayName = null;
      _uid = null;
    }
    _persistSession();
    notifyListeners();
  }

  void _persistSession() {
    _prefs.setBool(_kLogged, _isLoggedIn);
    if (_accountEmail != null) {
      _prefs.setString(_kEmail, _accountEmail!);
    } else {
      _prefs.remove(_kEmail);
    }
    _prefs.setBool(_kSeller, _isSeller);
    _prefs.setString(
      _kApproved,
      jsonEncode(_sellerApprovedEmails.toList()),
    );
  }

  FirebaseAuth get _auth {
    final a = _firebaseAuth;
    if (a == null) {
      throw StateError(
        'Firebase Auth belum siap. Pastikan Firebase.initializeApp berhasil.',
      );
    }
    return a;
  }

  /// Masuk email + kata sandi (Firebase).
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    await cred.user?.reload();
    _applyFirebaseUser(_auth.currentUser);
  }

  /// Daftar akun baru (Firebase).
  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final name = displayName?.trim();
    if (name != null &&
        name.isNotEmpty &&
        cred.user != null) {
      await cred.user!.updateDisplayName(name);
      await cred.user!.reload();
      _applyFirebaseUser(_auth.currentUser);
    }
  }

  /// Reset kata sandi via email Firebase.
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  /// Masuk dengan Google (Firebase credential wajib berhasil).
  Future<GoogleAuthResult> signInWithGoogle() async {
    final result = await GoogleAuthService.signIn();
    if (!result.firebaseLinked) {
      throw FirebaseAuthException(
        code: 'google-sign-in-failed',
        message:
            'Gagal menghubungkan ke Firebase. Aktifkan Google Sign-In dan SHA-1 di Firebase Console.',
      );
    }
    await _auth.currentUser?.reload();
    _applyFirebaseUser(_auth.currentUser);
    return result;
  }

  void grantSellerRoleForEmail(String email) {
    final e = email.trim().toLowerCase();
    if (e.isEmpty) return;

    _sellerApprovedEmails.add(e);
    if (_accountEmail != null && _accountEmail == e) {
      _isSeller = true;
    }
    _persistSession();
    notifyListeners();
  }

  bool isEmailApprovedAsSeller(String email) =>
      _sellerApprovedEmails.contains(email.trim().toLowerCase());

  void setSeller(bool value) {
    _isSeller = value;
    if (value &&
        _accountEmail != null &&
        _accountEmail!.isNotEmpty) {
      _sellerApprovedEmails.add(_accountEmail!);
    }
    _persistSession();
    notifyListeners();
  }

  Future<void> logout() async {
    await GoogleAuthService.signOut();
    if (_firebaseBound) {
      await _auth.signOut();
    } else {
      _isLoggedIn = false;
      _isSeller = false;
      _accountEmail = null;
      _displayName = null;
      _uid = null;
      _prefs.setBool(_kLogged, false);
      _prefs.remove(_kEmail);
      _prefs.setBool(_kSeller, false);
      notifyListeners();
    }
  }

  /// Untuk UI: terjemahkan error Firebase sesuai bahasa aktif.
  static String messageFor(Object error, AppLocalizations loc) {
    if (error is FirebaseAuthException) {
      return firebaseAuthErrorMessage(error, loc);
    }
    if (error is PlatformException) {
      return platformAuthErrorMessage(error, loc);
    }
    if (error is StateError) {
      return error.message;
    }
    return error.toString();
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }
}
