import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kizuna_quest/core/services/settings_service.dart';
import 'package:kizuna_quest/data/models/save_game_model.dart';
import 'package:kizuna_quest/presentation/widgets/home/settings_panel.dart';
import 'package:kizuna_quest/providers/database_provider.dart';
import 'package:kizuna_quest/presentation/widgets/common/animated_background.dart';
import 'package:kizuna_quest/presentation/widgets/home/character_showcase.dart';
import 'package:kizuna_quest/presentation/widgets/home/feature_button.dart';
import 'package:kizuna_quest/presentation/widgets/home/recent_save_card.dart';
import 'package:kizuna_quest/core/utils/constants.dart';
import 'package:kizuna_quest/core/utils/extensions.dart';

import '../../core/services/in_app_review_service.dart';
import '../../providers/app_providers.dart';
import '../widgets/home/error_report_dialog.dart';
import '../widgets/home/save_games_dialog.dart';

/// Home screen of the application
class HomeScreen extends ConsumerStatefulWidget {
  /// Creates a HomeScreen
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _showingSavesDialog = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // Check if the app should request a review
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
      body: Stack(
        children: [
          // Animated background
          const AnimatedBackground(
            backgroundAsset: 'assets/images/backgrounds/tokyo_night.webp',
            showParticles: true,
          ),

          // Main content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // App bar area
                _buildAppBar(context),

                // Main content area
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),

                        // Continue playing section
                        _buildContinueSection(allSaveGames),

                        const SizedBox(height: 32),

                        // Character showcase
                        const CharacterShowcase(),

                        const SizedBox(height: 32),

                        // Game features section
                        _buildFeaturesSection(),

                        // Bottom padding
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // New game floating button
          Positioned(
            right: 20,
            bottom: 20,
            child: _buildNewGameButton(),
          ),

          // Settings panel (slides in from the right)
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          // Logo
          Hero(
            tag: 'game_logo',
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: context.theme.colorScheme.primary.withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/ui/logo.png',
                  width: 32,
                  height: 32,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Title
          Text(
            '絆クエスト',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.theme.colorScheme.primary,
            ),
          ),

          const Spacer(),

          // Settings button
          IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
            icon: Icon(
              Icons.settings,
              color: context.theme.colorScheme.onBackground,
            ),
          ),
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
        ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
        const SizedBox(height: 8),
        saveGames.when(
          data: (saves) {
            if (saves.isEmpty) {
              return _buildNoSavesMessage();
            }

            // Sort by last saved (most recent first)
            final sortedSaves = [...saves]..sort((a, b) => b.lastSavedAt.compareTo(a.lastSavedAt));

            // Take up to 3 most recent saves
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
                          delay: (100 + i * 100).ms,
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
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
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
        ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: FeatureButton(
                title: 'Kotoba Log',
                icon: Icons.book,
                subtitle: 'My Vocabulary',
                japaneseText: '言葉帳',
                color: context.theme.colorScheme.secondary,
                onTap: () => context.push(AppConstants.routeKotobaLog),
              ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: FeatureButton(
                title: 'Culture Notes',
                icon: Icons.lightbulb,
                subtitle: 'Japanese Culture',
                japaneseText: '文化ノート',
                color: context.theme.colorScheme.tertiary,
                onTap: () => context.push(AppConstants.routeCultureNotes),
              ).animate().fadeIn(delay: 500.ms, duration: 400.ms),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: FeatureButton(
                title: 'Save Games',
                icon: Icons.save,
                subtitle: 'Manage Saves',
                japaneseText: 'セーブ',
                color: context.theme.colorScheme.primaryContainer,
                onTap: () => _showSavesDialog(),
              ).animate().fadeIn(delay: 600.ms, duration: 400.ms),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: FeatureButton(
                title: 'Rate App',
                icon: Icons.star,
                subtitle: 'Support Us!',
                japaneseText: '評価',
                color: Colors.amber,
                onTap: () => _showRateAppDialog(),
              ).animate().fadeIn(delay: 700.ms, duration: 400.ms),
            ),
          ],
        ),
        const SizedBox(height: 16),
        FeatureButton(
          title: 'Report Translation Error',
          icon: Icons.feedback,
          subtitle: 'Help us improve the game',
          japaneseText: '翻訳ミス報告',
          color: Colors.teal,
          onTap: () => _showReportErrorDialog(),
        ).animate().fadeIn(delay: 800.ms, duration: 400.ms),
      ],
    );
  }

  void _showRateAppDialog() async {
    await ref.read(inAppReviewProvider).requestReview();
  }

  Future<void> checkAndShowReviewDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final reviewService = ref.read(inAppReviewProvider);
    final shouldRequest = await reviewService.shouldRequestReview();

    if (shouldRequest && context.mounted) {
      // Delay slightly to let the current screen finish loading
      Future.delayed(const Duration(seconds: 1), () {
        if (context.mounted) {
          reviewService.requestReview();
        }
      });
    }
  }

  void _showReportErrorDialog() {
    ErrorReportDialog.show(context);
  }

  Widget _buildNewGameButton() {
    return FloatingActionButton.extended(
      onPressed: () => _startNewGame(),
      backgroundColor: context.theme.colorScheme.primary,
      elevation: 4,
      icon: const Icon(Icons.play_arrow),
      label: const Text('New Game'),
    ).animate().fadeIn(delay: 800.ms, duration: 500.ms).slideX(
          begin: 1,
          end: 0,
          delay: 800.ms,
          duration: 500.ms,
          curve: Curves.easeOutQuad,
        );
  }

  Widget _buildSettingsPanel() {
    return Positioned.fill(
      child: SafeArea(
        child: SettingsPanel(
          onShowAbout: _showAboutDialog,
          onReplayTutorial: _replayTutorial,
          onClose: () {
            _scaffoldKey.currentState?.closeEndDrawer();
          },
        ),
      ),
    );
  }

  void _showSavesDialog() {
    if (_showingSavesDialog) return;

    setState(() {
      _showingSavesDialog = true;
    });

    OverlayState overlayState = Overlay.of(context);
    OverlayEntry? overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Material(
        color: Colors.transparent,
        child: SaveGamesDialog(
          onDismiss: () {
            // Remove the overlay when dismissed
            overlayEntry?.remove();

            setState(() {
              _showingSavesDialog = false;
            });
          },
        ),
      ),
    );

    overlayState.insert(overlayEntry);
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Kizuna Quest'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Version 1.0.0'),
              SizedBox(height: 16),
              Text('Learn Japanese through an immersive visual novel experience.'),
              SizedBox(height: 16),
              Text('© 2025 Kizuna Quest Team'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _replayTutorial() {
    // Reset onboarding flag and navigate to onboarding
    SettingsService.setOnboardingCompleted(false);
    context.go('/onboarding');
  }

  void _startNewGame() {
    // Navigate to game screen with no save ID (new game)
    context.push('${AppConstants.routeGame}?chapter=chapter_1');
  }

  void _continueSavedGame(SaveGameModel saveGame) {
    // Set active save in provider
    ref.read(activeSaveIdProvider.notifier).state = saveGame.id;

    // Navigate to game screen with chapter and save ID
    context.push('${AppConstants.routeGame}?chapter=${saveGame.currentChapter}&saveId=${saveGame.id}');
  }
}
