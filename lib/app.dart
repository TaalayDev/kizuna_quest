import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kizuna_quest/config/router/app_router.dart';
import 'package:kizuna_quest/config/theme/app_theme.dart';
import 'package:kizuna_quest/providers/sound_controller.dart';
import 'package:kizuna_quest/providers/theme_providers.dart';
import 'package:kizuna_quest/core/utils/constants.dart';

import 'providers/app_providers.dart';

/// The main application widget for Kizuna Quest.
class KizunaQuestApp extends ConsumerStatefulWidget {
  const KizunaQuestApp({super.key});

  @override
  ConsumerState<KizunaQuestApp> createState() => _KizunaQuestAppState();
}

class _KizunaQuestAppState extends ConsumerState<KizunaQuestApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    ref.read(soundControllerProvider.notifier).playBgm();
    _incrementSessionCount();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _incrementSessionCount();
    }
  }

  void _incrementSessionCount() async {
    final reviewService = ref.read(inAppReviewProvider);
    await reviewService.incrementSessionCount();
  }

  @override
  Widget build(BuildContext context) {
    // Get the current theme mode from provider
    final themeMode = ref.watch(themeModeProvider);

    // Get the router configuration
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      // App info
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,

      // Routing
      routerConfig: router,

      // Analytics (Firebase)
      // navigatorObservers: [
      //   FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      // ],

      // Theme configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,

      // Localization support
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'), // English
        Locale('ja', 'JP'), // Japanese
      ],

      // Builder for custom overlay styling
      builder: (context, child) {
        return MediaQuery(
          // Prevent UI from resizing when keyboard appears
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
    );
  }
}
