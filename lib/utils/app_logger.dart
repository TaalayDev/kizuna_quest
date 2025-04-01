import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// A utility class for logging throughout the application.
///
/// Uses the logger package for dev/debug builds and integrates
/// with Firebase Crashlytics for release builds.
class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
    level: kDebugMode ? Level.verbose : Level.warning,
  );

  /// Log a debug message
  static void debug(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Log an info message
  static void info(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Log a warning message
  static void warning(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.w(message, error: error, stackTrace: stackTrace);

    if (!kDebugMode && error != null) {
      // Record non-fatal warning to Crashlytics in release mode
      _recordToCrashlytics(message, error, stackTrace, false);
    }
  }

  /// Log an error message
  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.e(message, error: error, stackTrace: stackTrace);

    if (!kDebugMode && error != null) {
      // Record non-fatal error to Crashlytics in release mode
      _recordToCrashlytics(message, error, stackTrace, false);
    }
  }

  /// Log a fatal error
  static void fatal(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.f(message, error: error, stackTrace: stackTrace);

    if (!kDebugMode && error != null) {
      // Record fatal error to Crashlytics in release mode
      _recordToCrashlytics(message, error, stackTrace, true);
    }
  }

  /// Record error to Crashlytics if available
  static void _recordToCrashlytics(
    String message,
    Object error,
    StackTrace? stackTrace,
    bool fatal,
  ) {
    try {
      // Add custom message as key
      FirebaseCrashlytics.instance.setCustomKey('last_error_message', message);

      // Record the error
      FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: message,
        fatal: fatal,
      );
    } catch (e) {
      // Firebase might not be initialized or available
      debugPrint('Failed to record error to Crashlytics: $e');
    }
  }
}
