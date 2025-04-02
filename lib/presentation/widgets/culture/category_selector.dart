import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kizuna_quest/core/utils/extensions.dart';

/// Widget for selecting culture note categories
class CategorySelector extends StatelessWidget {
  /// Available categories
  final List<String> categories;

  /// Currently selected category
  final String? selectedCategory;

  /// Callback when a category is selected
  final void Function(String) onCategorySelected;

  /// Creates a CategorySelector
  const CategorySelector({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category || (selectedCategory == null && category == 'All');

          return _CategoryButton(
            label: category,
            isSelected: isSelected,
            onTap: () => onCategorySelected(category),
            index: index,
          );
        },
      ),
    );
  }
}

/// Individual category button
class _CategoryButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final int index;

  const _CategoryButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color:
                  isSelected ? context.theme.colorScheme.tertiary : context.theme.colorScheme.surface.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? context.theme.colorScheme.tertiary
                    : context.theme.colorScheme.outline.withOpacity(0.3),
                width: 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: context.theme.colorScheme.tertiary.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                label,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? context.theme.colorScheme.onTertiary : context.theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: (100 + (index * 50)).ms, duration: 300.ms);
  }
}
