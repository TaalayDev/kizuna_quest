import 'package:flutter/material.dart';
import 'package:kizuna_quest/core/utils/extensions.dart';

/// Filter chip widget for vocabulary categories
class VocabularyFilterChip extends StatelessWidget {
  /// Label text to display
  final String label;

  /// Count of items in this category
  final int count;

  /// Whether this chip is currently selected
  final bool isSelected;

  /// Accent color for this chip when selected
  final Color color;

  /// Callback when chip is selected
  final VoidCallback onSelected;

  /// Creates a VocabularyFilterChip
  const VocabularyFilterChip({
    super.key,
    required this.label,
    required this.count,
    required this.isSelected,
    required this.color,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? context.theme.colorScheme.onPrimary.withOpacity(0.8)
                    : context.theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? color : context.theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        selected: isSelected,
        onSelected: (value) {
          if (value) {
            onSelected();
          }
        },
        showCheckmark: false,
        selectedColor: color.withOpacity(0.8),
        backgroundColor: context.theme.colorScheme.surface,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isSelected ? color : context.theme.colorScheme.outline.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
    );
  }
}
