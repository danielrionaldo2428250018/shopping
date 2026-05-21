import 'dart:math' as math;
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

import '../data/catalog_data.dart';
import '../models/catalog_product.dart';

/// Pencarian produk berdasarkan kemiripan visual (warna & komposisi) dengan foto referensi.
/// Membandingkan vektor fitur gambar kecil dari foto Anda dengan gambar produk di katalog.
class VisualProductSearch {
  VisualProductSearch._();

  static const _thumb = 64;
  static const _grid = 4;
  static const _cell = _thumb ~/ _grid;

  /// Urutkan produk dari paling mirip ke paling tidak mirip.
  static Future<List<CatalogProduct>> rankByPhotoBytes(
    Uint8List bytes,
  ) async {
    final decoded = img.decodeImage(bytes);
    if (decoded == null) return List.from(kCatalogProducts);

    final queryVec = _featureVector(decoded);

    final scored = <({CatalogProduct p, double score})>[];
    for (final p in kCatalogProducts) {
      try {
        final res = await http.get(Uri.parse(p.imageUrl));
        if (res.statusCode != 200) continue;
        final pi = img.decodeImage(res.bodyBytes);
        if (pi == null) continue;
        final v = _featureVector(pi);
        final sim = _cosine(queryVec, v);
        scored.add((p: p, score: sim));
      } catch (_) {
        scored.add((p: p, score: 0));
      }
    }

    if (scored.isEmpty) return List.from(kCatalogProducts);

    scored.sort((a, b) => b.score.compareTo(a.score));
    return scored.map((e) => e.p).toList();
  }

  static List<double> _featureVector(img.Image source) {
    final s = img.copyResize(
      source,
      width: _thumb,
      height: _thumb,
      interpolation: img.Interpolation.linear,
    );
    final vec = <double>[];
    for (var gy = 0; gy < _grid; gy++) {
      for (var gx = 0; gx < _grid; gx++) {
        var r = 0.0, g = 0.0, b = 0.0;
        var n = 0;
        for (var y = gy * _cell; y < (gy + 1) * _cell; y++) {
          for (var x = gx * _cell; x < (gx + 1) * _cell; x++) {
            final px = s.getPixel(x, y);
            r += px.r;
            g += px.g;
            b += px.b;
            n++;
          }
        }
        vec.addAll([r / n / 255.0, g / n / 255.0, b / n / 255.0]);
      }
    }
    return vec;
  }

  static double _cosine(List<double> a, List<double> b) {
    if (a.length != b.length) return 0;
    var dot = 0.0;
    var na = 0.0;
    var nb = 0.0;
    for (var i = 0; i < a.length; i++) {
      dot += a[i] * b[i];
      na += a[i] * a[i];
      nb += b[i] * b[i];
    }
    if (na <= 1e-12 || nb <= 1e-12) return 0;
    return dot / (math.sqrt(na) * math.sqrt(nb));
  }
}
