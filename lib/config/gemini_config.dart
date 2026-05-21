/// Kunci API Gemini — override saat build: `--dart-define=GEMINI_API_KEY=...`
class GeminiConfig {
  GeminiConfig._();

  static const String apiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: 'AIzaSyDN8-JHDZPpGGGRnY_KgPHGtZg-Pe61040',
  );

  static const String model = 'gemini-2.0-flash';

  static String get generateContentUrl =>
      'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent';
}
