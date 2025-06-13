import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tsuzuki_connect/core/services/settings_service.dart';
import 'package:tsuzuki_connect/presentation/widgets/common/animated_background.dart';
import 'package:tsuzuki_connect/core/utils/constants.dart';
import 'package:tsuzuki_connect/core/utils/extensions.dart';
import 'package:lottie/lottie.dart';

import '../../providers/sound_controller.dart';

/// Provider to track current onboarding page
final onboardingPageProvider = StateProvider.autoDispose<int>((ref) => 0);

/// OnboardingScreen introduces key features to new users
class OnboardingScreen extends ConsumerWidget {
  /// Creates an OnboardingScreen
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(onboardingPageProvider);
    final pageController = PageController();

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          AnimatedBackground(
            backgroundAsset: 'assets/images/backgrounds/onboarding.webp',
            isDarkMode: false,
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Skip button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextButton(
                      onPressed: () {
                        ref.read(soundControllerProvider.notifier).playClick();
                        _finishOnboarding(context);
                      },
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: context.theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                // Page content
                Expanded(
                  child: PageView(
                    controller: pageController,
                    onPageChanged: (index) {
                      ref.read(onboardingPageProvider.notifier).state = index;
                    },
                    children: const [
                      _OnboardingPage(
                        title: 'Welcome to Tsuzuki Connect!',
                        description: 'Learn Japanese through an immersive visual novel adventure set in Tokyo.',
                        lottieAsset: 'assets/animations/welcome_tokyo.json',
                        japaneseText: 'ようこそ、絆クエストへ！',
                      ),
                      _OnboardingPage(
                        title: 'Build Relationships',
                        description:
                            'Connect with characters and build "Tsuzuki" (bonds) as you communicate in Japanese.',
                        lottieAsset: 'assets/animations/characters.json',
                        japaneseText: '登場人物との絆を深めよう',
                      ),
                      _OnboardingPage(
                        title: 'Learn Through Choices',
                        description:
                            'Make dialogue choices to practice your Japanese comprehension and communication skills.',
                        lottieAsset: 'assets/animations/choices.json',
                        japaneseText: '選択肢を通して日本語を学ぼう',
                      ),
                      _OnboardingPage(
                        title: 'Track Your Progress',
                        description:
                            'Build your vocabulary, master grammar points, and explore Japanese culture as you play.',
                        lottieAsset: 'assets/animations/progress.json',
                        japaneseText: '進捗を追跡しよう',
                      ),
                    ],
                  ),
                ),

                // Bottom navigation
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Page indicator
                      Row(
                        children: List.generate(
                          4,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            width: index == currentPage ? 24.0 : 12.0,
                            height: 8.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: index == currentPage
                                  ? context.theme.colorScheme.primary
                                  : context.theme.colorScheme.primary.withOpacity(0.3),
                            ),
                          ).animate().scale(
                                duration: 200.ms,
                                curve: Curves.easeInOut,
                                delay: 50.ms,
                              ),
                        ),
                      ),

                      // Next/Start button
                      ElevatedButton(
                        onPressed: () {
                          ref.read(soundControllerProvider.notifier).playClick();
                          if (currentPage < 3) {
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            _finishOnboarding(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24.0,
                            vertical: 16.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          backgroundColor: context.theme.colorScheme.primary,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              currentPage < 3 ? 'Next' : 'Start Adventure',
                              style: TextStyle(
                                color: context.theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Icon(
                              currentPage < 3 ? Icons.arrow_forward : Icons.play_arrow,
                              color: context.theme.colorScheme.onPrimary,
                            ),
                          ],
                        ),
                      ).animate().fadeIn(
                            duration: 300.ms,
                            delay: 200.ms,
                          ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _finishOnboarding(BuildContext context) {
    // Mark onboarding as completed
    SettingsService.setOnboardingCompleted(true);

    // Navigate to home screen
    context.go(AppConstants.routeHome);
  }
}

/// Single onboarding page
class _OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String lottieAsset;
  final String japaneseText;

  const _OnboardingPage({
    required this.title,
    required this.description,
    required this.lottieAsset,
    required this.japaneseText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Lottie animation
          Expanded(
            flex: 5,
            child: SizedBox(),
            // child: Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 16.0),
            //   child: Lottie.asset(
            //     lottieAsset,
            //     fit: BoxFit.contain,
            //   ),
            // ),
          ),

          // Japanese text
          Text(
            japaneseText,
            style: context.textTheme.titleLarge?.copyWith(
              color: context.theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideY(
                begin: 0.2,
                end: 0,
                duration: 400.ms,
                curve: Curves.easeOut,
              ),

          const SizedBox(height: 8.0),

          // Title
          Text(
            title,
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(duration: 400.ms, delay: 300.ms).slideY(
                begin: 0.2,
                end: 0,
                duration: 400.ms,
                curve: Curves.easeOut,
              ),

          const SizedBox(height: 16.0),

          // Description
          Text(
            description,
            style: context.textTheme.bodyLarge?.copyWith(
              color: context.theme.colorScheme.onBackground.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(duration: 400.ms, delay: 400.ms).slideY(
                begin: 0.2,
                end: 0,
                duration: 400.ms,
                curve: Curves.easeOut,
              ),

          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
