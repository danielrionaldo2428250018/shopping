import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../utils/data_image_cache.dart';
import '../utils/green_computing.dart';

/// Cegah crash diam-diam + kosongkan cache saat RAM penuh.
abstract final class AppStability {
  static bool _installed = false;

  static void install() {
    if (_installed) return;
    _installed = true;

    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      if (kDebugMode) {
        debugPrint('FlutterError: ${details.exceptionAsString()}');
      }
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      if (kDebugMode) {
        debugPrint('Uncaught: $error\n$stack');
      }
      return true;
    };
  }

  /// Dipanggil saat sistem melaporkan memori rendah (Android/iOS).
  static void onMemoryPressure() {
    DataImageCache.clear();
    final cache = PaintingBinding.instance.imageCache;
    cache.clear();
    cache.clearLiveImages();
    GreenComputing.tuneImageCacheForEco(true);
    if (kDebugMode) {
      debugPrint('AppStability: caches cleared (memory pressure)');
    }
  }
}

/// Pantau tekanan memori di seluruh app.
mixin AppMemoryPressureMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(_lifecycle);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_lifecycle);
    super.dispose();
  }

  final _AppLifecycleObserver _lifecycle = _AppLifecycleObserver();
}

final class _AppLifecycleObserver with WidgetsBindingObserver {
  @override
  void didHaveMemoryPressure() {
    AppStability.onMemoryPressure();
  }
}
