import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Preferensi toggle di Settings (tersimpan lokal).
class SettingsPrefsProvider extends ChangeNotifier {
  SettingsPrefsProvider(this._prefs) {
    _push = _prefs.getBool(_kPush) ?? true;
    _email = _prefs.getBool(_kEmail) ?? false;
    _sms = _prefs.getBool(_kSms) ?? true;
    _fingerprint = _prefs.getBool(_kFinger) ?? false;
    _locationPref = _prefs.getBool(_kLocPref) ?? true;
  }

  final SharedPreferences _prefs;

  static const _kPush = 'settings_push_v1';
  static const _kEmail = 'settings_email_v1';
  static const _kSms = 'settings_sms_v1';
  static const _kFinger = 'settings_fingerprint_v1';
  static const _kLocPref = 'settings_location_pref_v1';

  bool _push = true;
  bool _email = false;
  bool _sms = true;
  bool _fingerprint = false;
  bool _locationPref = true;

  bool get pushNotifications => _push;
  bool get emailNotifications => _email;
  bool get smsNotifications => _sms;
  bool get fingerprintAuth => _fingerprint;
  bool get locationFeatureEnabled => _locationPref;

  void setPush(bool v) {
    _push = v;
    _prefs.setBool(_kPush, v);
    notifyListeners();
  }

  void setEmail(bool v) {
    _email = v;
    _prefs.setBool(_kEmail, v);
    notifyListeners();
  }

  void setSms(bool v) {
    _sms = v;
    _prefs.setBool(_kSms, v);
    notifyListeners();
  }

  void setFingerprint(bool v) {
    _fingerprint = v;
    _prefs.setBool(_kFinger, v);
    notifyListeners();
  }

  void setLocationFeature(bool v) {
    _locationPref = v;
    _prefs.setBool(_kLocPref, v);
    notifyListeners();
  }
}
