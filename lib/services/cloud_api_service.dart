import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../constants/fcm_config.dart';

/// Cek koneksi ke shopping-cloud (Vercel).
class CloudApiService {
  CloudApiService._();

  static Uri get _healthUri =>
      Uri.parse('${FcmConfig.cloudApiBaseUrl}/health');

  static Future<CloudHealthResult> checkHealth() async {
    try {
      final response = await http
          .get(_healthUri)
          .timeout(const Duration(seconds: 12));
      if (response.statusCode != 200) {
        return CloudHealthResult(
          ok: false,
          statusCode: response.statusCode,
          message: response.body,
        );
      }
      final body = jsonDecode(response.body);
      if (body is Map && body['ok'] == true) {
        return CloudHealthResult(
          ok: true,
          statusCode: 200,
          firebaseProject: body['firebase']?.toString(),
          topic: body['topic']?.toString(),
        );
      }
      return CloudHealthResult(
        ok: false,
        statusCode: 200,
        message: response.body,
      );
    } catch (e, st) {
      if (kDebugMode) debugPrint('cloud health error: $e\n$st');
      return CloudHealthResult(ok: false, message: e.toString());
    }
  }
}

class CloudHealthResult {
  const CloudHealthResult({
    required this.ok,
    this.statusCode,
    this.message,
    this.firebaseProject,
    this.topic,
  });

  final bool ok;
  final int? statusCode;
  final String? message;
  final String? firebaseProject;
  final String? topic;
}
