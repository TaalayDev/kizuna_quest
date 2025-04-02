import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kizuna_quest/data/models/vocabulary_model.dart';
import 'package:kizuna_quest/providers/database_provider.dart';
import 'package:kizuna_quest/core/utils/extensions.dart';

/// Learning popup for new vocabulary
class VocabularyPopup extends ConsumerWidget {
  /// IDs of vocabulary to display
  final List<String> vocabularyIds;

  /// Callback when the popup is closed
  final VoidCallback onClose;

  /// Creates a VocabularyPopup widget
  const VocabularyPopup({
    super.key,
    required this.vocabularyIds,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fetch vocabulary by IDs
    final vocabData = ref.watch(vocabularyWithStatusProvider);

    return Stack(
      children: [
        // Semi-transparent backdrop
        GestureDetector(
          onTap: onClose,
          child: Container(
            color: Colors.black.withOpacity(0.7),
          ),
        ),

        // Popup content
        Center(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: context.screenWidth * 0.85,
              constraints: const BoxConstraints(maxWidth: 600),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  _buildHeader(context),

                  // Vocabulary content
                  _buildContent(context, vocabData, ref),

                  // Close button
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: ElevatedButton(
                      onPressed: onClose,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        backgroundColor: context.theme.colorScheme.primary,
                        foregroundColor: context.theme.colorScheme.onPrimary,
                      ),
                      child: const Text('Continue'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: context.theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.menu_book,
                color: context.theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'New Vocabulary',
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              onPressed: onClose,
              icon: const Icon(Icons.close),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildContent(BuildContext context, AsyncValue<List<VocabularyModel>> vocabData, WidgetRef ref) {
    return vocabData.when(
      data: (allVocab) {
        // Filter to get only the requested vocabulary items
        final List<VocabularyModel> vocabItems = [];
        for (final id in vocabularyIds) {
          // Parse ID to int
          final vocabId = int.tryParse(id);
          if (vocabId != null) {
            // Find matching vocabulary
            final vocab = allVocab.where((v) => v.id == vocabId).toList();
            if (vocab.isNotEmpty) {
              vocabItems.add(vocab.first);
            }
          }
        }

        if (vocabItems.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text('No vocabulary information available'),
          );
        }

        // Auto-unlock vocabulary for the player
        for (final vocab in vocabItems) {
          _unlockVocabulary(vocab.id, ref);
        }

        return SizedBox(
          height: vocabItems.length == 1 ? 200 : 300,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: vocabItems.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              return _buildVocabularyCard(context, vocabItems[index], index);
            },
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Error loading vocabulary: $error',
          style: context.textTheme.bodyLarge?.copyWith(
            color: context.theme.colorScheme.error,
          ),
        ),
      ),
    );
  }

  Future<void> _unlockVocabulary(int vocabId, WidgetRef ref) async {
    final gameRepository = ref.read(gameRepositoryProvider);
    final activeSaveId = ref.read(activeSaveIdProvider);

    if (activeSaveId != null) {
      await gameRepository.unlockVocabulary(activeSaveId, vocabId);
    }
  }

  Widget _buildVocabularyCard(BuildContext context, VocabularyModel vocab, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // JLPT level & part of speech
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getJlptColor(vocab.jlptLevel),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  vocab.jlptLevel,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                vocab.partOfSpeech,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.theme.colorScheme.onSurface.withOpacity(0.7),
                  fontStyle: FontStyle.italic,
                ),
              ),

              const Spacer(),

              // New badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.amber.shade600,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'NEW',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
                  .fadeIn(
                    begin: 0.7,
                    duration: 1.seconds,
                  ),
            ],
          ),

          const SizedBox(height: 8),

          // Word & reading
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                vocab.wordJp,
                style: context.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 8),
              if (vocab.reading != vocab.wordJp)
                Text(
                  '(${vocab.reading})',
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.theme.colorScheme.secondary,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 4),

          // Meaning
          Text(
            vocab.meaningEn,
            style: context.textTheme.titleMedium,
          ),

          const SizedBox(height: 8),

          // Example
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: context.theme.colorScheme.outline.withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vocab.exampleJp,
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: context.theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  vocab.exampleEn,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.theme.colorScheme.onSurface.withOpacity(0.7),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: 100 * index),
          duration: 400.ms,
        )
        .slideX(
          begin: 0.1,
          end: 0,
          delay: Duration(milliseconds: 100 * index),
          duration: 400.ms,
          curve: Curves.easeOutQuad,
        );
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
