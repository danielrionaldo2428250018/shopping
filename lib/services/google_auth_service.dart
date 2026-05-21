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
      throw FirebaseAuthException(code: 'firebase-not-initialized');
    }

    if (!GoogleSignInConfig.isConfigured) {
      throw StateError(GoogleSignInConfig.setupHint);
    }

    GoogleSignInAccount? account;
    try {
      account = await _googleSignIn.signIn();
    } on PlatformException {
      rethrow;
    }
    if (account == null) {
      throw FirebaseAuthException(code: 'google-sign-in-cancelled');
    }

    final email = account.email.trim();
    if (email.isEmpty) {
      throw FirebaseAuthException(code: 'google-no-email');
    }

    final GoogleSignInAuthentication googleAuth;
    try {
      googleAuth = await account.authentication;
    } on PlatformException {
      rethrow;
    }

    if (googleAuth.idToken == null || googleAuth.idToken!.isEmpty) {
      throw FirebaseAuthException(code: 'google-empty-token');
    }

    final authInstance = FirebaseAuth.instance;

    if (authInstance.currentUser?.isAnonymous == true) {
      await authInstance.signOut();
    }

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await authInstance.signInWithCredential(credential);

    final user = authInstance.currentUser;
    if (user == null || user.isAnonymous) {
      throw FirebaseAuthException(code: 'google-sign-in-failed');
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
