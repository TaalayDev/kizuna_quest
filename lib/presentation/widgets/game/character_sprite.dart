import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tsuzuki_connect/data/models/character_model.dart';

enum SpritePosition {
  left,
  center,
  right,
}

class CharacterSprite extends StatelessWidget {
  final CharacterModel character;
  final String expression;
  final String position;
  final bool isSpeaking;

  const CharacterSprite({
    super.key,
    required this.character,
    required this.expression,
    required this.position,
    this.isSpeaking = false,
  });

  @override
  Widget build(BuildContext context) {
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
        return (screenWidth / 2) - screenWidth * 0.45; // Center position with some offset
      case SpritePosition.right:
        return null;
    }
  }

  Widget _buildSpriteContainer(BuildContext context, SpritePosition spritePosition) {
    final spritePath = '${character.spriteFolder}/$expression.webp';

    var animatedSprite = _buildSprite(MediaQuery.sizeOf(context), spritePath);

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
    final height = size.height > 500 ? size.height * 0.8 : size.height;
    final width = size.width;

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(),
      child: Stack(
        children: [
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
          // Positioned.fill(
          //   right: -15,
          //   bottom: -15,
          //   child: Image.asset(
          //     spritePath,
          //     fit: BoxFit.contain,
          //     color: Colors.black.withOpacity(0.3),
          //   ),
          // ),
          Positioned.fill(
            child: Image.asset(
              spritePath,
              fit: BoxFit.contain,
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
        ],
      ),
    );
  }
}
