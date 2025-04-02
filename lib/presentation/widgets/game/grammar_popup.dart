import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kizuna_quest/data/models/grammar_point_model.dart';
import 'package:kizuna_quest/providers/database_provider.dart';
import 'package:kizuna_quest/core/utils/extensions.dart';

/// Learning popup for grammar points
class GrammarPopup extends ConsumerWidget {
  /// IDs of grammar points to display
  final List<String> grammarIds;

  /// Callback when the popup is closed
  final VoidCallback onClose;

  /// Creates a GrammarPopup widget
  const GrammarPopup({
    super.key,
    required this.grammarIds,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fetch grammar points by IDs
    final grammarData = ref.watch(grammarWithStatusProvider);

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
            color: context.theme.colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: context.theme.colorScheme.tertiary,
                width: 2,
              ),
            ),
            child: Container(
              width: context.screenWidth * 0.85,
              constraints: const BoxConstraints(maxWidth: 600),
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    _buildHeader(context),

                    // Grammar content
                    _buildContent(context, grammarData, ref),

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
                          backgroundColor: context.theme.colorScheme.tertiary,
                          foregroundColor: context.theme.colorScheme.onTertiary,
                        ),
                        child: const Text('Got it!'),
                      ),
                    ),
                  ],
                ),
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
                color: context.theme.colorScheme.tertiaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.school,
                color: context.theme.colorScheme.tertiary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Grammar Point',
                    style: context.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '文法のポイント',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
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

  Widget _buildContent(BuildContext context, AsyncValue<List<GrammarPointModel>> grammarData, WidgetRef ref) {
    return grammarData.when(
      data: (allGrammar) {
        // Filter to get only the requested grammar points
        final List<GrammarPointModel> grammarItems = [];
        for (final id in grammarIds) {
          // Parse ID to int
          final grammarId = int.tryParse(id);
          if (grammarId != null) {
            // Find matching grammar
            final grammar = allGrammar.where((g) => g.id == grammarId).toList();
            if (grammar.isNotEmpty) {
              grammarItems.add(grammar.first);
            }
          }
        }

        if (grammarItems.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text('No grammar information available'),
          );
        }

        // Auto-unlock grammar for the player
        for (final grammar in grammarItems) {
          _unlockGrammar(grammar.id, ref);
        }

        return ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 450),
          child: PageView.builder(
            itemCount: grammarItems.length,
            itemBuilder: (context, index) {
              return _buildGrammarCard(context, grammarItems[index], index);
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
          'Error loading grammar: $error',
          style: context.textTheme.bodyLarge?.copyWith(
            color: context.theme.colorScheme.error,
          ),
        ),
      ),
    );
  }

  Future<void> _unlockGrammar(int grammarId, WidgetRef ref) async {
    final gameRepository = ref.read(gameRepositoryProvider);
    final activeSaveId = ref.read(activeSaveIdProvider);

    if (activeSaveId != null) {
      await gameRepository.unlockGrammar(activeSaveId, grammarId);
    }
  }

  Widget _buildGrammarCard(BuildContext context, GrammarPointModel grammar, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // JLPT level and new badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getJlptColor(grammar.jlptLevel),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  grammar.jlptLevel,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'NEW',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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

          const SizedBox(height: 16),

          // Title
          Text(
            grammar.title,
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.theme.colorScheme.tertiary,
            ),
          ),

          const SizedBox(height: 12),

          // Pattern
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: context.theme.colorScheme.tertiaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              grammar.patternJp,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 16),

          // Explanation
          Text(
            grammar.explanationEn,
            style: context.textTheme.bodyLarge,
          ),

          const SizedBox(height: 16),

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
                  'Example:',
                  style: context.textTheme.labelLarge?.copyWith(
                    color: context.theme.colorScheme.tertiary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  grammar.exampleJp,
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  grammar.exampleEn,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),

          if (grammarIds.length > 1)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Center(
                child: Text(
                  'Swipe to see more (${index + 1}/${grammarIds.length})',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
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
