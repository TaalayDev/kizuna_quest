import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kizuna_quest/core/services/settings_service.dart';
import 'package:kizuna_quest/utils/app_logger.dart';

/// An enum representing the available theme options
enum AppThemeMode {
  system,
  light,
  dark;

  /// Convert enum value to ThemeMode
  ThemeMode toThemeMode() {
    switch (this) {
      case AppThemeMode.system:
        return ThemeMode.system;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
    }
  }

  /// Convert ThemeMode to enum value
  static AppThemeMode fromThemeMode(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.system:
        return AppThemeMode.system;
      case ThemeMode.light:
        return AppThemeMode.light;
      case ThemeMode.dark:
        return AppThemeMode.dark;
    }
  }

  /// Get the theme mode name for display
  String get displayName {
    switch (this) {
      case AppThemeMode.system:
        return 'System';
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
    }
  }
}

/// Provider for the current theme mode (light, dark, or system)
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

/// State notifier for theme mode changes
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.dark) {
    _loadSavedTheme();
  }

  /// Load the saved theme mode from settings
  Future<void> _loadSavedTheme() async {
    try {
      final themeModeString = SettingsService.getString('theme_mode');
      if (themeModeString != null) {
        final themeMode = AppThemeMode.values.firstWhere(
          (e) => e.name == themeModeString,
          orElse: () => AppThemeMode.system,
        );
        state = themeMode.toThemeMode();
      }
    } catch (e, stack) {
      AppLogger.error('Failed to load theme mode', error: e, stackTrace: stack);
    }
  }

  /// Set the theme mode and save to settings
  Future<void> setThemeMode(AppThemeMode themeMode) async {
    state = themeMode.toThemeMode();
    try {
      await SettingsService.setString('theme_mode', themeMode.name);
    } catch (e, stack) {
      AppLogger.error('Failed to save theme mode', error: e, stackTrace: stack);
    }
  }

  /// Toggle between light and dark themes (ignores system)
  Future<void> toggleTheme() async {
    // If currently system, default to light then toggle
    final currentTheme = state == ThemeMode.system ? ThemeMode.light : state;

    // Toggle between light and dark
    final newTheme = currentTheme == ThemeMode.light ? AppThemeMode.dark : AppThemeMode.light;

    await setThemeMode(newTheme);
  }
}

/// Provider for determining if the app is currently in dark mode
final isDarkModeProvider = Provider<bool>((ref) {
  final themeMode = ref.watch(themeModeProvider);
  final platformBrightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;

  switch (themeMode) {
    case ThemeMode.light:
      return false;
    case ThemeMode.dark:
      return true;
    case ThemeMode.system:
      return platformBrightness == Brightness.dark;
  }
});
