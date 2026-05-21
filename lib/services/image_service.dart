import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

/// Pilih & unggah gambar — izin galeri/kamera (Android 13+ & lama).
class ImageService {
  ImageService._();

  static final ImagePicker picker = ImagePicker();
  static const int maxProductPhotos = 8;

  /// `true` jika boleh membuka galeri; `false` = ditolak permanen.
  static Future<bool> ensureGalleryAccess() async {
    if (kIsWeb) return true;
    if (!Platform.isAndroid && !Platform.isIOS) return true;

    if (Platform.isAndroid) {
      var photos = await Permission.photos.status;
      if (!photos.isGranted && !photos.isLimited) {
        photos = await Permission.photos.request();
      }
      if (photos.isGranted || photos.isLimited) return true;

      var storage = await Permission.storage.status;
      if (!storage.isGranted) {
        storage = await Permission.storage.request();
      }
      if (storage.isGranted) return true;

      return false;
    }

    var ios = await Permission.photos.status;
    if (!ios.isGranted && !ios.isLimited) {
      ios = await Permission.photos.request();
    }
    return ios.isGranted || ios.isLimited;
  }

  static Future<bool> ensureCameraAccess() async {
    if (kIsWeb) return true;
    var cam = await Permission.camera.status;
    if (!cam.isGranted) {
      cam = await Permission.camera.request();
    }
    return cam.isGranted;
  }

  static Future<bool> isGalleryPermanentlyDenied() async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) {
      return false;
    }
    if (Platform.isAndroid) {
      final photos = await Permission.photos.status;
      final storage = await Permission.storage.status;
      return photos.isPermanentlyDenied && storage.isPermanentlyDenied;
    }
    return (await Permission.photos.status).isPermanentlyDenied;
  }

  static Future<List<File>> pickMultipleFromGallery({int max = 8}) async {
    final picked = await picker.pickMultiImage(
      imageQuality: 72,
      maxWidth: 1920,
    );
    if (picked.isEmpty) return [];
    return picked.take(max).map((e) => File(e.path)).toList();
  }

  static Future<File?> pickFromGallery() async {
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 72,
      maxWidth: 1920,
    );
    if (picked == null) return null;
    return File(picked.path);
  }

  static Future<File?> pickFromCamera() async {
    final picked = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 72,
      maxWidth: 1920,
    );
    if (picked == null) return null;
    return File(picked.path);
  }
}
