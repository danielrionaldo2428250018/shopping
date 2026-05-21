import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Bahasa aplikasi (id, en, ar, ko, zh) — seluruh UI ikut [MaterialApp.locale].
class LocaleProvider extends ChangeNotifier {
  LocaleProvider(this._prefs) {
    final code = _prefs.getString('locale') ?? 'id';
    _locale = Locale(code);
  }

  final SharedPreferences _prefs;
  late Locale _locale;

  Locale get locale => _locale;

  Future<void> setLocale(Locale locale) async {
    await _prefs.setString('locale', locale.languageCode);
    _locale = locale;
    notifyListeners();
  }
}
