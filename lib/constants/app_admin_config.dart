import '../config/app_admin_local.dart';

/// Override saat build: `--dart-define=ADMIN_EMAIL=admin@kampus.ac.id`
const String _kAdminEmailFromEnv = String.fromEnvironment('ADMIN_EMAIL');

/// Email admin tunggal (huruf kecil). Kosong = fitur admin nonaktif.
String get kAppAdminEmail {
  final local = kAppAdminEmailLocal.trim().toLowerCase();
  if (local.isNotEmpty) return local;
  final env = _kAdminEmailFromEnv.trim().toLowerCase();
  return env;
}

bool get isAppAdminConfigured => kAppAdminEmail.isNotEmpty;

bool isAppAdminEmail(String? email) {
  if (!isAppAdminConfigured) return false;
  return email?.trim().toLowerCase() == kAppAdminEmail;
}
