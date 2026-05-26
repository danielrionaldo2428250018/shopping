import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import '../constants/app_branding.dart';
import '../constants/fcm_config.dart';
import '../firebase_options.dart';
import 'in_app_notification_host.dart';

/// Notifikasi lokal + FCM + banner atas layar (pola fasum).
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// @deprecated Gunakan [FcmConfig.topic].
const String kShoppingFcmTopic = FcmConfig.topic;

bool _notificationsReady = false;

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await _presentFromRemoteMessage(message);
}

Future<void> _presentFromRemoteMessage(RemoteMessage message) async {
  if (message.data.isNotEmpty) {
    final title = message.data['title']?.toString() ??
        message.notification?.title ??
        'SECO';
    final body = message.data['body']?.toString() ??
        message.notification?.body ??
        '';
    await presentUserNotification(
      title: title,
      body: body,
      type: message.data['type']?.toString() ?? 'default',
      orderId: message.data['orderId']?.toString(),
      inAppOnly: false,
    );
    return;
  }
  final n = message.notification;
  await presentUserNotification(
    title: n?.title ?? AppBranding.appName,
    body: n?.body ?? '',
    inAppOnly: false,
  );
}

/// Izin notifikasi (Android 13+ wajib lewat plugin + permission_handler).
Future<bool> ensureNotificationPermission() async {
  if (kIsWeb) return false;

  if (defaultTargetPlatform == TargetPlatform.android) {
    final android = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
  final pluginGranted =
        await android?.requestNotificationsPermission() ?? false;
    final handler = await Permission.notification.request();
    return pluginGranted || handler.isGranted;
  }

  if (defaultTargetPlatform == TargetPlatform.iOS) {
    final ios = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    final granted = await ios?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        ) ??
        false;
    return granted;
  }

  return true;
}

Future<void> requestFcmNotificationPermission() async {
  final messaging = FirebaseMessaging.instance;
  final settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  await ensureNotificationPermission();
  if (kDebugMode) {
    debugPrint('FCM permission: ${settings.authorizationStatus}');
  }
}

Future<void> _ensureAndroidChannels() async {
  if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
  final android = flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
  if (android == null) return;
  await android.createNotificationChannel(
    const AndroidNotificationChannel(
      'preloved_default',
      'Notifikasi SECO',
      description: 'Pesan & update umum',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    ),
  );
  await android.createNotificationChannel(
    const AndroidNotificationChannel(
      'preloved_detailed',
      'Notifikasi detail',
      description: 'Pesan dengan detail lengkap',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    ),
  );
  await android.createNotificationChannel(
    const AndroidNotificationChannel(
      'preloved_orders',
      'Pesanan toko',
      description: 'Pesanan baru untuk penjual',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    ),
  );
}

/// Banner di atas layar + notifikasi sistem (jika izin OK).
Future<void> presentUserNotification({
  required String title,
  required String body,
  String type = 'default',
  String? orderId,
  bool inAppOnly = false,
}) async {
  InAppNotificationHost.instance.show(title: title, body: body);

  if (inAppOnly) return;

  if (!_notificationsReady) {
    await ensureNotificationPermission();
  }

  if (type == 'order') {
    await showOrderNotification(
      orderId: orderId ?? title.hashCode.toString(),
      title: title,
      body: body,
      skipInApp: true,
    );
    return;
  }

  await showBasicNotification(
    title,
    body,
    notificationId: (orderId ?? title).hashCode,
    skipInApp: true,
  );
}

Future<bool> _canShowSystemNotification() async {
  if (kIsWeb) return false;
  if (defaultTargetPlatform == TargetPlatform.android) {
    final status = await Permission.notification.status;
    return status.isGranted;
  }
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    final settings = await FirebaseMessaging.instance.getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }
  return true;
}

Future<void> showBasicNotification(
  String? title,
  String? body, {
  int notificationId = 0,
  bool skipInApp = false,
}) async {
  if (!skipInApp) {
    InAppNotificationHost.instance.show(
      title: title ?? AppBranding.appName,
      body: body ?? '',
    );
  }

  if (!await _canShowSystemNotification()) return;

  const android = AndroidNotificationDetails(
    'preloved_default',
    'Notifikasi SECO',
    channelDescription: 'Pesan & update dari FCM',
    importance: Importance.max,
    priority: Priority.max,
    showWhen: true,
    playSound: true,
    enableVibration: true,
    visibility: NotificationVisibility.public,
    category: AndroidNotificationCategory.message,
    ticker: 'SECO',
  );
  const platform = NotificationDetails(android: android);
  await flutterLocalNotificationsPlugin.show(
    notificationId,
    title ?? AppBranding.appName,
    body ?? '',
    platform,
  );
}

/// Popup pesanan baru — heads-up sistem + banner atas layar.
Future<void> showOrderNotification({
  required String orderId,
  required String title,
  required String body,
  bool skipInApp = false,
}) async {
  if (!skipInApp) {
    InAppNotificationHost.instance.show(title: title, body: body);
  }

  if (!await _canShowSystemNotification()) return;

  final styleInfo = BigTextStyleInformation(
    body,
    contentTitle: title,
  );
  final androidDetails = AndroidNotificationDetails(
    'preloved_orders',
    'Pesanan toko',
    channelDescription: 'Pesanan baru untuk penjual',
    styleInformation: styleInfo,
    importance: Importance.max,
    priority: Priority.max,
    playSound: true,
    enableVibration: true,
    showWhen: true,
    visibility: NotificationVisibility.public,
    category: AndroidNotificationCategory.status,
    ticker: title,
    channelAction: AndroidNotificationChannelAction.createIfNotExists,
  );
  await flutterLocalNotificationsPlugin.show(
    orderId.hashCode,
    title,
    body,
    NotificationDetails(android: androidDetails),
  );
}

Future<void> showNotificationFromData(Map<String, dynamic> data) async {
  final type = data['type']?.toString() ?? '';
  final title = data['title']?.toString() ?? 'Pesan baru';
  final body = data['body']?.toString() ?? '';

  if (type == 'order') {
    final orderId = data['orderId']?.toString() ?? '';
    await presentUserNotification(
      title: title,
      body: body,
      type: 'order',
      orderId: orderId.isNotEmpty ? orderId : 'order',
    );
    return;
  }

  final sender = data['senderName']?.toString() ?? 'SECO';
  final time = data['sentAt']?.toString() ?? '';
  final photoUrl = data['senderPhotoUrl']?.toString() ?? '';

  InAppNotificationHost.instance.show(title: title, body: body);

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
    playSound: true,
    enableVibration: true,
    visibility: NotificationVisibility.public,
    category: AndroidNotificationCategory.message,
    ticker: title,
  );

  final platform = NotificationDetails(android: androidDetails);

  final id = (data['orderId'] ?? data['threadId'] ?? title).hashCode;
  await flutterLocalNotificationsPlugin.show(
    id,
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
    iOS: DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    ),
  );
  await flutterLocalNotificationsPlugin.initialize(settings);
  await _ensureAndroidChannels();
  await ensureNotificationPermission();
  _notificationsReady = true;

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

  FirebaseMessaging.onMessage.listen(_presentFromRemoteMessage);
}
