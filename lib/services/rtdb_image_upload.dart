import 'dart:convert';
import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

/// Kompres foto produk (Storage) atau ke data-URL untuk Realtime Database.
Future<File?> compressImageForUpload(
  File file, {
  int maxWidth = 1024,
  int quality = 78,
  int maxBytes = 2 * 1024 * 1024,
}) async {
  if (!await file.exists()) return null;
  final raw = await file.readAsBytes();
  var decoded = img.decodeImage(raw);
  if (decoded == null) return null;

  if (decoded.width > maxWidth) {
    decoded = img.copyResize(decoded, width: maxWidth);
  }

  var q = quality;
  List<int> jpg = img.encodeJpg(decoded, quality: q);
  while (jpg.length > maxBytes && q > 40) {
    q -= 6;
    jpg = img.encodeJpg(decoded, quality: q);
  }
  if (jpg.length > maxBytes) return null;

  final dir = await getTemporaryDirectory();
  final out = File(
    '${dir.path}/upload_${DateTime.now().millisecondsSinceEpoch}.jpg',
  );
  await out.writeAsBytes(jpg, flush: true);
  return out;
}

/// Data-URL JPEG terkompres — disimpan di RTDB pada field `imageUrl` produk.
Future<String?> fileToCompactDataImageUrl(
  File file, {
  int maxWidth = 640,
  int quality = 68,
  int maxBytes = 750000,
}) async {
  if (!await file.exists()) return null;
  final raw = await file.readAsBytes();
  var decoded = img.decodeImage(raw);
  if (decoded == null) return null;

  if (decoded.width > maxWidth) {
    decoded = img.copyResize(decoded, width: maxWidth);
  }

  var q = quality;
  List<int> jpg = img.encodeJpg(decoded, quality: q);
  while (jpg.length > maxBytes && q > 35) {
    q -= 8;
    jpg = img.encodeJpg(decoded, quality: q);
  }
  if (jpg.length > maxBytes) return null;

  return 'data:image/jpeg;base64,${base64Encode(jpg)}';
}
