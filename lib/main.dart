import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsuzuki_connect/app.dart';
import 'package:tsuzuki_connect/core/services/settings_service.dart';
import 'package:tsuzuki_connect/core/utils/app_logger.dart';
import 'package:tsuzuki_connect/firebase_options.dart';
import 'package:window_manager/window_manager.dart';

import 'providers/database_provider.dart';
//import 'package:tsuzuki_connect/utils/firebase_options.dart';

final ProviderContainer _container = ProviderContainer(
  observers: [if (kDebugMode) _ProviderObserver()],
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top],
  );

  await initWindowManager();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (!kIsWeb) {
    try {
      // FlutterError.onError = (errorDetails) {
      //   FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      // };

      // PlatformDispatcher.instance.onError = (error, stack) {
      //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      //   return true;
      // };

      await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(!kDebugMode);
    } catch (e, stack) {
      AppLogger.error(
        'Failed to initialize Firebase',
        error: e,
        stackTrace: stack,
      );
    }
  }

  await SettingsService.initialize();

  runApp(
    UncontrolledProviderScope(
      container: _container,
      child: const TsuzukiConnectApp(),
    ),
  );

  _initializeActiveSaveId();
}

Future<void> _initializeActiveSaveId() async {
  try {
    final activeSaveId = SettingsService.getActiveSaveId();
    if (activeSaveId != null) {
      final gameRepository = _container.read(gameRepositoryProvider);
      final saveGame = await gameRepository.getSaveGameById(activeSaveId);

      if (saveGame != null) {
        await _container.read(activeSaveIdProvider.notifier).setActiveSaveId(activeSaveId);
        AppLogger.info('Restored active save game: ${saveGame.playerName} (ID: $activeSaveId)');
      } else {
        await SettingsService.setActiveSaveId(null);
        AppLogger.warning('Saved game ID $activeSaveId no longer exists, clearing active save');
      }
    }
  } catch (e, stack) {
    AppLogger.error('Error initializing active save ID', error: e, stackTrace: stack);
  }
}

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

  const size = Size(1024, 800);
  await windowManager.ensureInitialized();
  const windowOptions = WindowOptions(
    // minimumSize: size,
    size: size,
    center: true,
    backgroundColor: Color.fromARGB(255, 255, 255, 255),
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    title: 'Tsuzuki Connect',
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}
