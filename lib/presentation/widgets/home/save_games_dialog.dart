import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tsuzuki_connect/core/utils/constants.dart';
import 'package:tsuzuki_connect/core/utils/extensions.dart';
import 'package:tsuzuki_connect/data/models/save_game_model.dart';
import 'package:tsuzuki_connect/presentation/widgets/home/character_showcase.dart';
import 'package:tsuzuki_connect/providers/database_provider.dart';

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
  late Animation<double> _fadeAnimation;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
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

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.3),
              Colors.black.withOpacity(0.7),
            ],
          ),
        ),
        child: SlideTransition(
          position: _slideAnimation,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(
                left: 12,
                right: 12,
                bottom: context.paddingBottom + 12,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    context.theme.colorScheme.primary,
                    context.theme.colorScheme.primaryContainer,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                  BoxShadow(
                    color: context.theme.colorScheme.primary.withOpacity(0.1),
                    blurRadius: 40,
                    offset: const Offset(0, -10),
                  ),
                ],
                border: Border.all(
                  color: context.theme.colorScheme.primary.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(),
                  _buildContent(allSaveGames),
                  // _buildCharacterShowcase(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CharacterShowcase(showTitle: false),
                  ),
                  const SizedBox(height: 18),
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.theme.colorScheme.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.save_outlined,
              size: 24,
              color: context.theme.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Save Games',
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                Text(
                  'Continue your adventure',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.theme.colorScheme.onPrimary.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _dismissDialog,
            icon: Icon(
              Icons.close,
              size: 24,
              color: context.theme.colorScheme.onPrimaryContainer,
            ),
            style: IconButton.styleFrom(
              backgroundColor: context.theme.colorScheme.surface.withOpacity(0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(begin: -0.2, end: 0);
  }

  Widget _buildContent(AsyncValue<List<SaveGameModel>> allSaveGames) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: context.screenHeight * 0.45,
      ),
      child: allSaveGames.when(
        data: (saveGames) {
          if (saveGames.isEmpty) {
            return _buildEmptyState();
          }

          final sortedSaves = List<SaveGameModel>.from(saveGames)
            ..sort((a, b) => b.lastSavedAt.compareTo(a.lastSavedAt));

          return Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.2,
              ),
              itemCount: sortedSaves.length,
              itemBuilder: (context, index) {
                final save = sortedSaves[index];
                return _buildSaveGameCard(save, index);
              },
            ),
          );
        },
        loading: () => SizedBox(
          height: 200,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: context.theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Loading saves...',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
        error: (error, stack) => Container(
          height: 200,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: context.theme.colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading saves',
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.theme.colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 200,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    context.theme.colorScheme.primary.withOpacity(0.1),
                    context.theme.colorScheme.primary.withOpacity(0.05),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_stories,
                size: 48,
                color: context.theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No saved games yet',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start a new adventure to begin\nyour language learning journey!',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 600.ms).scale(begin: const Offset(0.8, 0.8));
  }

  Widget _buildSaveGameCard(SaveGameModel save, int index) {
    final isQuickSave = save.slotId == 0;

    return GestureDetector(
      onTap: _isDeleting ? () => _confirmDeleteSave(save) : () => _loadSaveGame(save),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _isDeleting
                ? [
                    context.theme.colorScheme.errorContainer.withOpacity(0.3),
                    context.theme.colorScheme.errorContainer.withOpacity(0.1),
                  ]
                : [
                    context.theme.colorScheme.surfaceVariant.withOpacity(0.8),
                    context.theme.colorScheme.surfaceVariant.withOpacity(0.4),
                  ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isDeleting
                ? context.theme.colorScheme.error.withOpacity(0.3)
                : context.theme.colorScheme.primary.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  (_isDeleting ? context.theme.colorScheme.error : context.theme.colorScheme.primary).withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          image: save.thumbnailPath != null
              ? DecorationImage(
                  image: AssetImage(save.thumbnailPath!),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.2),
                    BlendMode.darken,
                  ),
                )
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          context.theme.colorScheme.primary,
                          context.theme.colorScheme.primary.withOpacity(0.7),
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: context.theme.colorScheme.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        isQuickSave ? 'Q' : save.slotId.toString(),
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (isQuickSave)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: context.theme.colorScheme.tertiary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.bolt,
                            size: 12,
                            color: context.theme.colorScheme.onTertiary,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            'Quick',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.theme.colorScheme.onTertiary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (_isDeleting)
                    Icon(
                      Icons.delete_outline,
                      color: context.theme.colorScheme.error,
                      size: 20,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getChapterTitle(save.currentChapter),
                      style: context.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.theme.colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      save.playerName,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 12,
                          color: context.theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            save.formattedPlayTime,
                            style: context.textTheme.bodySmall?.copyWith(
                              fontSize: 10,
                              color: context.theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.update,
                          size: 12,
                          color: context.theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _getRelativeTime(save.lastSavedAt),
                            style: context.textTheme.bodySmall?.copyWith(
                              fontSize: 10,
                              color: context.theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(
          delay: (300 + index * 100).ms,
          duration: 500.ms,
        )
        .slideX(
          begin: 0.3,
          end: 0,
          delay: (300 + index * 100).ms,
          duration: 500.ms,
          curve: Curves.easeOutCubic,
        );
  }

  Widget _buildCharacterShowcase() {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.theme.colorScheme.primaryContainer.withOpacity(0.3),
            context.theme.colorScheme.tertiaryContainer.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.theme.colorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Meet your companions',
                    style: context.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Discover new friends on your journey',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Character avatars
          Row(
            children: [
              _buildCharacterAvatar('🌸', Colors.pink.withOpacity(0.3)),
              const SizedBox(width: 8),
              _buildCharacterAvatar('⚡', Colors.yellow.withOpacity(0.3)),
              const SizedBox(width: 8),
              _buildCharacterAvatar('🌙', Colors.blue.withOpacity(0.3)),
              const SizedBox(width: 16),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms, duration: 500.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildCharacterAvatar(String emoji, Color color) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: context.theme.colorScheme.primary.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface.withOpacity(0.5),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        border: Border(
          top: BorderSide(
            color: context.theme.colorScheme.outlineVariant.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _isDeleting = !_isDeleting;
                });
              },
              icon: Icon(
                _isDeleting ? Icons.cancel_outlined : Icons.delete_outline,
                size: 18,
              ),
              label: Text(_isDeleting ? 'Cancel' : 'Delete Mode'),
              style: OutlinedButton.styleFrom(
                foregroundColor: _isDeleting ? context.theme.colorScheme.primary : context.theme.colorScheme.error,
                side: BorderSide(
                  color: _isDeleting ? context.theme.colorScheme.primary : context.theme.colorScheme.error,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                _dismissDialog();
                _startNewGame(context);
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('New Game'),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.theme.colorScheme.primary,
                foregroundColor: context.theme.colorScheme.onPrimary,
                elevation: 4,
                shadowColor: context.theme.colorScheme.primary.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 700.ms, duration: 400.ms).slideY(begin: 0.2, end: 0);
  }

  void _loadSaveGame(SaveGameModel save) {
    ref.read(activeSaveIdProvider.notifier).state = save.id;
    _dismissDialog();
    context.push('${AppConstants.routeGame}?chapter=${save.currentChapter}&saveId=${save.id}');
  }

  void _confirmDeleteSave(SaveGameModel save) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete ${save.slotId == 0 ? 'Quick Save' : 'Save #${save.slotId}'}?',
          style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to delete this save? This action cannot be undone.',
          style: context.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteSaveGame(save);
            },
            style: FilledButton.styleFrom(
              backgroundColor: context.theme.colorScheme.error,
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

      final activeSaveId = ref.read(activeSaveIdProvider);
      if (activeSaveId == save.id) {
        ref.read(activeSaveIdProvider.notifier).setActiveSaveId(null);
      }

      setState(() {
        _isDeleting = false;
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Save deleted successfully'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: context.theme.colorScheme.primary,
          ),
        );
      }
    } catch (e) {
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
    context.push('${AppConstants.routeGame}?chapter=chapter_1');
  }

  String _getChapterTitle(String chapterId) {
    final chapterMap = {
      'chapter_1': 'Chapter 1: Arrival in Tokyo',
      'chapter_2': 'Chapter 2: First Day at School',
      'chapter_3': 'Chapter 3: The Festival',
      'chapter_4': 'Chapter 4: Cultural Exchange',
      'chapter_5': 'Chapter 5: Cherry Blossoms',
    };
    return chapterMap[chapterId] ?? 'Unknown Chapter';
  }

  String _getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return '${dateTime.month}/${dateTime.day}';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'just now';
    }
  }
}
