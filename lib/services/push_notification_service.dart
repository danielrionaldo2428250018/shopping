import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../constants/fcm_config.dart';

/// Hasil kirim push via shopping-cloud (pola fasum-cloud).
class PushTopicResult {
  const PushTopicResult({
    required this.ok,
    this.statusCode,
    this.messageId,
    this.error,
  });

  final bool ok;
  final int? statusCode;
  final String? messageId;
  final String? error;
}

/// Detail respons shopping-cloud (debug / log).
Future<PushTopicResult> sendNotificationToTopicDetailed({
  required String title,
  required String body,
  String senderName = FcmConfig.defaultSenderName,
  String senderPhotoUrl = '',
  String topic = FcmConfig.topic,
  Map<String, String>? data,
}) async {
  final url = Uri.parse('${FcmConfig.cloudApiBaseUrl}/send-to-topic');
  final sentAt = DateTime.now().toIso8601String();

  final dataPayload = <String, String>{
    'title': title,
    'body': body,
    'senderName': senderName,
    if (senderPhotoUrl.isNotEmpty) 'senderPhotoUrl': senderPhotoUrl,
    'sentAt': sentAt,
    if (data != null) ...data,
  };

  try {
    final response = await http
        .post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'topic': topic,
            'title': title,
            'body': body,
            'senderName': senderName,
            'senderPhotoUrl': senderPhotoUrl,
            'sentAt': sentAt,
            'data': dataPayload,
          }),
        )
        .timeout(const Duration(seconds: 20));

    if (kDebugMode) {
      debugPrint('push topic ${response.statusCode}: ${response.body}');
    }

    if (response.statusCode != 200) {
      return PushTopicResult(
        ok: false,
        statusCode: response.statusCode,
        error: response.body,
      );
    }

    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map) {
        final success = decoded['success'] == true || decoded['ok'] == true;
        if (!success) {
          return PushTopicResult(
            ok: false,
            statusCode: 200,
            error: decoded['error']?.toString() ?? response.body,
          );
        }
        return PushTopicResult(
          ok: true,
          statusCode: 200,
          messageId: decoded['messageId']?.toString(),
        );
      }
    } catch (_) {}

    return const PushTopicResult(ok: true, statusCode: 200);
  } catch (e, st) {
    if (kDebugMode) debugPrint('push topic error: $e\n$st');
    return PushTopicResult(ok: false, error: e.toString());
  }
}

/// Kirim push ke subscriber topic via shopping-cloud (sama pola fasum).
Future<bool> sendNotificationToTopic({
  required String title,
  required String body,
  String senderName = FcmConfig.defaultSenderName,
  String senderPhotoUrl = '',
  String topic = FcmConfig.topic,
  Map<String, String>? data,
}) async {
  final r = await sendNotificationToTopicDetailed(
    title: title,
    body: body,
    senderName: senderName,
    senderPhotoUrl: senderPhotoUrl,
    topic: topic,
    data: data,
  );
  return r.ok;
}
