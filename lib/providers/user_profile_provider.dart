import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_branding.dart';

/// Profil lokal: nama, email, HP, foto — untuk checkout & tampilan profil.
class UserProfileProvider extends ChangeNotifier {
  UserProfileProvider(this._prefs) {
    _load();
  }

  final SharedPreferences _prefs;

  static const _kPhone = 'user_phone_v1';
  static const _kName = 'user_display_name_v1';
  static const _kEmail = 'user_email_v1';
  static const _kAvatar = 'user_avatar_path_v1';

  String? _phone;
  String? _displayName;
  String? _email;
  String? _avatarLocalPath;

  String? get phone => _phone;

  String? get displayName => _displayName;

  String? get email => _email;

  /// Path file gambar avatar di penyimpanan aplikasi (lokal).
  String? get avatarLocalPath => _avatarLocalPath;

  String get displayNameOrDefault =>
      (_displayName != null && _displayName!.trim().isNotEmpty)
          ? _displayName!.trim()
          : AppBranding.defaultDisplayName;

  String get handleOrDefault {
    final base = displayNameOrDefault.toLowerCase().replaceAll(RegExp(r'\s+'), '');
    if (base.length >= 3) return '@$base';
    return '@user';
  }

  /// Minimal panjang nomor (tanpa +62) untuk dianggap valid.
  bool get hasValidPhone {
    final p = _phone?.replaceAll(RegExp(r'\D'), '') ?? '';
    return p.length >= 10;
  }

  void _load() {
    _phone = _prefs.getString(_kPhone);
    _displayName = _prefs.getString(_kName);
    _email = _prefs.getString(_kEmail);
    _avatarLocalPath = _prefs.getString(_kAvatar);
    notifyListeners();
  }

  void setPhone(String value) {
    final t = value.trim();
    _phone = t.isEmpty ? null : t;
    if (_phone != null) {
      _prefs.setString(_kPhone, _phone!);
    } else {
      _prefs.remove(_kPhone);
    }
    notifyListeners();
  }

  void setDisplayName(String value) {
    final t = value.trim();
    _displayName = t.isEmpty ? null : t;
    if (_displayName != null) {
      _prefs.setString(_kName, _displayName!);
    } else {
      _prefs.remove(_kName);
    }
    notifyListeners();
  }

  void setEmail(String value) {
    final t = value.trim();
    _email = t.isEmpty ? null : t;
    if (_email != null) {
      _prefs.setString(_kEmail, _email!);
    } else {
      _prefs.remove(_kEmail);
    }
    notifyListeners();
  }

  /// Path ke file gambar yang sudah disalin ke direktori aplikasi.
  void setAvatarLocalPath(String? path) {
    _avatarLocalPath = path;
    if (path != null && path.isNotEmpty) {
      _prefs.setString(_kAvatar, path);
    } else {
      _prefs.remove(_kAvatar);
    }
    notifyListeners();
  }

  void saveProfile({
    required String displayName,
    required String email,
    required String phone,
  }) {
    setDisplayName(displayName);
    setEmail(email);
    setPhone(phone);
  }
}
