import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kizuna_quest/core/services/settings_service.dart';
import 'package:kizuna_quest/data/models/save_game_model.dart';
import 'package:kizuna_quest/providers/database_provider.dart';
import 'package:kizuna_quest/presentation/widgets/common/animated_background.dart';
import 'package:kizuna_quest/presentation/widgets/home/character_showcase.dart';
import 'package:kizuna_quest/presentation/widgets/home/feature_button.dart';
import 'package:kizuna_quest/presentation/widgets/home/recent_save_card.dart';
import 'package:kizuna_quest/utils/constants.dart';
import 'package:kizuna_quest/utils/extensions.dart';

/// Home screen of the application
class HomeScreen extends ConsumerStatefulWidget {
  /// Creates a HomeScreen
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _showSettingsPanel = false;

  @override
  Widget build(BuildContext context) {
    final allSaveGames = ref.watch(allSaveGamesProvider);

    return Scaffold(
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
          if (_showSettingsPanel) _buildSettingsPanel(),
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
              setState(() {
                _showSettingsPanel = true;
              });
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
                title: 'Settings',
                icon: Icons.settings,
                subtitle: 'Customize Game',
                japaneseText: '設定',
                color: Colors.blueGrey,
                onTap: () => context.push(AppConstants.routeSettings),
              ).animate().fadeIn(delay: 700.ms, duration: 400.ms),
            ),
          ],
        ),
      ],
    );
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
      child: Stack(
        children: [
          // Semi-transparent backdrop
          GestureDetector(
            onTap: () {
              setState(() {
                _showSettingsPanel = false;
              });
            },
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),

          // Settings panel
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            width: context.screenWidth * 0.85, // 85% of screen width
            child: Container(
              decoration: BoxDecoration(
                color: context.theme.colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(-2, 0),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    child: Row(
                      children: [
                        Text(
                          'Settings',
                          style: context.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _showSettingsPanel = false;
                            });
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),

                  const Divider(),

                  // Settings items (simplified for this example)
                  Expanded(
                    child: ListView(
                      children: [
                        _buildSettingsItem(
                          icon: Icons.dark_mode,
                          title: 'Theme',
                          subtitle: 'Dark / Light / System',
                          onTap: () => context.push(AppConstants.routeSettings),
                        ),
                        _buildSettingsItem(
                          icon: Icons.volume_up,
                          title: 'Audio',
                          subtitle: 'Music and sound effects',
                          onTap: () => context.push(AppConstants.routeSettings),
                        ),
                        _buildSettingsItem(
                          icon: Icons.speed,
                          title: 'Text Speed',
                          subtitle: 'Adjust dialogue display speed',
                          onTap: () => context.push(AppConstants.routeSettings),
                        ),
                        _buildSettingsItem(
                          icon: Icons.language,
                          title: 'Language',
                          subtitle: 'Interface language',
                          onTap: () => context.push(AppConstants.routeSettings),
                        ),
                        _buildSettingsItem(
                          icon: Icons.info,
                          title: 'About',
                          subtitle: 'App version and credits',
                          onTap: () => _showAboutDialog(),
                        ),
                        _buildSettingsItem(
                          icon: Icons.replay,
                          title: 'Replay Tutorial',
                          subtitle: 'See the onboarding again',
                          onTap: () => _replayTutorial(),
                        ),
                      ],
                    ),
                  ),

                  // Version number
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Version 1.0.0',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ).animate().slideX(
                begin: 1,
                end: 0,
                duration: 300.ms,
                curve: Curves.easeOutQuad,
              ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: context.theme.colorScheme.primary,
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showSavesDialog() {
    // Navigate to a save game management screen or show a dialog
    context.push(AppConstants.routeSettings);
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
