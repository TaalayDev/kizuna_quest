// lib/presentation/widgets/home/character_detail_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kizuna_quest/data/models/character_model.dart';
import 'package:kizuna_quest/core/utils/extensions.dart';

/// Dialog that displays detailed information about a character
class CharacterDetailDialog extends StatelessWidget {
  /// The character to display
  final CharacterModel character;

  /// Creates a CharacterDetailDialog
  const CharacterDetailDialog({
    super.key,
    required this.character,
  });

  @override
  Widget build(BuildContext context) {
    // Choose a default sprite from the character's sprite folder
    final defaultSprite = '${character.spriteFolder}/avatar.webp';

    return Container(
      width: context.screenWidth * 0.9,
      height: context.screenHeight * 0.7,
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Background gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    context.theme.colorScheme.surface,
                    context.theme.colorScheme.surfaceVariant,
                  ],
                ),
              ),
            ),

            // Content layout
            Row(
              children: [
                // Left side - Character info
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Names
                        Hero(
                          tag: 'character_name_jp_${character.id}',
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              character.nameJp,
                              style: context.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: context.theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                        Hero(
                          tag: 'character_name_en_${character.id}',
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              character.nameEn,
                              style: context.textTheme.titleLarge,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Relationship status
                        if (character.hasRelationship)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 6.0,
                            ),
                            decoration: BoxDecoration(
                              color: _getKizunaColor(context, character.kizunaPoints ?? 0),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              character.relationshipLevel,
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                        const SizedBox(height: 16),

                        // Full personality description
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'About',
                                  style: context.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  character.personality,
                                  style: context.textTheme.bodyLarge,
                                ),

                                const SizedBox(height: 24),

                                // Additional character information
                                if (character.hasRelationship) ...[
                                  Text(
                                    'Interests',
                                    style: context.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _getCharacterInterests(character),
                                    style: context.textTheme.bodyLarge,
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    'Relationship',
                                    style: context.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  LinearProgressIndicator(
                                    value: (character.kizunaPoints ?? 0) / 100,
                                    color: _getKizunaColor(context, character.kizunaPoints ?? 0),
                                    backgroundColor: context.theme.colorScheme.surfaceVariant,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Kizuna Points: ${character.kizunaPoints ?? 0}/100',
                                    style: context.textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _getRelationshipDescription(character),
                                    style: context.textTheme.bodyLarge,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Right side - Character sprite
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Hero(
                      tag: 'character_avatar_${character.id}',
                      child: Image.asset(
                        defaultSprite,
                        fit: BoxFit.cover,
                        height: context.screenHeight * 0.4,
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback to avatar if sprite not found
                          return Image.asset(
                            character.avatarPath,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Close button
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).scale(
          begin: const Offset(0.9, 0.9),
          end: const Offset(1.0, 1.0),
          duration: 300.ms,
          curve: Curves.easeOutBack,
        );
  }

  Color _getKizunaColor(BuildContext context, int points) {
    if (points >= 75) {
      return Colors.purple;
    } else if (points >= 50) {
      return Colors.blue;
    } else if (points >= 25) {
      return Colors.teal;
    } else {
      return Colors.grey;
    }
  }

  String _getCharacterInterests(CharacterModel character) {
    // Example interests based on character ID
    switch (character.id) {
      case 1: // Yuki
        return 'Reading, studying foreign languages, visiting cafes, and collecting cute stationery.';
      case 2: // Tanaka-sensei
        return 'Traditional Japanese literature, calligraphy, hiking in the mountains, and teaching.';
      case 3: // Sato
        return 'Cooking traditional Japanese food, gardening, watching baseball, and playing shogi.';
      case 4: // Mei
        return 'Japanese cultural history, tea ceremony, visiting museums, and photography.';
      case 5: // Kenta
        return 'Baseball, running, video games, and eating ramen.';
      default:
        return 'Getting to know new people and sharing Japanese culture.';
    }
  }

  String _getRelationshipDescription(CharacterModel character) {
    final points = character.kizunaPoints ?? 0;

    if (points >= 75) {
      return 'You have a very close relationship with ${character.nameEn}. They often seek out your company and share personal stories with you.';
    } else if (points >= 50) {
      return '${character.nameEn} considers you a good friend and feels comfortable around you.';
    } else if (points >= 25) {
      return '${character.nameEn} recognizes you and seems to enjoy your conversations.';
    } else {
      return 'You\'ve just met ${character.nameEn}. Continue interacting to build your relationship.';
    }
  }
}
