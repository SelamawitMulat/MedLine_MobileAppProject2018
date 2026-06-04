import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:med_line/core/logging/app_logger.dart';

class ApiClient {
  Future<dynamic> get(String url, {Map<String, String>? headers}) async {
    AppLogger.info('📤 GET $url', name: 'ApiClient');
    final response = await http.get(Uri.parse(url), headers: headers);
    AppLogger.info('📥 GET Response: ${response.statusCode}',
        name: 'ApiClient');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    }
    throw Exception('GET ${response.statusCode}: ${response.body}');
  }

  Future<dynamic> post(String url,
      {Map<String, dynamic>? data, Map<String, String>? headers}) async {
    AppLogger.info('📤 POST $url', name: 'ApiClient');
    if (data != null)
      AppLogger.info('   Data: ${jsonEncode(data)}', name: 'ApiClient');
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json', ...?headers},
      body: jsonEncode(data ?? {}),
    );
    AppLogger.info('📥 POST Response: ${response.statusCode}',
        name: 'ApiClient');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    }
    throw Exception('POST ${response.statusCode}: ${response.body}');
  }

  Future<dynamic> put(String url,
      {Map<String, dynamic>? data, Map<String, String>? headers}) async {
    AppLogger.info('📤 PUT $url', name: 'ApiClient');
    if (data != null)
      AppLogger.info('   Data: ${jsonEncode(data)}', name: 'ApiClient');
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json', ...?headers},
      body: jsonEncode(data ?? {}),
    );
    AppLogger.info('📥 PUT Response: ${response.statusCode}',
        name: 'ApiClient');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    }
    throw Exception('PUT ${response.statusCode}: ${response.body}');
  }

  Future<dynamic> delete(String url, {Map<String, String>? headers}) async {
    AppLogger.info('📤 DELETE $url', name: 'ApiClient');
    final response = await http.delete(Uri.parse(url), headers: headers);
    AppLogger.info('📥 DELETE Response: ${response.statusCode}',
        name: 'ApiClient');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    }
    throw Exception('DELETE ${response.statusCode}: ${response.body}');
  }
}
