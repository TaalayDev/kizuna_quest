import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kizuna_quest/core/utils/constants.dart';
import 'package:kizuna_quest/core/utils/extensions.dart';
import 'package:kizuna_quest/data/models/save_game_model.dart';
import 'package:kizuna_quest/providers/database_provider.dart';

class SaveGamesDialog extends ConsumerStatefulWidget {
  final VoidCallback onDismiss;

  const SaveGamesDialog({
    super.key,
    required this.onDismiss,
  });

  @override
  ConsumerState<SaveGamesDialog> createState() => _SaveGamesDialogState();
}

class _SaveGamesDialogState extends ConsumerState<SaveGamesDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _dismissDialog() {
    _controller.reverse().then((_) {
      widget.onDismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    final allSaveGames = ref.watch(allSaveGamesProvider);

    return SlideTransition(
      position: _slideAnimation,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: context.paddingBottom + 16,
          ),
          decoration: BoxDecoration(
            color: context.theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
            border: Border.all(
              color: context.theme.colorScheme.primaryContainer,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.primaryContainer,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.save_outlined,
                      size: 24,
                      color: context.theme.colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Save Games',
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _dismissDialog,
                      icon: Icon(
                        Icons.close,
                        size: 20,
                        color: context.theme.colorScheme.onPrimaryContainer,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),

              // Content
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: context.screenHeight * 0.6,
                ),
                child: allSaveGames.when(
                  data: (saveGames) {
                    if (saveGames.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.save_outlined,
                                size: 48,
                                color: context.theme.colorScheme.primary.withOpacity(0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No saved games yet',
                                style: context.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Start a new game to begin your adventure!',
                                style: context.textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // Sort saves (most recent first)
                    final sortedSaves = List<SaveGameModel>.from(saveGames)
                      ..sort((a, b) => b.lastSavedAt.compareTo(a.lastSavedAt));

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shrinkWrap: true,
                      itemCount: sortedSaves.length,
                      separatorBuilder: (context, index) => const Divider(height: 1, indent: 16, endIndent: 16),
                      itemBuilder: (context, index) {
                        final save = sortedSaves[index];
                        return _buildSaveGameItem(save);
                      },
                    );
                  },
                  loading: () => const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (error, stack) => Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Center(
                      child: Text(
                        'Error loading saves',
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: context.theme.colorScheme.error,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Footer
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.surface,
                  border: Border(
                    top: BorderSide(
                      color: context.theme.colorScheme.outlineVariant,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Delete mode toggle
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _isDeleting = !_isDeleting;
                        });
                      },
                      icon: Icon(
                        _isDeleting ? Icons.cancel : Icons.delete_outline,
                        size: 20,
                      ),
                      label: Text(_isDeleting ? 'Cancel' : 'Delete Mode'),
                      style: TextButton.styleFrom(
                        foregroundColor:
                            _isDeleting ? context.theme.colorScheme.primary : context.theme.colorScheme.error,
                      ),
                    ),

                    // New game button
                    ElevatedButton.icon(
                      onPressed: () {
                        _dismissDialog();
                        _startNewGame(context);
                      },
                      icon: Icon(
                        Icons.add,
                        size: 20,
                        color: context.theme.colorScheme.onPrimary,
                      ),
                      label: const Text('New Game'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.theme.colorScheme.primary,
                        foregroundColor: context.theme.colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSaveGameItem(SaveGameModel save) {
    final isQuickSave = save.slotId == 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListTile(
        onTap: _isDeleting ? () => _deleteSaveGame(save) : () => _loadSaveGame(save),
        leading: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: context.theme.colorScheme.primaryContainer.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  isQuickSave ? 'Q' : save.slotId.toString(),
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
            if (isQuickSave)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: context.theme.colorScheme.tertiary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.bolt,
                    size: 12,
                    color: context.theme.colorScheme.onTertiary,
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          _getChapterTitle(save.currentChapter),
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              save.playerName,
              style: context.textTheme.bodySmall,
              maxLines: 1,
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.access_time,
                  size: 12,
                  color: context.theme.colorScheme.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  save.formattedPlayTime,
                  style: context.textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                    color: context.theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.calendar_today,
                  size: 12,
                  color: context.theme.colorScheme.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  _getRelativeTime(save.lastSavedAt),
                  style: context.textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                    color: context.theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: _isDeleting
            ? Icon(
                Icons.delete,
                color: context.theme.colorScheme.error,
              )
            : Icon(
                Icons.play_circle_fill,
                color: context.theme.colorScheme.primary,
                size: 32,
              ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        tileColor:
            _isDeleting ? context.theme.colorScheme.errorContainer.withOpacity(0.2) : context.theme.colorScheme.surface,
      ),
    );
  }

  void _loadSaveGame(SaveGameModel save) {
    // Set active save in provider
    ref.read(activeSaveIdProvider.notifier).state = save.id;

    // Dismiss the dialog and navigate to game screen
    _dismissDialog();

    // Navigate to game screen with chapter and save ID
    context.push('${AppConstants.routeGame}?chapter=${save.currentChapter}&saveId=${save.id}');
  }

  void _confirmDeleteSave(SaveGameModel save) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete ${save.slotId == 0 ? 'Quick Save' : 'Save #${save.slotId}'}?'),
        content: Text(
          'Are you sure you want to delete this save? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteSaveGame(save);
            },
            style: TextButton.styleFrom(
              foregroundColor: context.theme.colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteSaveGame(SaveGameModel save) async {
    try {
      final gameRepository = ref.read(gameRepositoryProvider);
      await gameRepository.deleteSaveGame(save.id);

      // If this was the active save, clear it
      final activeSaveId = ref.read(activeSaveIdProvider);
      if (activeSaveId == save.id) {
        ref.read(activeSaveIdProvider.notifier).setActiveSaveId(null);
      }

      // Turn off delete mode
      setState(() {
        _isDeleting = false;
      });

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Save deleted successfully'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete save: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: context.theme.colorScheme.error,
          ),
        );
      }
    }
  }

  void _startNewGame(BuildContext context) {
    // Navigate to game screen with no save ID (new game)
    context.push('${AppConstants.routeGame}?chapter=chapter_1');
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

  String _getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      // Format as date
      return '${dateTime.month}/${dateTime.day}';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'now';
    }
  }
}
