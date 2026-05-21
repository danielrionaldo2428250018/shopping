import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageService {
  static final picker = ImagePicker();

  static Future<List<File>> pickMultipleImages() async {
    final picked = await picker.pickMultiImage(imageQuality: 70);
    return picked.map((e) => File(e.path)).toList();
  }
}