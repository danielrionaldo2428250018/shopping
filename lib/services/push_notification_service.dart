import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../constants/fcm_config.dart';

/// Kirim push ke semua subscriber topic via shopping-cloud (seperti fasum → fasum-cloud).
Future<bool> sendNotificationToTopic({
  required String title,
  required String body,
  String senderName = FcmConfig.defaultSenderName,
  String senderPhotoUrl = '',
  String topic = FcmConfig.topic,
}) async {
  final url = Uri.parse('${FcmConfig.cloudApiBaseUrl}/send-to-topic');
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'topic': topic,
        'title': title,
        'body': body,
        'senderName': senderName,
        'senderPhotoUrl': senderPhotoUrl,
      }),
    );
    if (kDebugMode) {
      debugPrint('push topic ${response.statusCode}: ${response.body}');
    }
    return response.statusCode == 200;
  } catch (e, st) {
    if (kDebugMode) debugPrint('push topic error: $e\n$st');
    return false;
  }
}
