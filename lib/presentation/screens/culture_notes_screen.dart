import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tsuzuki_connect/data/models/cultural_note_model.dart';
import 'package:tsuzuki_connect/providers/database_provider.dart';
import 'package:tsuzuki_connect/presentation/widgets/common/animated_background.dart';
import 'package:tsuzuki_connect/presentation/widgets/culture/category_selector.dart';
import 'package:tsuzuki_connect/presentation/widgets/culture/culture_note_card.dart';
import 'package:tsuzuki_connect/core/utils/extensions.dart';

import '../../providers/sound_controller.dart';

/// Provider for the current selected category in Culture Notes
final selectedCategoryProvider = StateProvider.autoDispose<String?>((ref) => null);

/// Provider for the current search query in Culture Notes
final cultureSearchQueryProvider = StateProvider.autoDispose<String>((ref) => '');

/// Provider for filtered cultural notes
final filteredCulturalNotesProvider = Provider.autoDispose<List<CulturalNoteModel>>((ref) {
  final notesAsync = ref.watch(culturalNotesWithStatusProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final searchQuery = ref.watch(cultureSearchQueryProvider).toLowerCase();

  return notesAsync.maybeWhen(
    data: (notes) {
      List<CulturalNoteModel> filteredList = [];

      // First filter by unlock status (always show unlocked first)
      filteredList = notes.where((note) => note.isUnlocked).toList();

      // Then apply category filter if selected
      if (selectedCategory != null && selectedCategory != 'All') {
        filteredList = filteredList.where((note) => note.category == selectedCategory).toList();
      }

      // Apply search filter if there's a query
      if (searchQuery.isNotEmpty) {
        filteredList = filteredList
            .where((note) =>
                note.title.toLowerCase().contains(searchQuery) ||
                note.content.toLowerCase().contains(searchQuery) ||
                note.category.toLowerCase().contains(searchQuery))
            .toList();
      }

      // Sort: Read vs Unread (Unread first), then by most recently unlocked
      filteredList.sort((a, b) {
        // First sort by read status
        if (a.isRead != b.isRead) {
          return a.isRead ? 1 : -1; // Unread first
        }

        // Then sort by unlock date if available
        if (a.unlockedAt != null && b.unlockedAt != null) {
          return b.unlockedAt!.compareTo(a.unlockedAt!); // Newest first
        } else if (a.unlockedAt != null) {
          return -1;
        } else if (b.unlockedAt != null) {
          return 1;
        }

        // Finally sort by title
        return a.title.compareTo(b.title);
      });

      return filteredList;
    },
    orElse: () => [],
  );
});

/// Provider for categories available in unlocked cultural notes
final cultureNoteCategoriesProvider = Provider.autoDispose<List<String>>((ref) {
  final notesAsync = ref.watch(culturalNotesWithStatusProvider);

  return notesAsync.maybeWhen(
    data: (notes) {
      // Get unique categories from unlocked notes
      final unlockedNotes = notes.where((note) => note.isUnlocked).toList();
      final categories = unlockedNotes.map((note) => note.category).toSet().toList();

      // Sort categories alphabetically
      categories.sort();

      // Add 'All' as the first option
      return ['All', ...categories];
    },
    orElse: () => ['All'],
  );
});

/// Statistics for Culture Notes
final cultureStatsProvider = Provider.autoDispose<Map<String, int>>((ref) {
  final notesAsync = ref.watch(culturalNotesWithStatusProvider);

  return notesAsync.maybeWhen(
    data: (notes) {
      final unlockedCount = notes.where((note) => note.isUnlocked).length;
      final readCount = notes.where((note) => note.isUnlocked && note.isRead).length;
      final totalCount = notes.length;

      return {
        'unlocked': unlockedCount,
        'read': readCount,
        'total': totalCount,
      };
    },
    orElse: () => {
      'unlocked': 0,
      'read': 0,
      'total': 0,
    },
  );
});

/// Screen for displaying Japanese cultural notes
class CultureNotesScreen extends ConsumerStatefulWidget {
  /// Creates a CultureNotesScreen
  const CultureNotesScreen({super.key});

  @override
  ConsumerState<CultureNotesScreen> createState() => _CultureNotesScreenState();
}

class _CultureNotesScreenState extends ConsumerState<CultureNotesScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showSearch = false;
  bool _showFilterInfo = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final culturalNotes = ref.watch(filteredCulturalNotesProvider);
    final categories = ref.watch(cultureNoteCategoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final stats = ref.watch(cultureStatsProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Background
          const AnimatedBackground(
            backgroundAsset: 'assets/images/backgrounds/temple.webp',
            showParticles: true,
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

                // Category selector
                CategorySelector(
                  categories: categories,
                  selectedCategory: selectedCategory,
                  onCategorySelected: (category) {
                    ref.read(selectedCategoryProvider.notifier).state = category == 'All' ? null : category;
                  },
                ),

                // Filter info bar (shows when filters are active)
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: _showFilterInfo ? _buildFilterInfoBar() : const SizedBox(height: 0),
                ),

                // Progress indicator
                _buildProgressIndicator(stats),

                // Culture notes list
                Expanded(
                  child: culturalNotes.isEmpty ? _buildEmptyState() : _buildNotesList(culturalNotes),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          // Back button
          IconButton(
            onPressed: () {
              ref.read(soundControllerProvider.notifier).playClick();
              context.pop();
            },
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
                  'Culture Notes',
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '文化ノート • Japanese Culture',
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
              ref.read(soundControllerProvider.notifier).playClick();
              setState(() {
                _showSearch = !_showSearch;
                if (!_showSearch) {
                  _searchController.clear();
                  ref.read(cultureSearchQueryProvider.notifier).state = '';
                  _updateFilterInfoVisibility();
                }
              });
            },
            icon: Icon(
              _showSearch ? Icons.close : Icons.search,
              color: context.theme.colorScheme.onBackground,
            ),
          ),

          // Filter info button
          IconButton(
            onPressed: () {
              ref.read(soundControllerProvider.notifier).playClick();
              _showFilterInfoDialog();
            },
            icon: Icon(
              Icons.info_outline,
              color: context.theme.colorScheme.onBackground,
            ),
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
          hintText: 'Search culture notes...',
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
              ref.read(cultureSearchQueryProvider.notifier).state = '';
              _updateFilterInfoVisibility();
            },
          ),
          prefixIcon: const Icon(Icons.search),
        ),
        onChanged: (value) {
          ref.read(cultureSearchQueryProvider.notifier).state = value;
          _updateFilterInfoVisibility();
        },
      ),
    ).animate().fadeIn(duration: 200.ms);
  }

  Widget _buildFilterInfoBar() {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final searchQuery = ref.watch(cultureSearchQueryProvider);

    String filterText = 'Filters: ';
    if (selectedCategory != null) {
      filterText += 'Category: $selectedCategory';
    }

    if (searchQuery.isNotEmpty) {
      if (selectedCategory != null) {
        filterText += ', ';
      }
      filterText += 'Search: "$searchQuery"';
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      color: context.theme.colorScheme.primaryContainer.withOpacity(0.3),
      child: Row(
        children: [
          Icon(
            Icons.filter_list,
            size: 16,
            color: context.theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              filterText,
              style: context.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.theme.colorScheme.primary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton(
            onPressed: () {
              // Clear all filters
              ref.read(selectedCategoryProvider.notifier).state = null;
              ref.read(cultureSearchQueryProvider.notifier).state = '';
              _searchController.clear();
              _updateFilterInfoVisibility();
            },
            child: const Text('Clear All'),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: const Size(50, 32),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 200.ms);
  }

  Widget _buildProgressIndicator(Map<String, int> stats) {
    final total = stats['total'] ?? 1; // Avoid division by zero
    final unlocked = stats['unlocked'] ?? 0;
    final read = stats['read'] ?? 0;
    final progress = (unlocked / total).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Discovered: $unlocked/$total notes',
                style: context.textTheme.bodyMedium,
              ),
              Row(
                children: [
                  Icon(
                    Icons.visibility,
                    size: 16,
                    color: context.theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Read: $read',
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: context.theme.colorScheme.surfaceVariant,
              minHeight: 8,
              color: context.theme.colorScheme.tertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesList(List<CulturalNoteModel> notes) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      physics: const BouncingScrollPhysics(),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return CultureNoteCard(
          note: note,
          index: index,
          onTap: () => _showNoteDetailScreen(note),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final searchQuery = ref.watch(cultureSearchQueryProvider);

    String message;
    IconData icon;

    if (searchQuery.isNotEmpty || selectedCategory != null) {
      message =
          'No cultural notes match your current filters. Try adjusting your search criteria or category selection.';
      icon = Icons.filter_list_off;
    } else {
      message =
          'You haven\'t discovered any cultural notes yet. Continue playing to learn more about Japanese culture!';
      icon = Icons.explore;
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
              color: context.theme.colorScheme.tertiary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              searchQuery.isNotEmpty || selectedCategory != null ? 'No Results' : 'No Cultural Notes Yet',
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

  void _updateFilterInfoVisibility() {
    final selectedCategory = ref.read(selectedCategoryProvider);
    final searchQuery = ref.read(cultureSearchQueryProvider);

    setState(() {
      _showFilterInfo = selectedCategory != null || searchQuery.isNotEmpty;
    });
  }

  void _showFilterInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Culture Notes'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Learn about Japanese culture as you play!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Cultural notes provide insights into Japanese traditions, etiquette, and customs that you encounter during your adventures.',
              ),
              SizedBox(height: 16),
              Text(
                'Note Status:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text('• New: Recently discovered notes that you haven\'t read yet'),
              Text('• Read: Notes you\'ve already viewed'),
              SizedBox(height: 16),
              Text(
                'Filter by category to find specific types of cultural information.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
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

  void _showNoteDetailScreen(CulturalNoteModel note) {
    // If not already read, mark as read
    // if (!note.isRead) {
    //   final activeSaveId = ref.read(activeSaveIdProvider);
    //   if (activeSaveId != null) {
    //     final gameRepository = ref.read(gameRepositoryProvider);
    //     gameRepository.markCulturalNoteAsRead(activeSaveId, note.id);
    //   }
    // }

    // // Navigate to detail screen
    // context.push('/culture/${note.id}', extra: note);
  }
}
