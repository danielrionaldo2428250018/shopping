import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../config/google_sign_in_config.dart';

/// Hasil masuk / daftar dengan akun Google via Firebase Auth.
class GoogleAuthResult {
  const GoogleAuthResult({
    required this.email,
    required this.displayName,
    required this.firebaseLinked,
  });

  final String email;
  final String displayName;
  final bool firebaseLinked;
}

class GoogleAuthService {
  GoogleAuthService._();

  static GoogleSignIn get _googleSignIn {
    if (GoogleSignInConfig.isConfigured) {
      return GoogleSignIn(
        scopes: ['email', 'profile'],
        serverClientId: GoogleSignInConfig.webClientId,
      );
    }
    return GoogleSignIn(scopes: ['email', 'profile']);
  }

  static bool get _firebaseAvailable {
    try {
      return Firebase.apps.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  static Future<GoogleAuthResult> signIn() async {
    if (!_firebaseAvailable) {
      throw FirebaseAuthException(
        code: 'firebase-not-initialized',
        message: 'Firebase belum diinisialisasi.',
      );
    }

    if (!GoogleSignInConfig.isConfigured) {
      throw StateError(GoogleSignInConfig.setupHint);
    }

    GoogleSignInAccount? account;
    try {
      account = await _googleSignIn.signIn();
    } on PlatformException catch (e) {
      throw StateError(_platformMessage(e));
    }
    if (account == null) {
      throw StateError('Masuk Google dibatalkan.');
    }

    final email = account.email.trim();
    if (email.isEmpty) {
      throw StateError('Akun Google tidak memiliki email.');
    }

    final GoogleSignInAuthentication googleAuth;
    try {
      googleAuth = await account.authentication;
    } on PlatformException catch (e) {
      throw StateError(_platformMessage(e));
    }

    if (googleAuth.idToken == null || googleAuth.idToken!.isEmpty) {
      throw StateError(
        'Token Google kosong. Pastikan Web Client ID benar dan '
        'google-services.json memiliki oauth_client (client_type 3).',
      );
    }

    final authInstance = FirebaseAuth.instance;

    if (authInstance.currentUser?.isAnonymous == true) {
      await authInstance.signOut();
    }

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      await authInstance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential' || e.code == 'account-exists-with-different-credential') {
        throw StateError(
          '${e.message ?? e.code}. Periksa Web Client ID (project-uas-44504) dan SHA-1 di Firebase Console.',
        );
      }
      rethrow;
    }

    final user = authInstance.currentUser;
    if (user == null || user.isAnonymous) {
      throw FirebaseAuthException(
        code: 'google-sign-in-failed',
        message: 'Firebase tidak mengembalikan pengguna setelah Google Sign-In.',
      );
    }

    if (kDebugMode) {
      debugPrint('Firebase Google OK: ${user.uid}');
    }

    return GoogleAuthResult(
      email: user.email ?? email,
      displayName: user.displayName?.trim().isNotEmpty == true
          ? user.displayName!.trim()
          : account.displayName?.trim() ?? email.split('@').first,
      firebaseLinked: true,
    );
  }

  static String _platformMessage(PlatformException e) {
    final code = e.code;
    final msg = e.message ?? '';
    if (code == 'sign_in_failed' || msg.contains('10')) {
      return 'Google Sign-In gagal (ApiException 10). Tambahkan SHA-1 debug ke Firebase '
          '(project-uas-44504), aktifkan Google Auth, unduh ulang google-services.json.';
    }
    if (code == 'network_error') {
      return 'Koneksi gagal saat masuk Google. Periksa internet Anda.';
    }
    return msg.isNotEmpty ? msg : 'Masuk Google gagal ($code).';
  }

  static Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    if (_firebaseAvailable) {
      try {
        await FirebaseAuth.instance.signOut();
      } catch (_) {}
    }
  }
}
