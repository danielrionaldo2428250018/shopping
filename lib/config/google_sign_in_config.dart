import 'google_sign_in_local.dart';

/// OAuth Web Client ID (wajib untuk Google Sign-In + Firebase Auth di Android).
///
/// Isi salah satu:
/// 1. `lib/config/google_sign_in_local.dart` → [kGoogleWebClientIdLocal]
/// 2. `--dart-define=GOOGLE_WEB_CLIENT_ID=....apps.googleusercontent.com`
class GoogleSignInConfig {
  GoogleSignInConfig._();

  static const String _fromDefine = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
    defaultValue: '',
  );

  static String get webClientId {
    if (_fromDefine.isNotEmpty) return _fromDefine;
    return kGoogleWebClientIdLocal;
  }

  static bool get isConfigured => webClientId.isNotEmpty;

  static String get setupHint =>
      'Google Sign-In belum dikonfigurasi. '
      'Aktifkan Google di Firebase (project-uas-44504), tambahkan SHA-1, '
      'unduh ulang google-services.json, lalu isi Web Client ID di '
      'lib/config/google_sign_in_local.dart atau --dart-define=GOOGLE_WEB_CLIENT_ID=...';
}