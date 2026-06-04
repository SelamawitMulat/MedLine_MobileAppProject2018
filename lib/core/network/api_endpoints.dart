import 'package:flutter/foundation.dart';

class ApiEndpoints {
  static String get baseUrl {
    // Use localhost for web and desktop; 10.0.2.2 only for Android emulator
    if (kIsWeb) {
      return 'http://localhost:4000';
    }
    // For desktop environments (Linux, macOS, Windows), use localhost
    // Only Android emulator should use 10.0.2.2
    return 'http://localhost:4000';
  }

  static String get users => '$baseUrl/api/users';
  static String get appointments => '$baseUrl/api/appointments';
  static String get visitSummaries => '$baseUrl/api/visit-summaries';

  static String get authSignup => '$baseUrl/api/auth/signup';
  static String get authLogin => '$baseUrl/api/auth/login';
  static String get authMe => '$baseUrl/api/auth/me';
}
