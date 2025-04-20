import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kizuna_quest/data/models/vocabulary_model.dart';
import 'package:kizuna_quest/providers/database_provider.dart';
import 'package:kizuna_quest/presentation/widgets/common/animated_background.dart';
import 'package:kizuna_quest/presentation/widgets/kotoba/mastery_level_badge.dart';
import 'package:kizuna_quest/presentation/widgets/kotoba/vocabulary_detail_dialog.dart';
import 'package:kizuna_quest/presentation/widgets/kotoba/vocabulary_filter_chip.dart';
import 'package:kizuna_quest/core/utils/extensions.dart';

/// Provider for the current filter in the Kotoba Log
final kotobaFilterProvider = StateProvider.autoDispose<KotobaFilter>((ref) => KotobaFilter.all);

/// Provider for the current search query in the Kotoba Log
final kotobaSearchQueryProvider = StateProvider.autoDispose<String>((ref) => '');

/// Enum for filtering vocabulary items
enum KotobaFilter {
  all('All', 0),
  new_('New', 1),
  learning('Learning', 1),
  learned('Learned', 2),
  mastered('Mastered', 3);

  final String label;
  final int masteryLevel;

  const KotobaFilter(this.label, this.masteryLevel);
}

/// Provider for filtered vocabulary items
final filteredVocabularyProvider = Provider.autoDispose<List<VocabularyModel>>((ref) {
  final vocabularyAsync = ref.watch(vocabularyWithStatusProvider);

  final filter = ref.watch(kotobaFilterProvider);
  final searchQuery = ref.watch(kotobaSearchQueryProvider).toLowerCase();

  return vocabularyAsync.maybeWhen(
    data: (vocabulary) {
      List<VocabularyModel> filteredList = [];

      if (filter == KotobaFilter.all) {
        // For "All", show only unlocked items
        filteredList = vocabulary.where((vocab) => vocab.isUnlocked).toList();
      } else if (filter == KotobaFilter.new_) {
        // For "New", show recently unlocked items with low mastery
        filteredList = vocabulary
            .where((vocab) =>
                vocab.isUnlocked &&
                vocab.masteryLevel == 1 &&
                (vocab.lastReviewed == null || DateTime.now().difference(vocab.lastReviewed!).inDays < 3))
            .toList();
      } else {
        // For other filters, filter by mastery level
        filteredList =
            vocabulary.where((vocab) => vocab.isUnlocked && vocab.masteryLevel == filter.masteryLevel).toList();
      }

      // Apply search filter if there's a query
      if (searchQuery.isNotEmpty) {
        filteredList = filteredList
            .where((vocab) =>
                vocab.wordJp.toLowerCase().contains(searchQuery) ||
                vocab.reading.toLowerCase().contains(searchQuery) ||
                vocab.meaningEn.toLowerCase().contains(searchQuery))
            .toList();
      }

      // Sort by recently unlocked first, then by mastery level (lowest to highest)
      filteredList.sort((a, b) {
        if (a.masteryLevel != b.masteryLevel) {
          return a.masteryLevel.compareTo(b.masteryLevel);
        }

        // If mastery levels are the same, sort by unlock date (newest first)
        if (a.unlockedAt != null && b.unlockedAt != null) {
          return b.unlockedAt!.compareTo(a.unlockedAt!);
        } else if (a.unlockedAt != null) {
          return -1;
        } else if (b.unlockedAt != null) {
          return 1;
        }

        // If no unlock dates, sort alphabetically
        return a.wordJp.compareTo(b.wordJp);
      });

      return filteredList;
    },
    orElse: () => [],
  );
});

/// Statistics for the Kotoba Log
final kotobaStatsProvider = Provider.autoDispose<Map<String, int>>((ref) {
  final vocabularyAsync = ref.watch(vocabularyWithStatusProvider);

  return vocabularyAsync.maybeWhen(
    data: (vocabulary) {
      final unlockedCount = vocabulary.where((v) => v.isUnlocked).length;
      final newCount = vocabulary
          .where((v) =>
              v.isUnlocked &&
              v.masteryLevel == 1 &&
              (v.lastReviewed == null || DateTime.now().difference(v.lastReviewed!).inDays < 3))
          .length;
      final learningCount = vocabulary.where((v) => v.isUnlocked && v.masteryLevel == 1).length;
      final learnedCount = vocabulary.where((v) => v.isUnlocked && v.masteryLevel == 2).length;
      final masteredCount = vocabulary.where((v) => v.isUnlocked && v.masteryLevel == 3).length;
      final totalCount = vocabulary.length;

      return {
        'unlocked': unlockedCount,
        'new': newCount,
        'learning': learningCount,
        'learned': learnedCount,
        'mastered': masteredCount,
        'total': totalCount,
      };
    },
    orElse: () => {
      'unlocked': 0,
      'new': 0,
      'learning': 0,
      'learned': 0,
      'mastered': 0,
      'total': 0,
    },
  );
});

