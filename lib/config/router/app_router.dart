import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kizuna_quest/config/router/route_transitions.dart';
import 'package:kizuna_quest/presentation/screens/culture_notes_screen.dart';
import 'package:kizuna_quest/presentation/screens/game_screen.dart';
import 'package:kizuna_quest/presentation/screens/home_screen.dart';
import 'package:kizuna_quest/presentation/screens/kotoba_log_screen.dart';
import 'package:kizuna_quest/presentation/screens/onboarding_screen.dart';
import 'package:kizuna_quest/presentation/screens/settings_screen.dart';
import 'package:kizuna_quest/presentation/screens/splash_screen.dart';
import 'package:kizuna_quest/utils/app_logger.dart';
import 'package:kizuna_quest/utils/constants.dart';

/// Provider for the app router
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppConstants.routeSplash,
    debugLogDiagnostics: true,
    routerNeglect: true,
    routes: [
      // Splash screen
      GoRoute(
        path: AppConstants.routeSplash,
        name: 'splash',
        pageBuilder: (context, state) => FadeTransitionPage(
          key: state.pageKey,
          child: const SplashScreen(),
        ),
      ),

      GoRoute(
        path: AppConstants.onboardingRoute,
        name: 'onboarding',
        pageBuilder: (context, state) => FadeTransitionPage(
          key: state.pageKey,
          child: const OnboardingScreen(),
        ),
      ),

      // Home screen (main menu)
      GoRoute(
        path: AppConstants.routeHome,
        name: 'home',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const HomeScreen(),
          transitionsBuilder: slideTransition,
        ),
      ),

      // Game screen (main VN)
      GoRoute(
        path: AppConstants.routeGame,
        name: 'game',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: GameScreen(
            chapterId: state.uri.queryParameters['chapter'],
            saveId: state.uri.queryParameters['saveId'],
          ),
          transitionsBuilder: fadeTransition,
        ),
      ),

      // Kotoba log (vocabulary)
      GoRoute(
        path: AppConstants.routeKotobaLog,
        name: 'kotoba',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const KotobaLogScreen(),
          transitionsBuilder: slideTransition,
        ),
      ),

      // Cultural notes
      GoRoute(
        path: AppConstants.routeCultureNotes,
        name: 'culture',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const CultureNotesScreen(),
          transitionsBuilder: slideTransition,
        ),
      ),

      // Settings
      GoRoute(
        path: AppConstants.routeSettings,
        name: 'settings',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SettingsScreen(),
          transitionsBuilder: slideTransition,
        ),
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Page not found',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => context.go(AppConstants.routeHome),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    ),
    redirect: (context, state) {
      // No redirects for now, but could add authentication checks here
      return null;
    },
    // refreshListenable: GoRouterRefreshStream(ref.read),
    observers: [
      _GoRouterObserver(),
    ],
  );
});

/// Custom router observer for logging navigation events
class _GoRouterObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    AppLogger.info('Navigation: Pushed ${route.settings.name}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    AppLogger.info('Navigation: Popped ${route.settings.name}');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    AppLogger.info('Navigation: Removed ${route.settings.name}');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    AppLogger.info('Navigation: Replaced ${oldRoute?.settings.name} with ${newRoute?.settings.name}');
  }
}

/// A stream-based refresh notifier for GoRouter
class GoRouterRefreshStream extends ChangeNotifier {
  // GoRouterRefreshStream(Reader read) {
  //   // Could add subscription to auth changes or other app state changes
  //   // That could trigger route refreshes when needed
  // }
}
