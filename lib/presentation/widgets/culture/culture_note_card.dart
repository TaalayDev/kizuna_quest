import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kizuna_quest/data/models/cultural_note_model.dart';
import 'package:kizuna_quest/core/utils/extensions.dart';

/// Card widget for displaying a cultural note
class CultureNoteCard extends StatelessWidget {
  /// The cultural note to display
  final CulturalNoteModel note;

  /// Index for staggered animations
  final int index;

  /// Callback when card is tapped
  final VoidCallback onTap;

  /// Creates a CultureNoteCard
  const CultureNoteCard({
    super.key,
    required this.note,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isNew = note.isUnlocked && !note.isRead;

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: isNew ? 3 : 1,
      shadowColor: isNew ? context.theme.colorScheme.tertiary.withOpacity(0.5) : Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isNew
            ? BorderSide(
                color: context.theme.colorScheme.tertiary.withOpacity(0.7),
                width: 1.5,
              )
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with title and category
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.title,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Category chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(note.category).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _getCategoryColor(note.category).withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      note.category,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: _getCategoryColor(note.category),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Content preview
              Text(
                note.abbreviatedContent,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.theme.colorScheme.onBackground.withOpacity(0.8),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              // Footer row with date and status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Unlock date or source
                  if (note.unlockedAt != null)
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: context.theme.colorScheme.primary.withOpacity(0.7),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(note.unlockedAt!),
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.theme.colorScheme.onBackground.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),

                  // Status indicator
                  Row(
                    children: [
                      Icon(
                        isNew ? Icons.fiber_new : Icons.visibility,
                        size: 16,
                        color: isNew
                            ? context.theme.colorScheme.tertiary
                            : context.theme.colorScheme.primary.withOpacity(0.7),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isNew ? 'New' : 'Read',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: isNew
                              ? context.theme.colorScheme.tertiary
                              : context.theme.colorScheme.primary.withOpacity(0.7),
                          fontWeight: isNew ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: (100 + (index * 50)).ms, duration: 300.ms);
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'etiquette':
        return Colors.purple;
      case 'food':
        return Colors.orange;
      case 'traditions':
        return Colors.teal;
      case 'language':
        return Colors.blue;
      case 'festivals':
        return Colors.red;
      case 'daily life':
        return Colors.green;
      default:
        return Colors.blueGrey;
    }
  }
}
