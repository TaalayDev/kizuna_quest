import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kizuna_quest/data/models/vocabulary_model.dart';
import 'package:kizuna_quest/providers/database_provider.dart';
import 'package:kizuna_quest/presentation/widgets/kotoba/mastery_level_badge.dart';
import 'package:kizuna_quest/core/utils/extensions.dart';

/// A dialog for displaying detailed information about a vocabulary item
class VocabularyDetailDialog extends ConsumerWidget {
  /// The vocabulary item to display
  final VocabularyModel vocabulary;

  /// Creates a VocabularyDetailDialog
  const VocabularyDetailDialog({
    super.key,
    required this.vocabulary,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 8,
      child: Container(
        width: context.screenWidth * 0.9,
        constraints: BoxConstraints(
          maxHeight: context.screenHeight * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top section with Japanese word and furigana
            _buildTopSection(context),

            // Detail content
            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Info section
                    _buildInfoSection(context),

                    const Divider(height: 32),

                    // Example sentence
                    _buildExampleSection(context),

                    const Divider(height: 32),

                    // Additional info
                    _buildAdditionalInfo(context),

                    const SizedBox(height: 24),

                    // Buttons row
                    _buildButtonsRow(context, ref),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.primary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Japanese word
          Row(
            children: [
              Expanded(
                child: Text(
                  vocabulary.wordJp,
                  style: context.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.theme.colorScheme.onPrimary,
                  ),
                ),
              ),
              // Close button
              IconButton(
                icon: Icon(
                  Icons.close,
                  color: context.theme.colorScheme.onPrimary,
                ),
                onPressed: () => Navigator.of(context).pop(),
                tooltip: 'Close',
              ),
            ],
          ),

          // Reading
          if (vocabulary.reading != vocabulary.wordJp)
            Text(
              vocabulary.reading,
              style: context.textTheme.titleMedium?.copyWith(
                color: context.theme.colorScheme.onPrimary.withOpacity(0.9),
              ),
            ),

          const SizedBox(height: 8),

          // English meaning
          Text(
            vocabulary.meaningEn,
            style: context.textTheme.titleMedium?.copyWith(
              color: context.theme.colorScheme.onPrimary.withOpacity(0.8),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 200.ms);
  }

  Widget _buildInfoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),

        // Part of speech and JLPT level
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Part of speech
            Row(
              children: [
                Icon(
                  Icons.category,
                  size: 20,
                  color: context.theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  vocabulary.partOfSpeech,
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            // JLPT level
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: _getJlptColor(vocabulary.jlptLevel),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.school,
                    size: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    vocabulary.jlptLevel,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Mastery level and date unlocked
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Mastery level
            Row(
              children: [
                MasteryLevelBadge(
                  masteryLevel: vocabulary.masteryLevel,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  vocabulary.masteryLevelName,
                  style: context.textTheme.bodyMedium,
                ),
              ],
            ),

            // Date unlocked
            if (vocabulary.unlockedAt != null)
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: context.theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Unlocked: ${_formatDate(vocabulary.unlockedAt!)}',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.theme.colorScheme.onBackground.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 200.ms, delay: 100.ms);
  }

  Widget _buildExampleSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Example title
        Text(
          'Example',
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        // Example sentence
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.theme.colorScheme.primaryContainer.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: context.theme.colorScheme.primaryContainer,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Japanese example
              Text(
                vocabulary.exampleJp,
                style: context.textTheme.bodyLarge,
              ),

              const SizedBox(height: 8),

              // English translation
              Text(
                vocabulary.exampleEn,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.theme.colorScheme.onBackground.withOpacity(0.8),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(duration: 200.ms, delay: 200.ms);
  }

  Widget _buildAdditionalInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tags title
        Row(
          children: [
            Icon(
              Icons.tag,
              size: 20,
              color: context.theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Tags',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Tags list
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: vocabulary.tagList.map((tag) {
            return Chip(
              label: Text(tag),
              backgroundColor: context.theme.colorScheme.secondaryContainer,
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              labelStyle: context.textTheme.bodySmall,
            );
          }).toList(),
        ),

        const SizedBox(height: 16),

        // Chapter introduced
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.book,
              size: 20,
              color: context.theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Introduced in:',
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _getChapterName(vocabulary.chapterIntroduced),
                style: context.textTheme.bodyMedium,
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 200.ms, delay: 300.ms);
  }

  Widget _buildButtonsRow(BuildContext context, WidgetRef ref) {
    final activeSaveId = ref.watch(activeSaveIdProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Listen button
        // OutlinedButton.icon(
        //   onPressed: () {
        //     // Play pronunciation (would need audio implementation)
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       SnackBar(
        //         content: const Text('Audio playback not implemented'),
        //         behavior: SnackBarBehavior.floating,
        //       ),
        //     );
        //   },
        //   icon: const Icon(Icons.volume_up),
        //   label: const Text('Listen'),
        //   style: OutlinedButton.styleFrom(
        //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        //   ),
        // ),

        // Update mastery button (only if active save and unlocked)
        if (activeSaveId != null && vocabulary.isUnlocked)
          ElevatedButton.icon(
            onPressed: () {
              _updateMasteryLevel(context, ref);
            },
            icon: Icon(
              Icons.trending_up,
              color: context.theme.colorScheme.onPrimary,
            ),
            label: const Text('Update Mastery'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              backgroundColor: context.theme.colorScheme.primary,
              foregroundColor: context.theme.colorScheme.onPrimary,
            ),
          ),
      ],
    ).animate().fadeIn(duration: 200.ms, delay: 400.ms);
  }

  void _updateMasteryLevel(BuildContext context, WidgetRef ref) {
    final gameRepository = ref.read(gameRepositoryProvider);
    final activeSaveId = ref.read(activeSaveIdProvider);

    if (activeSaveId == null) return;

    // Calculate next mastery level (cycle through 1-3)
    final nextMastery = vocabulary.masteryLevel >= 3 ? 1 : vocabulary.masteryLevel + 1;

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Update mastery in database
    gameRepository
        .updateVocabularyMastery(
      activeSaveId,
      vocabulary.id,
      nextMastery,
    )
        .then((success) {
      // Pop loading dialog
      Navigator.of(context).pop();

      if (success) {
        // Pop vocabulary dialog
        Navigator.of(context).pop();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Mastery updated to ${_getMasteryName(nextMastery)}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to update mastery level'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }

  String _getChapterName(String chapterId) {
    // This would ideally come from a repository or localization
    final chapterMap = {
      'chapter_1': 'Chapter 1: Arrival in Tokyo',
      'chapter_2': 'Chapter 2: First Day at School',
      'chapter_3': 'Chapter 3: The Festival',
      // Add more chapters as needed
    };

    return chapterMap[chapterId] ?? chapterId;
  }

  String _getMasteryName(int masteryLevel) {
    switch (masteryLevel) {
      case 1:
        return 'Learning';
      case 2:
        return 'Learned';
      case 3:
        return 'Mastered';
      default:
        return 'Unknown';
    }
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
