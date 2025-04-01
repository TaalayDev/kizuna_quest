import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kizuna_quest/data/models/character_model.dart';

/// Position types for character sprites
enum SpritePosition {
  left,
  center,
  right,
}

/// Widget that displays a character sprite
class CharacterSprite extends StatelessWidget {
  /// The character to display
  final CharacterModel character;

  /// The expression/pose of the character
  final String expression;

  /// Position on screen (left, center, right)
  final String position;

  /// Whether this character is currently speaking
  final bool isSpeaking;

  /// Creates a CharacterSprite widget
  const CharacterSprite({
    super.key,
    required this.character,
    required this.expression,
    required this.position,
    this.isSpeaking = false,
  });

  @override
  Widget build(BuildContext context) {
    // Determine sprite position
    SpritePosition spritePosition;
    switch (position.toLowerCase()) {
      case 'left':
        spritePosition = SpritePosition.left;
        break;
      case 'right':
        spritePosition = SpritePosition.right;
        break;
      case 'center':
      default:
        spritePosition = SpritePosition.center;
        break;
    }

    return Positioned(
      bottom: 0,
      left: _getHorizontalPosition(spritePosition, context),
      child: _buildSpriteContainer(context, spritePosition),
    );
  }

  double? _getHorizontalPosition(SpritePosition spritePosition, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    switch (spritePosition) {
      case SpritePosition.left:
        return 0;
      case SpritePosition.center:
        return (screenWidth / 2) - 150; // Center sprite (assuming 300px width)
      case SpritePosition.right:
        return null; // Will be positioned from right
    }
  }

  Widget _buildSpriteContainer(BuildContext context, SpritePosition spritePosition) {
    final spritePath = '${character.spriteFolder}/$expression.webp';

    // Apply different animations based on position
    var animatedSprite = _buildSprite(MediaQuery.sizeOf(context), spritePath);

    // Add position-specific animations
    switch (spritePosition) {
      case SpritePosition.left:
        animatedSprite = animatedSprite
            .animate()
            .fadeIn(duration: 400.ms)
            .slideX(begin: -0.2, end: 0, duration: 400.ms, curve: Curves.easeOutQuad);
        break;
      case SpritePosition.center:
        animatedSprite = animatedSprite
            .animate()
            .fadeIn(duration: 400.ms)
            .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1), duration: 400.ms);
        break;
      case SpritePosition.right:
        animatedSprite = animatedSprite
            .animate()
            .fadeIn(duration: 400.ms)
            .slideX(begin: 0.2, end: 0, duration: 400.ms, curve: Curves.easeOutQuad);
        break;
    }

    // Add breathing animation for all sprites
    return animatedSprite
        .animate(
          onPlay: (controller) => controller.repeat(reverse: true),
        )
        .moveY(
          begin: 0,
          end: 5,
          duration: 3.seconds,
          curve: Curves.easeInOut,
        );
  }

  Widget _buildSprite(Size size, String spritePath) {
    // Build the basic sprite with shadow and highlight if speaking
    final height = size.height * 0.8; // Adjust height based on screen size
    final width = size.width * 0.8; // Adjust width based on screen size

    return Container(
      height: height, // Standard height for character sprites
      width: width, // Standard width for character sprites
      decoration: BoxDecoration(
        // Subtle glow effect if speaking
        boxShadow: isSpeaking
            ? [
                BoxShadow(
                  color: Colors.white.withOpacity(0.1),
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
              ]
            : [],
      ),
      child: Stack(
        children: [
          // Bottom shadow
          if (isSpeaking)
            Positioned(
              bottom: -5,
              left: 0,
              right: 0,
              child: Container(
                height: 20,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 15,
                      spreadRadius: -5,
                    ),
                  ],
                ),
              ),
            ),

          // Character image
          Positioned.fill(
            child: Image.asset(
              spritePath,
              fit: BoxFit.cover,
              // If image fails to load, use a placeholder
              errorBuilder: (context, error, stackTrace) {
                return ColoredBox(
                  color: Colors.black.withOpacity(0.1),
                  child: const Center(
                    child: Icon(
                      Icons.person,
                      size: 100,
                      color: Colors.white54,
                    ),
                  ),
                );
              },
            ),
          ),

          // Speaking indicator (subtle highlight)
          if (isSpeaking)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 2,
                  ),
                ),
              )
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
                  .fadeIn(
                    begin: 0.1,
                    duration: 1.seconds,
                    curve: Curves.easeInOut,
                  ),
            ),
        ],
      ),
    );
  }
}
