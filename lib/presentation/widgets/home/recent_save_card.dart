import 'package:flutter/material.dart';
import 'package:kizuna_quest/data/models/save_game_model.dart';
import 'package:kizuna_quest/core/utils/extensions.dart';

/// Card widget displaying a recent save game
class RecentSaveCard extends StatelessWidget {
  /// The save game to display
  final SaveGameModel saveGame;

  /// Callback when card is tapped
  final VoidCallback onTap;

  /// Creates a RecentSaveCard
  const RecentSaveCard({
    super.key,
    required this.saveGame,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: context.theme.colorScheme.surface.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left part - save thumbnail or placeholder
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: SizedBox(
                width: 100,
                height: 100,
                child: saveGame.thumbnailPath != null
                    ? Image.asset(
                        saveGame.thumbnailPath!,
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      )
                    : Container(
                        color: context.theme.colorScheme.primaryContainer,
                        child: Center(
                          child: Icon(
                            Icons.photo,
                            size: 36,
                            color: context.theme.colorScheme.primary,
                          ),
                        ),
                      ),
              ),
            ),

            // Right part - save info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Chapter title
                    Text(
                      _getChapterTitle(saveGame.currentChapter),
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // Player name
                    Text(
                      saveGame.playerName,
                      style: context.textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // Play time and save date
                    Row(
                      children: [
                        // Play time
                        Icon(
                          Icons.timer,
                          size: 14,
                          color: context.theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          saveGame.formattedPlayTime,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Save date
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: context.theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _getRelativeTimeString(saveGame.lastSavedAt),
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.theme.colorScheme.onSurface.withOpacity(0.7),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Continue button
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: IconButton(
                onPressed: onTap,
                icon: Icon(
                  Icons.play_circle_fill,
                  color: context.theme.colorScheme.primary,
                  size: 36,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getChapterTitle(String chapterId) {
    // This would ideally be fetched from a repository or localization
    final chapterMap = {
      'chapter_1': 'Chapter 1: Arrival in Tokyo',
      'chapter_2': 'Chapter 2: First Day at School',
      'chapter_3': 'Chapter 3: The Festival',
      // Add more chapters as needed
    };

    return chapterMap[chapterId] ?? 'Unknown Chapter';
  }

  String _getRelativeTimeString(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      // Format as date
      return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }
}
