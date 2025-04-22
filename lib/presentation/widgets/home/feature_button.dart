import 'package:flutter/material.dart';
import 'package:tsuzuki_connect/core/utils/extensions.dart';

/// A button widget for home screen features
class FeatureButton extends StatelessWidget {
  /// Title of the feature
  final String title;

  /// Japanese text for the feature
  final String japaneseText;

  /// Icon to display
  final IconData icon;

  /// Subtitle or description
  final String subtitle;

  /// Background color
  final Color color;

  /// Callback when tapped
  final VoidCallback onTap;

  /// Creates a FeatureButton
  const FeatureButton({
    super.key,
    required this.title,
    required this.japaneseText,
    required this.icon,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: color.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background pattern
            Positioned(
              right: -20,
              bottom: -20,
              child: Icon(
                icon,
                size: 100,
                color: Colors.white.withOpacity(0.1),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon
                  Icon(
                    icon,
                    size: 28,
                    color: Colors.white,
                  ),

                  const SizedBox(height: 8),

                  // Title
                  Text(
                    title,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Subtitle
                  Text(
                    subtitle,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Japanese text in the corner
            Positioned(
              bottom: 8,
              right: 8,
              child: Text(
                japaneseText,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
