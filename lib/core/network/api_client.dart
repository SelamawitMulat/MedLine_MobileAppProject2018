import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  Future<dynamic> get(String url, {Map<String, String>? headers}) async {
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    }
    throw Exception('GET ${response.statusCode}: ${response.body}');
  }

  Future<dynamic> post(String url, {Map<String, dynamic>? data, Map<String, String>? headers}) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json', ...?headers},
      body: jsonEncode(data ?? {}),
    );
    print('POST URL: $url | Status: ${response.statusCode} | Body: ${response.body}');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    }
    throw Exception('POST ${response.statusCode}: ${response.body}');
  }

  Future<dynamic> put(String url, {Map<String, dynamic>? data, Map<String, String>? headers}) async {
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json', ...?headers},
      body: jsonEncode(data ?? {}),
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    }
    throw Exception('PUT ${response.statusCode}: ${response.body}');
  }

  Future<dynamic> delete(String url, {Map<String, String>? headers}) async {
    final response = await http.delete(Uri.parse(url), headers: headers);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    }
    throw Exception('DELETE ${response.statusCode}: ${response.body}');
  }
}