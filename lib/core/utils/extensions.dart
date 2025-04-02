import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Extension on BuildContext to easily access theme and other contextual data
extension BuildContextExtension on BuildContext {
  /// Get the current theme
  ThemeData get theme => Theme.of(this);

  /// Get color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Get text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Check if the current theme is dark
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Get screen size
  Size get screenSize => MediaQuery.of(this).size;

  /// Get screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Get screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Get paddingTop (safe area)
  double get paddingTop => MediaQuery.of(this).padding.top;

  /// Get paddingBottom (safe area)
  double get paddingBottom => MediaQuery.of(this).padding.bottom;

  /// Show snackbar with default styling
  void showSnackBar(String message, {Duration? duration}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Dismiss keyboard
  void dismissKeyboard() {
    FocusScope.of(this).unfocus();
  }
}

/// Extension on String for common operations
extension StringExtension on String {
  /// Capitalize the first letter of the string
  String get capitalized {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Convert string to title case
  String get titleCase {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalized).join(' ');
  }

  /// Check if the string is a valid email
  bool get isValidEmail {
    final emailRegExp = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    return emailRegExp.hasMatch(this);
  }

  /// Format date string to a readable format
  String toFormattedDate(String format) {
    try {
      final date = DateTime.parse(this);
      return DateFormat(format).format(date);
    } catch (e) {
      return this;
    }
  }

  /// Add furigana to Japanese text (placeholder for actual implementation)
  String addFurigana() {
    // This would implement actual furigana logic for Japanese text
    // For now it's just a placeholder
    return this;
  }
}

/// Extension on DateTime for formatting
extension DateTimeExtension on DateTime {
  /// Format date to standard format
  String get formatted => DateFormat('yyyy-MM-dd').format(this);

  /// Format date and time
  String get formattedWithTime => DateFormat('yyyy-MM-dd HH:mm').format(this);

  /// Format as relative time (e.g. "2 hours ago")
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays >= 365) {
      return '${(difference.inDays / 365).floor()} year(s) ago';
    } else if (difference.inDays >= 30) {
      return '${(difference.inDays / 30).floor()} month(s) ago';
    } else if (difference.inDays >= 7) {
      return '${(difference.inDays / 7).floor()} week(s) ago';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} day(s) ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} hour(s) ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} minute(s) ago';
    } else {
      return 'Just now';
    }
  }
}
