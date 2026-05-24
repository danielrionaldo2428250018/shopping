import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistProvider extends ChangeNotifier {
  WishlistProvider(this._prefs) {
    _restore();
  }

  final SharedPreferences _prefs;

  static const _kIds = 'wishlist_ids_v1';

  final Set<String> _ids = {};

  Set<String> get ids => Set.unmodifiable(_ids);

  int get count => _ids.length;

  bool has(String productId) => _ids.contains(productId);

  void _restore() {
    final list = _prefs.getStringList(_kIds);
    if (list != null) {
      _ids.addAll(list);
      notifyListeners();
    }
  }

  void _persist() {
    _prefs.setStringList(_kIds, _ids.toList());
  }

  void clearAll() {
    _ids.clear();
    _prefs.remove(_kIds);
    notifyListeners();
  }

  void toggle(String productId) {
    if (_ids.contains(productId)) {
      _ids.remove(productId);
    } else {
      _ids.add(productId);
    }
    _persist();
    notifyListeners();
  }
}
