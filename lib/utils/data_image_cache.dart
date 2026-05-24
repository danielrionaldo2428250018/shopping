import 'dart:typed_data';

/// Cache byte gambar data-URL agar tidak di-decode ulang saat scroll.
abstract final class DataImageCache {
  static final _bytes = <String, Uint8List>{};
  static const _maxEntries = 32;

  static Uint8List? get(String url) => _bytes[url];

  static void put(String url, Uint8List data) {
    if (_bytes.containsKey(url)) return;
    while (_bytes.length >= _maxEntries) {
      _bytes.remove(_bytes.keys.first);
    }
    _bytes[url] = data;
  }

  static void clear() => _bytes.clear();
}
