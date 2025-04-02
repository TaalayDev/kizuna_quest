import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kizuna_quest/data/models/cultural_note_model.dart';
import 'package:kizuna_quest/providers/database_provider.dart';
import 'package:kizuna_quest/core/utils/extensions.dart';

/// Learning popup for cultural notes
class CulturalNotePopup extends ConsumerWidget {
  /// IDs of cultural notes to display
  final List<String> culturalNoteIds;

  /// Callback when the popup is closed
  final VoidCallback onClose;

  /// Creates a CulturalNotePopup widget
  const CulturalNotePopup({
    super.key,
    required this.culturalNoteIds,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fetch cultural notes by IDs
    final notesData = ref.watch(culturalNotesWithStatusProvider);

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
              side: BorderSide(
                color: context.theme.colorScheme.surfaceVariant,
                width: 2,
              ),
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

                  // Cultural notes content
                  _buildContent(context, notesData, ref),

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
                        backgroundColor: context.theme.colorScheme.surfaceVariant,
                        foregroundColor: context.theme.colorScheme.onSurfaceVariant,
                      ),
                      child: const Text('I Understand'),
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
                color: context.theme.colorScheme.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lightbulb_outline,
                color: context.theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cultural Insight',
                    style: context.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '文化ノート',
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

  Widget _buildContent(BuildContext context, AsyncValue<List<CulturalNoteModel>> notesData, WidgetRef ref) {
    return notesData.when(
      data: (allNotes) {
        // Filter to get only the requested cultural notes
        final List<CulturalNoteModel> noteItems = [];
        for (final id in culturalNoteIds) {
          // Parse ID to int
          final noteId = int.tryParse(id);
          if (noteId != null) {
            // Find matching cultural note
            final note = allNotes.where((n) => n.id == noteId).toList();
            if (note.isNotEmpty) {
              noteItems.add(note.first);
            }
          }
        }

        if (noteItems.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text('No cultural information available'),
          );
        }

        // Auto-unlock cultural notes for the player
        for (final note in noteItems) {
          _unlockCulturalNote(note.id, ref);
        }

        return ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 450),
          child: PageView.builder(
            itemCount: noteItems.length,
            itemBuilder: (context, index) {
              return _buildCulturalNoteCard(context, noteItems[index], index);
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
          'Error loading cultural notes: $error',
          style: context.textTheme.bodyLarge?.copyWith(
            color: context.theme.colorScheme.error,
          ),
        ),
      ),
    );
  }

  Future<void> _unlockCulturalNote(int noteId, WidgetRef ref) async {
    final gameRepository = ref.read(gameRepositoryProvider);
    final activeSaveId = ref.read(activeSaveIdProvider);

    if (activeSaveId != null) {
      await gameRepository.unlockCulturalNote(activeSaveId, noteId);
    }
  }

  Widget _buildCulturalNoteCard(BuildContext context, CulturalNoteModel note, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Category and new badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  note.category,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.theme.colorScheme.onSurfaceVariant,
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
                      Icons.new_releases,
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
            note.title,
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.theme.colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 16),

          // Content
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                note.content,
                style: context.textTheme.bodyLarge,
              ),
            ),
          ),

          if (culturalNoteIds.length > 1)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Center(
                child: Text(
                  'Swipe to see more (${index + 1}/${culturalNoteIds.length})',
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
}
