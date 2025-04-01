import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kizuna_quest/config/router/app_router.dart';
import 'package:kizuna_quest/config/theme/app_theme.dart';
import 'package:kizuna_quest/providers/theme_providers.dart';
import 'package:kizuna_quest/utils/constants.dart';

/// The main application widget for Kizuna Quest.
class KizunaQuestApp extends ConsumerWidget {
  const KizunaQuestApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
