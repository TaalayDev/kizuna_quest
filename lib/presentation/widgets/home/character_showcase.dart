import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsuzuki_connect/config/theme/custom_colors.dart';
import 'package:tsuzuki_connect/data/models/character_model.dart';
import 'package:tsuzuki_connect/providers/database_provider.dart';
import 'package:tsuzuki_connect/core/utils/extensions.dart';

import 'character_display_dialog.dart';

class CharacterShowcase extends ConsumerStatefulWidget {
  const CharacterShowcase({
    super.key,
    this.showTitle = true,
  });

  final bool showTitle;

  @override
  ConsumerState<CharacterShowcase> createState() => _CharacterShowcaseState();
}

class _CharacterShowcaseState extends ConsumerState<CharacterShowcase> {
  final _pageController = PageController(viewportFraction: 0.85);
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final charactersData = ref.watch(characterRelationshipsProvider);

    final allCharactersAsync = ref.watch(allCharactersProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showTitle) ...[
          Text(
            'Characters',
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
          const SizedBox(height: 16),
        ],
        SizedBox(
          height: 220,
          child: charactersData.when(
            data: (characters) {
              final unlockedCharacters = characters.where((c) => c.hasRelationship).toList();

              if (unlockedCharacters.isEmpty) {
                return _buildEmptyState();
              }

              return allCharactersAsync.when(
                data: (allCharacters) => _buildCharacterList(unlockedCharacters),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => _buildErrorState(context, error),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stack) => Center(
              child: Text(
                'Error loading characters',
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.theme.colorScheme.error,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: context.theme.colorScheme.error,
              size: 40,
            ),
            const SizedBox(height: 8),
            Text(
              'Failed to load character data',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        width: context.screenWidth * 0.85,
        decoration: BoxDecoration(
          color: context.theme.colorScheme.surface.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people,
              size: 48,
              color: context.theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Meet characters as you play',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Start your adventure to discover new friends and build relationships.',
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildCharacterList(List<CharacterModel> characters) {
    return ShaderMask(
      shaderCallback: (Rect rect) {
        return const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.black,
            Colors.transparent,
            Colors.transparent,
            Colors.black,
          ],
          stops: [0.0, 0.05, 0.9, 1.0],
        ).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (notification is ScrollEndNotification) {
            final page = _pageController.page?.round() ?? 0;
            if (_currentPage != page) {
              setState(() {
                _currentPage = page;
              });
            }
          }
          return false;
        },
        child: PageView.builder(
          controller: _pageController,
          itemCount: characters.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final character = characters[index];
            final isActive = index == _currentPage;

            return _CharacterCard(
              character: character,
              isActive: isActive,
              index: index,
            );
          },
        ),
      ),
    );
  }
}

class _CharacterCard extends StatelessWidget {
  final CharacterModel character;
  final bool isActive;
  final int index;

  const _CharacterCard({
    required this.character,
    required this.isActive,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showCharacterDetailDialog(context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: EdgeInsets.only(
          right: 16,
          top: isActive ? 0 : 10,
          bottom: isActive ? 0 : 10,
        ),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.surface.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isActive ? 0.2 : 0.1),
              blurRadius: isActive ? 12 : 8,
              offset: Offset(0, isActive ? 4 : 2),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.theme.colorScheme.primary,
              context.theme.colorScheme.primaryContainer,
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              bottom: 0,
              width: 150,
              child: Hero(
                tag: 'character_avatar_${character.id}',
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  child: Image.asset(
                    character.avatarPath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Relationship level indicator
                  if (character.hasRelationship)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: _getKizunaColor(context, character.kizunaPoints ?? 0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        character.relationshipLevel,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: _getOnKizunaColor(context, character.kizunaPoints ?? 0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  const SizedBox(height: 12),

                  // Japanese name
                  Hero(
                    tag: 'character_name_jp_${character.id}',
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        character.nameJp,
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.theme.colorScheme.primaryFixed,
                        ),
                      ),
                    ),
                  ),

                  // English name
                  Hero(
                    tag: 'character_name_en_${character.id}',
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        character.nameEn,
                        style: context.textTheme.bodyLarge,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Personality description
                  SizedBox(
                    width: context.screenWidth * 0.4,
                    child: Text(
                      character.personality,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Kizuna points display
                  if (character.hasRelationship && character.kizunaPoints != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.favorite,
                            size: 16,
                            color: _getKizunaColor(context, character.kizunaPoints!),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Tsuzuki: ${character.kizunaPoints}',
                            style: context.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: _getKizunaColor(context, character.kizunaPoints!),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ).animate().fadeIn(delay: (200 + (index * 100)).ms, duration: 400.ms),
    );
  }

  void _showCharacterDetailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: CharacterDetailDialog(character: character),
      ),
    );
  }

  Color _getKizunaColor(BuildContext context, int points) {
    return Theme.of(context).extension<CustomColors>()?.getKizunaColor(context, points) ??
        context.theme.colorScheme.primary;
  }

  Color _getOnKizunaColor(BuildContext context, int points) {
    return Theme.of(context).extension<CustomColors>()?.getOnKizunaColor(context, points) ??
        context.theme.colorScheme.onPrimaryContainer;
  }
}
