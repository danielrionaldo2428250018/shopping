import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Mode terang/gelap dari Settings (tersimpan).
class ThemePrefsProvider extends ChangeNotifier {
  ThemePrefsProvider(this._prefs) {
    _dark = _prefs.getBool(_kDark) ?? false;
  }

  final SharedPreferences _prefs;
  static const _kDark = 'settings_dark_mode_v1';

  bool _dark = false;

  bool get isDark => _dark;

  ThemeMode get themeMode =>
      _dark ? ThemeMode.dark : ThemeMode.light;

  void setDark(bool value) {
    _dark = value;
    _prefs.setBool(_kDark, value);
    notifyListeners();
  }
}
