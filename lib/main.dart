import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kizuna_quest/app.dart';
import 'package:kizuna_quest/core/services/settings_service.dart';
import 'package:kizuna_quest/core/utils/app_logger.dart';
import 'package:kizuna_quest/firebase_options.dart';
import 'package:window_manager/window_manager.dart';

import 'providers/database_provider.dart';
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

  // Initialize window manager for desktop platforms
  await initWindowManager();

  // Initialize Firebase if not web and in release mode
  // We'll keep analytics off for debug builds
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (!kIsWeb) {
    try {
      // Configure Crashlytics
      // FlutterError.onError = (errorDetails) {
      //   FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      // };

      // // Pass all uncaught asynchronous errors to Crashlytics
      // PlatformDispatcher.instance.onError = (error, stack) {
      //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      //   return true;
      // };

      // Only enable analytics in release mode
      await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(!kDebugMode);
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

  // Initialize active save ID after app starts
  _initializeActiveSaveId();
}

/// Initialize the active save ID from settings
Future<void> _initializeActiveSaveId() async {
  try {
    final activeSaveId = SettingsService.getActiveSaveId();
    if (activeSaveId != null) {
      // Check if this save ID exists in the database
      final gameRepository = _container.read(gameRepositoryProvider);
      final saveGame = await gameRepository.getSaveGameById(activeSaveId);

      if (saveGame != null) {
        // Set the active save ID in the provider
        await _container.read(activeSaveIdProvider.notifier).setActiveSaveId(activeSaveId);
        AppLogger.info('Restored active save game: ${saveGame.playerName} (ID: $activeSaveId)');
      } else {
        // Save ID doesn't exist anymore, clear it
        await SettingsService.setActiveSaveId(null);
        AppLogger.warning('Saved game ID $activeSaveId no longer exists, clearing active save');
      }
    }
  } catch (e, stack) {
    AppLogger.error('Error initializing active save ID', error: e, stackTrace: stack);
  }
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

Future<void> initWindowManager() async {
  if (!Platform.isWindows && !Platform.isLinux && !Platform.isMacOS) {
    return;
  }

  const size = Size(500, 800);
  await windowManager.ensureInitialized();
  const windowOptions = WindowOptions(
    maximumSize: size,
    minimumSize: size,
    size: size,
    center: true,
    backgroundColor: Color.fromARGB(255, 255, 255, 255),
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    title: 'Kizuna Quest',
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}
