import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:tsuzuki_connect/core/services/settings_service.dart';
import 'package:tsuzuki_connect/data/models/save_game_model.dart';
import 'package:tsuzuki_connect/presentation/widgets/home/settings_panel.dart';
import 'package:tsuzuki_connect/providers/database_provider.dart';
import 'package:tsuzuki_connect/presentation/widgets/common/animated_background.dart';
import 'package:tsuzuki_connect/presentation/widgets/home/feature_button.dart';
import 'package:tsuzuki_connect/presentation/widgets/home/recent_save_card.dart';
import 'package:tsuzuki_connect/core/utils/constants.dart';
import 'package:tsuzuki_connect/core/utils/extensions.dart';
import 'package:tsuzuki_connect/providers/sound_controller.dart';

import '../../providers/app_providers.dart';
import '../widgets/common/about_dialog.dart';
import '../widgets/home/error_report_dialog.dart';
import '../widgets/home/save_games_dialog.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _showingSavesDialog = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAndShowReviewDialog(context, ref);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final allSaveGames = ref.watch(allSaveGamesProvider);

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: _buildSettingsPanel(),
      // appBar: _buildAppBar(context),
      body: Stack(
        children: [
          // Animated background
          const AnimatedBackground(
            backgroundAsset: 'assets/images/backgrounds/menu_background.webp',
            showParticles: true,
            isDarkMode: false,
          ),

          Positioned(child: _buildAppBar(context)),

          // Main content
          SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLogoSection(),
                      // const SizedBox(height: 14),
                      _buildActionButtons(),
                      const SizedBox(height: 132),
                      // _buildContinueSection(allSaveGames),
                      // const SizedBox(height: 32),
                      // _buildFeaturesSection(),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // const CharacterShowcase(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () {
            ref.read(soundControllerProvider.notifier).playClick();
            _scaffoldKey.currentState?.openEndDrawer();
          },
          icon: Icon(
            Icons.settings,
            color: context.theme.colorScheme.onBackground,
          ),
        ),
      ],
    );
  }

  Widget _buildLogoSection() {
    return Center(
      child: Hero(
        tag: 'game_logo',
        child: SizedBox(
          width: 280,
          height: 280,
          child: Center(
            child: Image.asset(
              'assets/images/ui/logo.png',
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 600.ms).scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1.0, 1.0),
          delay: 100.ms,
          duration: 600.ms,
          curve: Curves.easeOutQuad,
        );
  }

  Widget _buildActionButtons() {
    final allSaveGames = ref.watch(allSaveGamesProvider);

    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          _MenuButton(
            icon: Feather.play,
            title: 'New Game',
            onPressed: _startNewGame,
          ).animate().fadeIn(delay: 100.ms, duration: 400.ms).slideY(
                begin: 0.3,
                end: 0,
                delay: 100.ms,
                duration: 400.ms,
                curve: Curves.easeOutQuad,
              ),
          const SizedBox(height: 12),
          _MenuButton(
            title: 'Continue',
            icon: Feather.save,
            onPressed: allSaveGames.when(
              data: (saves) {
                if (saves.isEmpty) {
                  return null;
                } else {
                  return _showSavesDialog;
                }
              },
              loading: () => null,
              error: (error, stack) => null,
            ),
          ).animate().fadeIn(delay: 100.ms, duration: 400.ms).slideY(
                begin: 0.3,
                end: 0,
                delay: 100.ms,
                duration: 400.ms,
                curve: Curves.easeOutQuad,
              ),

          const SizedBox(height: 12),
          _MenuButton(
            title: 'Kotoba Log',
            icon: Feather.book,
            onPressed: () {
              ref.read(soundControllerProvider.notifier).playClick();
              context.push(AppConstants.routeKotobaLog);
            },
          ).animate().fadeIn(delay: 100.ms, duration: 400.ms).slideY(
                begin: 0.3,
                end: 0,
                delay: 100.ms,
                duration: 400.ms,
                curve: Curves.easeOutQuad,
              ),
          const SizedBox(height: 12),
          _MenuButton(
            title: 'Culture Notes',
            icon: Feather.info,
            onPressed: () {
              ref.read(soundControllerProvider.notifier).playClick();
              context.push(AppConstants.routeCultureNotes);
            },
          ).animate().fadeIn(delay: 100.ms, duration: 400.ms).slideY(
                begin: 0.3,
                end: 0,
                delay: 100.ms,
                duration: 400.ms,
                curve: Curves.easeOutQuad,
              ),

          // Row(
          //   children: [
          //     Expanded(
          //       child: OutlinedButton.icon(
          //         onPressed: () => _showSavesDialog(),
          //         style: OutlinedButton.styleFrom(
          //           padding: const EdgeInsets.symmetric(vertical: 12.0),
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(12.0),
          //           ),
          //         ),
          //         icon: const Icon(Icons.save, size: 20),
          //         label: const Text('Saves'),
          //       ),
          //     ),
          //     const SizedBox(width: 12),
          //     Expanded(
          //       child: OutlinedButton.icon(
          //         onPressed: () => _showRateAppDialog(),
          //         style: OutlinedButton.styleFrom(
          //           padding: const EdgeInsets.symmetric(vertical: 12.0),
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(12.0),
          //           ),
          //         ),
          //         icon: const Icon(Icons.star, size: 20),
          //         label: const Text('Rate'),
          //       ),
          //     ),
          //   ],
          // ).animate().fadeIn(delay: 300.ms, duration: 400.ms).slideY(
          //       begin: 0.3,
          //       end: 0,
          //       delay: 300.ms,
          //       duration: 400.ms,
          //       curve: Curves.easeOutQuad,
          //     ),
        ],
      ),
    );
  }

  Widget _buildContinueSection(AsyncValue<List<SaveGameModel>> saveGames) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Continue Playing',
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
        const SizedBox(height: 12),
        saveGames.when(
          data: (saves) {
            if (saves.isEmpty) {
              return _buildNoSavesMessage();
            }

            final sortedSaves = [...saves]..sort((a, b) => b.lastSavedAt.compareTo(a.lastSavedAt));
            final recentSaves = sortedSaves.take(3).toList();

            return Column(
              children: [
                for (int i = 0; i < recentSaves.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: RecentSaveCard(
                      saveGame: recentSaves[i],
                      onTap: () => _continueSavedGame(recentSaves[i]),
                    ).animate().fadeIn(
                          delay: (500 + i * 100).ms,
                          duration: 400.ms,
                        ),
                  ),
              ],
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, stack) => Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Error loading saved games',
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.theme.colorScheme.error,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoSavesMessage() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.bookmark_border,
            size: 48,
            color: context.theme.colorScheme.primary,
          ),
          const SizedBox(height: 12),
          Text(
            'No saved games yet',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start a new adventure to begin your language learning journey!',
            style: context.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms, duration: 400.ms);
  }

  Widget _buildFeaturesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Features',
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ).animate().fadeIn(delay: 700.ms, duration: 400.ms),
        const SizedBox(height: 16),
        FeatureButton(
          title: 'Kotoba Log',
          icon: Icons.book,
          subtitle: 'My Vocabulary',
          japaneseText: '言葉帳',
          color: context.theme.colorScheme.secondary,
          onTap: () {
            ref.read(soundControllerProvider.notifier).playClick();
            context.push(AppConstants.routeKotobaLog);
          },
        ).animate().fadeIn(delay: 800.ms, duration: 400.ms),
        const SizedBox(height: 12),
        FeatureButton(
          title: 'Culture Notes',
          icon: Icons.lightbulb,
          subtitle: 'Japanese Culture',
          japaneseText: '文化ノート',
          color: context.theme.colorScheme.tertiary,
          onTap: () {
            ref.read(soundControllerProvider.notifier).playClick();
            context.push(AppConstants.routeCultureNotes);
          },
        ).animate().fadeIn(delay: 900.ms, duration: 400.ms),
        const SizedBox(height: 12),
        FeatureButton(
          title: 'Report Translation Error',
          icon: Icons.feedback,
          subtitle: 'Help us improve the game',
          japaneseText: '翻訳ミス報告',
          color: Colors.teal,
          onTap: () => _showReportErrorDialog(),
        ).animate().fadeIn(delay: 1000.ms, duration: 400.ms),
      ],
    );
  }

  void _showRateAppDialog() async {
    ref.read(soundControllerProvider.notifier).playClick();
    await ref.read(inAppReviewProvider).requestReview();
  }

  Future<void> checkAndShowReviewDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final reviewService = ref.read(inAppReviewProvider);
    final shouldRequest = await reviewService.shouldRequestReview();

    if (shouldRequest && context.mounted) {
      Future.delayed(const Duration(seconds: 1), () {
        if (context.mounted) {
          reviewService.requestReview();
        }
      });
    }
  }

  void _showReportErrorDialog() {
    ref.read(soundControllerProvider.notifier).playClick();
    ErrorReportDialog.show(context);
  }

  Widget _buildSettingsPanel() {
    return SafeArea(
      child: SettingsPanel(
        onShowAbout: _showAboutDialog,
        onReplayTutorial: _replayTutorial,
        onClose: () {
          _scaffoldKey.currentState?.closeEndDrawer();
        },
      ),
    );
  }

  void _showSavesDialog() {
    ref.read(soundControllerProvider.notifier).playClick();
    if (_showingSavesDialog) return;

    setState(() {
      _showingSavesDialog = true;
    });

    showDialog(
      context: context,
      builder: (context) => Material(
        color: Colors.transparent,
        child: SaveGamesDialog(
          onDismiss: () {
            Navigator.of(context).pop(); // Close the dialog
            setState(() {
              _showingSavesDialog = false;
            });
          },
        ),
      ),
    );
  }

  void _showAboutDialog() {
    ref.read(soundControllerProvider.notifier).playClick();

    AboutAppDialog.show(context);
  }

  void _replayTutorial() {
    ref.read(soundControllerProvider.notifier).playClick();
    SettingsService.setOnboardingCompleted(false);
    context.go('/onboarding');
  }

  void _startNewGame() {
    ref.read(soundControllerProvider.notifier).playClick();
    context.push('${AppConstants.routeGame}?chapter=chapter_1');
  }

  void _continueSavedGame(SaveGameModel saveGame) {
    ref.read(soundControllerProvider.notifier).playClick();
    ref.read(activeSaveIdProvider.notifier).state = saveGame.id;

    context.push('${AppConstants.routeGame}?chapter=${saveGame.currentChapter}&saveId=${saveGame.id}');
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  final String title;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 70,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: context.theme.colorScheme.primary,
          foregroundColor: context.theme.colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          elevation: 4,
          side: BorderSide(
            color: context.theme.colorScheme.inversePrimary,
            width: 2,
          ),
          iconColor: context.theme.colorScheme.onSurface,
        ),
        icon: Icon(icon, size: 24),
        label: Text(
          title,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(
          begin: 0.3,
          end: 0,
          delay: 200.ms,
          duration: 400.ms,
          curve: Curves.easeOutQuad,
        );
  }
}
