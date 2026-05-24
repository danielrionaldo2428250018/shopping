import 'dart:async';

import 'package:flutter/foundation.dart';

/// Gabungkan banyak [notifyListeners] beruntun — kurangi jank di UI thread.
class NotifyDebouncer {
  NotifyDebouncer({required Duration delay}) : _delay = delay;

  final Duration _delay;
  Timer? _timer;
  VoidCallback? _pending;

  void schedule(VoidCallback action) {
    _pending = action;
    _timer?.cancel();
    _timer = Timer(_delay, () {
      final fn = _pending;
      _pending = null;
      fn?.call();
    });
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
    _pending = null;
  }
}
