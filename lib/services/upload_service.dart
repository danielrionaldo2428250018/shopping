import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class UploadService {
  static Future<List<String>> uploadMultipleWithProgress({
    required List<File> files,
    required Function(double) onProgress,
  }) async {
    List<String> urls = [];

    int total = 0;
    int sent = 0;

    for (var f in files) {
      total += await f.length();
    }

    for (var file in files) {
      final ref = FirebaseStorage.instance
          .ref('products/${DateTime.now().millisecondsSinceEpoch}.jpg');

      final task = ref.putFile(file);

      task.snapshotEvents.listen((e) {
        sent += e.bytesTransferred;
        onProgress(sent / total);
      });

      await task;
      urls.add(await ref.getDownloadURL());
    }

    return urls;
  }

  static Future<List<String>> uploadMultiple(List<File> files) async {
    List<String> urls = [];

    for (var file in files) {
      final ref = FirebaseStorage.instance
          .ref('products/${DateTime.now().millisecondsSinceEpoch}.jpg');

      await ref.putFile(file);
      urls.add(await ref.getDownloadURL());
    }

    return urls;
  }
}