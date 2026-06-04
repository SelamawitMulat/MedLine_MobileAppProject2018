import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Small logging wrapper used across the app.
/// In debug builds logs are printed via `developer.log`.
class AppLogger {
  static void info(String message, {String name = 'App'}) {
    if (kDebugMode) developer.log(message, name: name, level: 800);
  }

  static void warn(String message, {String name = 'App'}) {
    if (kDebugMode) developer.log(message, name: name, level: 900);
  }

  static void error(String message, {String name = 'App'}) {
    if (kDebugMode) developer.log(message, name: name, level: 1000);
  }
}
