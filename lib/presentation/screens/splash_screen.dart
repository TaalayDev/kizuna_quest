import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kizuna_quest/core/services/settings_service.dart';
import 'package:kizuna_quest/data/repositories/game_repository.dart';
import 'package:kizuna_quest/presentation/widgets/common/animated_background.dart';
import 'package:kizuna_quest/core/utils/constants.dart';
import 'package:lottie/lottie.dart';

/// Animated splash screen for Kizuna Quest
class SplashScreen extends ConsumerStatefulWidget {
  /// Creates a SplashScreen
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isFirstLaunch = true;
  bool _animationComplete = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    // Check if this is the first app launch
    _checkFirstLaunch();

    // Start navigation timer
    _startNavigationTimer();
  }

  Future<void> _checkFirstLaunch() async {
    final isFirstLaunch = SettingsService.isFirstLaunch();
    setState(() {
      _isFirstLaunch = isFirstLaunch;
    });
  }

  void _startNavigationTimer() {
    Timer(
      const Duration(milliseconds: 3500),
      () {
        setState(() {
          _animationComplete = true;
        });

        // Navigate to home or onboarding
        if (_isFirstLaunch) {
          // Mark as launched
          SettingsService.markAppLaunched();

          // Navigate to onboarding (or replace with home if no onboarding)
          context.go(AppConstants.routeHome);
        } else {
          context.go(AppConstants.onboardingRoute);
        }
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Animated background with cityscape silhouette
          const AnimatedBackground(
            backgroundAsset: 'assets/images/backgrounds/tokyo_skyline.webp',
          ),

          // Content container
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                // Logo animation
                _buildLogoAnimation(),

                const SizedBox(height: 40),

                // Game title
                _buildGameTitle(),

                // Loading indicator
                const Spacer(),
                _buildLoadingIndicator(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoAnimation() {
    return Hero(
      tag: 'game_logo',
      child: Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: Image.asset(
            'assets/images/ui/logo.png',
            width: 150,
            height: 150,
          )
              .animate(
                onPlay: (controller) => controller.repeat(),
              )
              .shimmer(
                duration: 2.seconds,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
              )
              .scale(
                begin: const Offset(0.9, 0.9),
                end: const Offset(1.1, 1.1),
                duration: 2.seconds,
                curve: Curves.easeInOut,
              )
              .then()
              .scale(
                begin: const Offset(1.1, 1.1),
                end: const Offset(0.9, 0.9),
                duration: 2.seconds,
                curve: Curves.easeInOut,
              ),
        ),
      ),
    );
  }

  Widget _buildGameTitle() {
    return Column(
      children: [
        // Japanese title
        Text(
          '絆クエスト',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
        )
            .animate()
            .fadeIn(duration: 800.ms, delay: 300.ms)
            .slideY(begin: 0.3, end: 0, duration: 800.ms, curve: Curves.easeOutCubic),

        // English title
        Text(
          'Tokyo Ties',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        )
            .animate()
            .fadeIn(duration: 800.ms, delay: 600.ms)
            .slideY(begin: 0.3, end: 0, duration: 800.ms, curve: Curves.easeOutCubic),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return Column(
      children: [
        // Animated progress indicator
        SizedBox(
          width: 60,
          height: 60,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.secondary,
            ),
            strokeWidth: 4,
          ),
        ).animate().fadeIn(duration: 500.ms, delay: 800.ms),

        // Loading text
        const SizedBox(height: 20),
        Text(
          _animationComplete ? 'Ready to start!' : 'Loading adventure...',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
              ),
        ).animate().fadeIn(duration: 500.ms, delay: 1000.ms),

        // Language text fade in
        const SizedBox(height: 4),
        Text(
          _animationComplete ? '冒険を始めましょう！' : '冒険を読み込み中...',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
              ),
        ).animate().fadeIn(duration: 500.ms, delay: 1200.ms),
      ],
    );
  }
}
