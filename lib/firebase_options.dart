// ignore_for_file: lines_longer_than_80_chars
//
// Ganti nilai di bawah dari Firebase Console → Project settings → Your apps
// Atau jalankan: dart pub global activate flutterfire_cli && flutterfire configure
//
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

import 'config/firebase_project_config.dart';

/// Firebase app = **project-uas-44504** (sesuai `android/app/google-services.json`).
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return ios;
      default:
        throw UnsupportedError(
          'Tambahkan platform di firebase_options.dart atau gunakan flutterfire configure.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'REPLACE_WITH_WEB_API_KEY',
    appId: 'REPLACE_WITH_WEB_APP_ID',
    messagingSenderId: FirebaseProjectConfig.appMessagingSenderId,
    projectId: FirebaseProjectConfig.appProjectId,
    authDomain: '${FirebaseProjectConfig.appProjectId}.firebaseapp.com',
    storageBucket: FirebaseProjectConfig.appStorageBucket,
    databaseURL: FirebaseProjectConfig.rtdbDatabaseUrl,
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAkCknm553QnUMmNmVFINCVywkSaiD7d-Y',
    appId: '1:197173737037:android:a0372e8ad0ca0364300e04',
    messagingSenderId: FirebaseProjectConfig.appMessagingSenderId,
    projectId: FirebaseProjectConfig.appProjectId,
    storageBucket: FirebaseProjectConfig.appStorageBucket,
    databaseURL: FirebaseProjectConfig.rtdbDatabaseUrl,
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'REPLACE_WITH_IOS_API_KEY',
    appId: 'REPLACE_WITH_IOS_APP_ID',
    messagingSenderId: FirebaseProjectConfig.appMessagingSenderId,
    projectId: FirebaseProjectConfig.appProjectId,
    storageBucket: FirebaseProjectConfig.appStorageBucket,
    databaseURL: FirebaseProjectConfig.rtdbDatabaseUrl,
    iosBundleId: 'com.example.shopping',
  );
}