/// Screen for displaying and reviewing vocabulary (Kotoba Log)
class KotobaLogScreen extends ConsumerStatefulWidget {
  /// Creates a KotobaLogScreen
  const KotobaLogScreen({super.key});

  @override
  ConsumerState<KotobaLogScreen> createState() => _KotobaLogScreenState();
}

class _KotobaLogScreenState extends ConsumerState<KotobaLogScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showSearch = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vocabulary = ref.watch(filteredVocabularyProvider);
    final stats = ref.watch(kotobaStatsProvider);
    final filter = ref.watch(kotobaFilterProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Background
          const AnimatedBackground(
            backgroundAsset: 'assets/images/backgrounds/classroom.webp',
            showParticles: false,
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // App bar
                _buildAppBar(context),

                // Search bar (animated)
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: _showSearch ? _buildSearchBar() : const SizedBox(height: 0),
                ),

                // Filter chips
                _buildFilterChips(filter, stats),

                // Progress indicator
                _buildProgressIndicator(stats),

                // Vocabulary list
                Expanded(
                  child: vocabulary.isEmpty ? _buildEmptyState() : _buildVocabularyList(vocabulary),
                ),
              ],
            ),
          ),
        ],
      ),
      // FAB for practice
      floatingActionButton: _buildPracticeButton(),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          // Back button
          IconButton(
            onPressed: () => context.pop(),
            icon: Icon(
              Icons.arrow_back,
              color: context.theme.colorScheme.onBackground,
            ),
          ),

          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kotoba Log',
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '言葉帳 • My Vocabulary',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.theme.colorScheme.onBackground.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),

          // Search toggle button
          IconButton(
            onPressed: () {
              setState(() {
                _showSearch = !_showSearch;
                if (!_showSearch) {
                  _searchController.clear();
                  ref.read(kotobaSearchQueryProvider.notifier).state = '';
                }
              });
            },
            icon: Icon(
              _showSearch ? Icons.close : Icons.search,
              color: context.theme.colorScheme.onBackground,
            ),
          ),

          // Sort button
          PopupMenuButton<String>(
            icon: Icon(
              Icons.sort,
              color: context.theme.colorScheme.onBackground,
            ),
            onSelected: (value) {
              // Implement sorting options
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'recent',
                child: Text('Recently Added'),
              ),
              const PopupMenuItem(
                value: 'alpha',
                child: Text('Alphabetical'),
              ),
              const PopupMenuItem(
                value: 'mastery',
                child: Text('Mastery Level'),
              ),
              const PopupMenuItem(
                value: 'jlpt',
                child: Text('JLPT Level'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search vocabulary...',
          filled: true,
          fillColor: context.theme.colorScheme.surface.withOpacity(0.9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              ref.read(kotobaSearchQueryProvider.notifier).state = '';
            },
          ),
          prefixIcon: const Icon(Icons.search),
        ),
        onChanged: (value) {
          ref.read(kotobaSearchQueryProvider.notifier).state = value;
        },
      ),
    ).animate().fadeIn(duration: 200.ms);
  }

  Widget _buildFilterChips(KotobaFilter currentFilter, Map<String, int> stats) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          VocabularyFilterChip(
            label: 'All',
            isSelected: currentFilter == KotobaFilter.all,
            count: stats['unlocked'] ?? 0,
            onSelected: () => ref.read(kotobaFilterProvider.notifier).state = KotobaFilter.all,
            color: Colors.blue,
          ),
          VocabularyFilterChip(
            label: 'New',
            isSelected: currentFilter == KotobaFilter.new_,
            count: stats['new'] ?? 0,
            onSelected: () => ref.read(kotobaFilterProvider.notifier).state = KotobaFilter.new_,
            color: Colors.amber,
          ),
          VocabularyFilterChip(
            label: 'Learning',
            isSelected: currentFilter == KotobaFilter.learning,
            count: stats['learning'] ?? 0,
            onSelected: () => ref.read(kotobaFilterProvider.notifier).state = KotobaFilter.learning,
            color: Colors.orange,
          ),
          VocabularyFilterChip(
            label: 'Learned',
            isSelected: currentFilter == KotobaFilter.learned,
            count: stats['learned'] ?? 0,
            onSelected: () => ref.read(kotobaFilterProvider.notifier).state = KotobaFilter.learned,
            color: Colors.teal,
          ),
          VocabularyFilterChip(
            label: 'Mastered',
            isSelected: currentFilter == KotobaFilter.mastered,
            count: stats['mastered'] ?? 0,
            onSelected: () => ref.read(kotobaFilterProvider.notifier).state = KotobaFilter.mastered,
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(Map<String, int> stats) {
    final total = stats['total'] ?? 1; // Avoid division by zero
    final unlocked = stats['unlocked'] ?? 0;
    final progress = unlocked / total;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress: $unlocked/$total words',
                style: context.textTheme.bodyMedium,
              ),
              Text(
                '${(progress * 100).toStringAsFixed(1)}%',
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress.clamp(0, 1),
              backgroundColor: context.theme.colorScheme.surfaceVariant,
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVocabularyList(List<VocabularyModel> vocabulary) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      physics: const BouncingScrollPhysics(),
      itemCount: vocabulary.length,
      itemBuilder: (context, index) {
        final vocab = vocabulary[index];
        return _VocabularyCard(
          vocabulary: vocab,
          index: index,
          onTap: () => _showVocabularyDetail(vocab),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    final filter = ref.watch(kotobaFilterProvider);
    final searchQuery = ref.watch(kotobaSearchQueryProvider);

    String message;
    IconData icon;

    if (searchQuery.isNotEmpty) {
      message = 'No vocabulary matches your search: "$searchQuery"';
      icon = Icons.search_off;
    } else {
      switch (filter) {
        case KotobaFilter.all:
          message = 'You haven\'t unlocked any vocabulary yet. Continue playing to discover new words!';
          icon = Icons.menu_book;
          break;
        case KotobaFilter.new_:
          message = 'No new vocabulary items. Keep playing to find more words!';
          icon = Icons.new_releases;
          break;
        case KotobaFilter.learning:
          message = 'No vocabulary items in the learning stage.';
          icon = Icons.school;
          break;
        case KotobaFilter.learned:
          message = 'You haven\'t learned any vocabulary items yet. Keep practicing!';
          icon = Icons.check_circle;
          break;
        case KotobaFilter.mastered:
          message = 'You haven\'t mastered any vocabulary items yet. Keep reviewing!';
          icon = Icons.stars;
          break;
      }
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 64,
              color: context.theme.colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              searchQuery.isNotEmpty ? 'No Results' : 'No ${filter.label} Vocabulary',
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.theme.colorScheme.onBackground.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPracticeButton() {
    return FloatingActionButton.extended(
      onPressed: () => _startPractice(),
      backgroundColor: context.theme.colorScheme.primary,
      icon: const Icon(Icons.play_arrow),
      label: const Text('Practice'),
    ).animate().fadeIn(duration: 300.ms, delay: 300.ms);
  }

  void _showVocabularyDetail(VocabularyModel vocabulary) {
    showDialog(
      context: context,
      builder: (context) => VocabularyDetailDialog(vocabulary: vocabulary),
    );
  }

  void _startPractice() {
    final vocabulary = ref.read(filteredVocabularyProvider);

    if (vocabulary.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No vocabulary available for practice.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Navigate to practice screen (implementation would depend on your routing)
    // context.push('${AppConstants.routeKotobaPractice}');

    // For now, just show a message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Practice feature coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

/// Card for displaying a vocabulary item
class _VocabularyCard extends StatelessWidget {
  final VocabularyModel vocabulary;
  final int index;
  final VoidCallback onTap;

  const _VocabularyCard({
    required this.vocabulary,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left - JLPT level badge and mastery level
              Column(
                children: [
                  // JLPT level
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: _getJlptColor(vocabulary.jlptLevel),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      vocabulary.jlptLevel,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Mastery level badge
                  MasteryLevelBadge(
                    masteryLevel: vocabulary.masteryLevel,
                  ),
                ],
              ),

              const SizedBox(width: 16),

              // Middle - The vocabulary content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Japanese word
                    Text(
                      vocabulary.wordJp,
                      style: context.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // Reading (if different from word)
                    if (vocabulary.reading != vocabulary.wordJp)
                      Text(
                        vocabulary.reading,
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: context.theme.colorScheme.primary,
                        ),
                      ),

                    const SizedBox(height: 4),

                    // English meaning
                    Text(
                      vocabulary.meaningEn,
                      style: context.textTheme.bodyMedium,
                    ),

                    const SizedBox(height: 4),

                    // Part of speech
                    Text(
                      vocabulary.partOfSpeech,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.theme.colorScheme.onBackground.withOpacity(0.6),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),

              // Right - Action buttons
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Audio button (if implemented)
                  // IconButton(
                  //   icon: Icon(
                  //     Icons.volume_up,
                  //     color: context.theme.colorScheme.primary,
                  //   ),
                  //   onPressed: () {
                  //     // Play pronunciation (would need audio implementation)
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       SnackBar(
                  //         content: const Text('Audio playback not implemented'),
                  //         behavior: SnackBarBehavior.floating,
                  //       ),
                  //     );
                  //   },
                  //   tooltip: 'Listen',
                  //   iconSize: 24,
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: (100 + (index * 50)).ms, duration: 300.ms);
  }

  Color _getJlptColor(String level) {
    switch (level) {
      case 'N1':
        return Colors.red.shade700;
      case 'N2':
        return Colors.orange.shade700;
      case 'N3':
        return Colors.amber.shade700;
      case 'N4':
        return Colors.green.shade700;
      case 'N5':
        return Colors.blue.shade700;
      default:
        return Colors.grey;
    }
  }
}
