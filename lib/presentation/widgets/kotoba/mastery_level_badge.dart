import 'package:flutter/material.dart';

/// Widget for displaying vocabulary mastery level
class MasteryLevelBadge extends StatelessWidget {
  /// Mastery level (0: locked, 1: learning, 2: learned, 3: mastered)
  final int masteryLevel;

  /// Size of the badge
  final double size;

  /// Creates a MasteryLevelBadge
  const MasteryLevelBadge({
    super.key,
    required this.masteryLevel,
    this.size = 32.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getBackgroundColor(),
        boxShadow: [
          BoxShadow(
            color: _getBackgroundColor().withOpacity(0.3),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          _getIcon(),
          color: Colors.white,
          size: size * 0.6,
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (masteryLevel) {
      case 0:
        return Colors.grey; // Locked
      case 1:
        return Colors.orange; // Learning
      case 2:
        return Colors.teal; // Learned
      case 3:
        return Colors.green; // Mastered
      default:
        return Colors.grey;
    }
  }

  IconData _getIcon() {
    switch (masteryLevel) {
      case 0:
        return Icons.lock; // Locked
      case 1:
        return Icons.school; // Learning
      case 2:
        return Icons.check_circle; // Learned
      case 3:
        return Icons.stars; // Mastered
      default:
        return Icons.help_outline;
    }
  }
}
