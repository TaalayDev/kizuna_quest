import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kizuna_quest/app.dart';
import 'package:kizuna_quest/core/services/settings_service.dart';
import 'package:kizuna_quest/utils/app_logger.dart';
//import 'package:kizuna_quest/utils/firebase_options.dart';

/// Global providers container reference for use in tests
final ProviderContainer _container = ProviderContainer(
  observers: [if (kDebugMode) _ProviderObserver()],
);

void main() async {
  // Ensure Flutter is properly initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait for the visual novel experience
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Disable system overlay - full immersion
  // This can be toggled later in the UI if needed
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top],
  );

  // Set error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    AppLogger.error(
      'Flutter error',
      error: details.exception,
      stackTrace: details.stack,
    );
    FlutterError.presentError(details);
  };

  // Handle errors not caught by Flutter
  PlatformDispatcher.instance.onError = (error, stack) {
    AppLogger.error(
      'Uncaught platform error',
      error: error,
      stackTrace: stack,
    );
    return true;
  };

  // Initialize Firebase if not web and in release mode
  // We'll keep analytics off for debug builds
  if (!kIsWeb) {
    try {
      // await Firebase.initializeApp(
      //   options: DefaultFirebaseOptions.currentPlatform,
      // );

      // Configure Crashlytics
      // FlutterError.onError = (errorDetails) {
      //   FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      // };

      // Pass all uncaught asynchronous errors to Crashlytics
      // PlatformDispatcher.instance.onError = (error, stack) {
      //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      //   return true;
      // };

      // Only enable analytics in release mode
      // await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(!kDebugMode);
    } catch (e, stack) {
      AppLogger.error(
        'Failed to initialize Firebase',
        error: e,
        stackTrace: stack,
      );
      // Continue without Firebase - app should still work offline
    }
  }

  // Initialize settings
  await SettingsService.initialize();

  // Run the app inside a ProviderScope
  runApp(
    UncontrolledProviderScope(
      container: _container,
      child: const KizunaQuestApp(),
    ),
  );
}

/// Debug observer to log provider changes
class _ProviderObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    if (kDebugMode && previousValue != newValue) {
      // debugPrint(
      //   '[Provider Updated] ${provider.name ?? provider.runtimeType} '
      //   '- Value: $newValue',
      // );
    }
  }
}
