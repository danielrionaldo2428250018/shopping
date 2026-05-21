/// URL panel admin (Firebase Hosting atau `firebase serve`).
///
/// Override saat build: `--dart-define=ADMIN_PORTAL_URL=https://yourapp.web.app`
const String kAdminPortalUrl = String.fromEnvironment(
  'ADMIN_PORTAL_URL',
  defaultValue: 'http://127.0.0.1:5000',
);
