/// Kunci API Gemini — wajib lewat build flag (jangan commit kunci ke repo).
///
/// `flutter run --dart-define=GEMINI_API_KEY=your_key_here`
class GeminiConfig {
  GeminiConfig._();

  static const String apiKey = String.fromEnvironment('GEMINI_API_KEY');

  static const String model = 'gemini-2.0-flash';

  static bool get isConfigured => apiKey.isNotEmpty;

  static String get generateContentUrl =>
      'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent';
}
