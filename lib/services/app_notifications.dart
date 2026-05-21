import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import '../constants/app_branding.dart';
import '../constants/fcm_config.dart';
import '../firebase_options.dart';

/// Notifikasi lokal + FCM — pola sama dengan project fasum.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// @deprecated Gunakan [FcmConfig.topic].
const String kShoppingFcmTopic = FcmConfig.topic;

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (message.data.isNotEmpty) {
    await showNotificationFromData(message.data);
  } else {
    await showBasicNotification(
      message.notification?.title,
      message.notification?.body,
    );
  }
}

Future<void> requestFcmNotificationPermission() async {
  final messaging = FirebaseMessaging.instance;
  final settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  if (kDebugMode) {
    debugPrint('FCM permission: ${settings.authorizationStatus}');
  }
}

Future<void> showBasicNotification(String? title, String? body) async {
  const android = AndroidNotificationDetails(
    'preloved_default',
    'Notifikasi PreLoved',
    channelDescription: 'Pesan & update dari FCM',
    importance: Importance.high,
    priority: Priority.high,
    showWhen: true,
  );
  const platform = NotificationDetails(android: android);
  await flutterLocalNotificationsPlugin.show(
    0,
    title ?? AppBranding.appName,
    body ?? '',
    platform,
  );
}

Future<void> showNotificationFromData(Map<String, dynamic> data) async {
  final title = data['title']?.toString() ?? 'Pesan baru';
  final body = data['body']?.toString() ?? '';
  final sender = data['senderName']?.toString() ?? 'PreLoved';
  final time = data['sentAt']?.toString() ?? '';
  final photoUrl = data['senderPhotoUrl']?.toString() ?? '';

  ByteArrayAndroidBitmap? largeIconBitmap;
  if (photoUrl.isNotEmpty) {
    final base64 = await _networkImageToBase64(photoUrl);
    if (base64 != null) {
      largeIconBitmap = ByteArrayAndroidBitmap.fromBase64String(base64);
    }
  }

  final styleInfo = largeIconBitmap != null
      ? BigPictureStyleInformation(
          largeIconBitmap,
          contentTitle: title,
          summaryText: '$body\n\nDari: $sender - $time',
          largeIcon: largeIconBitmap,
          hideExpandedLargeIcon: true,
        )
      : BigTextStyleInformation(
          '$body\n\nDari: $sender\nWaktu: $time',
          contentTitle: title,
        );

  final androidDetails = AndroidNotificationDetails(
    'preloved_detailed',
    'Notifikasi detail',
    channelDescription: 'Notifikasi pesan dengan detail',
    styleInformation: styleInfo,
    largeIcon: largeIconBitmap,
    importance: Importance.max,
    priority: Priority.max,
  );

  final platform = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    1,
    title,
    body,
    platform,
  );
}

Future<String?> _networkImageToBase64(String url) async {
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return base64Encode(response.bodyBytes);
    }
  } catch (_) {}
  return null;
}

Future<void> initializeAppNotifications({required bool firebaseReady}) async {
  const settings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    iOS: DarwinInitializationSettings(),
  );
  await flutterLocalNotificationsPlugin.initialize(settings);

  if (!firebaseReady) return;

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await requestFcmNotificationPermission();

  try {
    final token = await FirebaseMessaging.instance.getToken();
    if (kDebugMode) debugPrint('FCM Token: $token');
    await FirebaseMessaging.instance.subscribeToTopic(FcmConfig.topic);
  } catch (e) {
    if (kDebugMode) debugPrint('FCM setup: $e');
  }

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.data.isNotEmpty) {
      showNotificationFromData(message.data);
    } else {
      showBasicNotification(
        message.notification?.title,
        message.notification?.body,
      );
    }
  });
}
