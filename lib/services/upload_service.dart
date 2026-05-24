import 'dart:io';



import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/foundation.dart';



import '../config/firebase_project_config.dart';

import '../config/media_upload_config.dart';

import 'rtdb_image_upload.dart';



/// Kode kegagalan unggah — untuk pesan UI yang tepat.

enum UploadFailureCode {

  notAuthenticated,

  fileMissing,

  unauthorized,

  storageRules,

  network,

  imageTooLarge,

  unknown,

}



class UploadFailure implements Exception {

  UploadFailure(this.code, {this.debugMessage});



  final UploadFailureCode code;

  final String? debugMessage;



  @override

  String toString() =>

      'UploadFailure($code${debugMessage != null ? ': $debugMessage' : ''})';

}



/// Unggah foto produk ke Firebase Storage atau RTDB (data-URL).

abstract final class UploadService {

  static FirebaseStorage get _storage {

    try {

      return FirebaseStorage.instanceFor(

        bucket: FirebaseProjectConfig.appStorageBucket,

      );

    } catch (_) {

      return FirebaseStorage.instance;

    }

  }



  static Future<String> _putAndGetUrl(Reference ref, File file) async {

    await ref.putFile(

      file,

      SettableMetadata(contentType: 'image/jpeg'),

    );

    return ref.getDownloadURL();

  }



  static Future<File> _prepareProductFile(File file) async {

    final compressed = await compressImageForUpload(

      file,

      maxWidth: MediaUploadConfig.productImageMaxWidth,

      quality: MediaUploadConfig.productImageJpegQuality,

    );

    if (compressed == null) {

      throw UploadFailure(UploadFailureCode.imageTooLarge);

    }

    return compressed;

  }



  static Future<String> _uploadToRtdbDataUrl(File file) async {

    final dataUrl = await fileToCompactDataImageUrl(

      file,

      maxWidth: MediaUploadConfig.rtdbImageMaxWidth,

      quality: MediaUploadConfig.rtdbImageJpegQuality,

      maxBytes: MediaUploadConfig.rtdbImageMaxBytes,

    );

    if (dataUrl == null) {

      throw UploadFailure(UploadFailureCode.imageTooLarge);

    }

    return dataUrl;

  }



  static Future<String> uploadProductImage(File file) async {

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {

      throw UploadFailure(UploadFailureCode.notAuthenticated);

    }

    if (!await file.exists()) {

      throw UploadFailure(

        UploadFailureCode.fileMissing,

        debugMessage: file.path,

      );

    }



    if (!MediaUploadConfig.useFirebaseStorage) {

      return _uploadToRtdbDataUrl(file);

    }



    final prepared = await _prepareProductFile(file);

    final ref = _storage.ref(

      'products/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg',

    );



    try {

      return await _putAndGetUrl(ref, prepared);

    } on FirebaseException catch (e, st) {

      if (kDebugMode) {

        debugPrint('Storage upload error: ${e.code} ${e.message}\n$st');

      }

      throw UploadFailure(

        _mapFirebaseCode(e.code),

        debugMessage: '${e.code}: ${e.message}',

      );

    } catch (e, st) {

      if (e is UploadFailure) rethrow;

      if (kDebugMode) debugPrint('Storage upload: $e\n$st');

      throw UploadFailure(

        UploadFailureCode.unknown,

        debugMessage: e.toString(),

      );

    }

  }



  static UploadFailureCode _mapFirebaseCode(String code) {

    switch (code) {

      case 'unauthorized':

      case 'permission-denied':

        return UploadFailureCode.storageRules;

      case 'unauthenticated':

        return UploadFailureCode.notAuthenticated;

      case 'object-not-found':

      case 'bucket-not-found':

        return UploadFailureCode.storageRules;

      case 'retry-limit-exceeded':

      case 'canceled':

        return UploadFailureCode.network;

      default:

        return UploadFailureCode.unknown;

    }

  }



  static Future<List<String>> uploadMultiple(List<File> files) async {

    final urls = <String>[];

    for (final file in files) {

      urls.add(await uploadProductImage(file));

    }

    return urls;

  }



  static Future<List<String>> uploadMultipleWithProgress({

    required List<File> files,

    required Function(double) onProgress,

  }) async {

    final urls = <String>[];

    if (files.isEmpty) return urls;



    var done = 0;

    for (final file in files) {

      urls.add(await uploadProductImage(file));

      done++;

      onProgress(done / files.length);

    }

    return urls;

  }

}


