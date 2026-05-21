import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../l10n/app_localizations.dart';

String firebaseAuthErrorMessage(
  FirebaseAuthException e,
  AppLocalizations loc,
) {
  switch (e.code) {
    case 'invalid-email':
      return loc.authInvalidEmail;
    case 'user-disabled':
      return loc.authUserDisabled;
    case 'user-not-found':
      return loc.authUserNotFound;
    case 'wrong-password':
      return loc.authWrongPassword;
    case 'email-already-in-use':
      return loc.authEmailInUse;
    case 'weak-password':
      return loc.authWeakPassword;
    case 'operation-not-allowed':
      return loc.authOperationNotAllowed;
    case 'invalid-credential':
      return loc.authInvalidCredential;
    case 'too-many-requests':
      return loc.authTooManyRequests;
    case 'network-request-failed':
      return loc.authNetworkFailed;
    case 'account-exists-with-different-credential':
      return loc.authAccountExistsDifferent;
    case 'google-sign-in-failed':
      return loc.authGoogleSignInFailed;
    case 'firebase-not-initialized':
      return loc.authFirebaseNotReady;
    default:
      return e.message ?? loc.authFailedWithCode(e.code);
  }
}

String platformAuthErrorMessage(PlatformException e, AppLocalizations loc) {
  if (e.code == 'sign_in_failed' || (e.message ?? '').contains('10')) {
    return loc.authPlatformGoogleFailed;
  }
  return e.message ?? loc.authPlatformFailedWithCode(e.code);
}
