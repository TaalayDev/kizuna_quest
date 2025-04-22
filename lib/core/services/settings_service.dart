import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tsuzuki_connect/core/utils/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service class to handle application settings persistence
///
/// This service provides a centralized way to store and retrieve
/// application settings using SharedPreferences.
class SettingsService {
  static late SharedPreferences _prefs;

  // Key constants
  static const String _keyTextSpeed = 'text_speed';
  static const String _keyAutoplayEnabled = 'autoplay_enabled';
  static const String _keyAutoplayDelay = 'autoplay_delay';
  static const String _keyTextSize = 'text_size';
  static const String _keyMusicVolume = 'music_volume';
  static const String _keySfxVolume = 'sfx_volume';
  static const String _keyAudioEnabled = 'audio_enabled';
  static const String _keyShowFurigana = 'show_furigana';
  static const String _keyShowRomaji = 'show_romaji';
  static const String _keyLanguageLevel = 'language_level';
  static const String _keyAppLocale = 'app_locale';
  static const String _keyFirstLaunch = 'first_launch';
  static const String _keyDeviceId = 'device_id';
  static const String _keyOnboardingCompleted = 'onboarding_completed';
  static const String _keyActiveSaveId = 'active_save_id';

  /// Initialize the settings service
  static Future<void> initialize() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      AppLogger.info('Settings service initialized');
    } catch (e, stack) {
      AppLogger.error('Failed to initialize settings service', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Check if this is the first app launch
  static bool isFirstLaunch() {
    return _prefs.getBool(_keyFirstLaunch) ?? true;
  }

  /// Mark that the app has been launched
  static Future<void> markAppLaunched() async {
    await _prefs.setBool(_keyFirstLaunch, false);
    await _prefs.setBool(_keyOnboardingCompleted, true);
  }

  /// Check if onboarding is completed
  static bool isOnboardingCompleted() {
    return _prefs.getBool(_keyOnboardingCompleted) ?? false;
  }

  /// Mark that onboarding is completed
  static Future<void> setOnboardingCompleted(bool val) async {
    await _prefs.setBool(_keyOnboardingCompleted, val);
  }

  /// Get the active save game ID
  static int? getActiveSaveId() {
    return _prefs.getInt(_keyActiveSaveId);
  }

  /// Set the active save game ID
  static Future<void> setActiveSaveId(int? saveId) async {
    if (saveId == null) {
      await _prefs.remove(_keyActiveSaveId);
    } else {
      await _prefs.setInt(_keyActiveSaveId, saveId);
    }
  }

  /// Reset all settings to default values
  static Future<void> resetToDefaults() async {
    try {
      // Don't reset first launch flag or device ID
      final firstLaunch = isFirstLaunch();
      final deviceId = getDeviceId();
      final activeSaveId = getActiveSaveId();

      // Get all keys except those we want to preserve
      final keys = _prefs.getKeys().where(
            (key) => key != _keyFirstLaunch && key != _keyDeviceId && key != _keyActiveSaveId,
          );

      // Remove all other keys
      for (final key in keys) {
        await _prefs.remove(key);
      }

      // Restore preserved values
      await _prefs.setBool(_keyFirstLaunch, firstLaunch);
      if (deviceId != null) {
        await _prefs.setString(_keyDeviceId, deviceId);
      }
      if (activeSaveId != null) {
        await _prefs.setInt(_keyActiveSaveId, activeSaveId);
      }

      AppLogger.info('Settings reset to defaults');
    } catch (e, stack) {
      AppLogger.error('Failed to reset settings', error: e, stackTrace: stack);
      rethrow;
    }
  }

  // String settings

  /// Get a string value from settings
  static String? getString(String key) {
    return _prefs.getString(key);
  }

  /// Set a string value in settings
  static Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  /// Get the device ID (unique identifier for this installation)
  static String? getDeviceId() {
    return _prefs.getString(_keyDeviceId);
  }

  /// Set the device ID
  static Future<void> setDeviceId(String deviceId) async {
    await _prefs.setString(_keyDeviceId, deviceId);
  }

  /// Get the app locale as a Locale object
  static Locale? getLocale() {
    final localeString = _prefs.getString(_keyAppLocale);
    if (localeString == null) return null;

    try {
      final localeMap = jsonDecode(localeString) as Map<String, dynamic>;
      return Locale(
        localeMap['languageCode'] as String,
        localeMap['countryCode'] as String?,
      );
    } catch (e) {
      AppLogger.warning('Failed to parse locale: $localeString');
      return null;
    }
  }

  /// Set the app locale
  static Future<void> setLocale(Locale locale) async {
    final localeMap = {
      'languageCode': locale.languageCode,
      'countryCode': locale.countryCode,
    };
    await _prefs.setString(_keyAppLocale, jsonEncode(localeMap));
  }

  // Boolean settings

  /// Get a boolean value from settings
  static bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  /// Set a boolean value in settings
  static Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  /// Get whether autoplay is enabled
  static bool isAutoplayEnabled() {
    return _prefs.getBool(_keyAutoplayEnabled) ?? false;
  }

  /// Set whether autoplay is enabled
  static Future<void> setAutoplayEnabled(bool enabled) async {
    await _prefs.setBool(_keyAutoplayEnabled, enabled);
  }

  /// Get whether audio is enabled
  static bool isAudioEnabled() {
    return _prefs.getBool(_keyAudioEnabled) ?? true;
  }

  /// Set whether audio is enabled
  static Future<void> setAudioEnabled(bool enabled) async {
    await _prefs.setBool(_keyAudioEnabled, enabled);
  }

  /// Get whether furigana is shown
  static bool isShowFurigana() {
    return _prefs.getBool(_keyShowFurigana) ?? true;
  }

  /// Set whether furigana is shown
  static Future<void> setShowFurigana(bool show) async {
    await _prefs.setBool(_keyShowFurigana, show);
  }

  /// Get whether romaji is shown
  static bool isShowRomaji() {
    return _prefs.getBool(_keyShowRomaji) ?? true;
  }

  /// Set whether romaji is shown
  static Future<void> setShowRomaji(bool show) async {
    await _prefs.setBool(_keyShowRomaji, show);
  }

  // Integer settings

  /// Get an integer value from settings
  static int? getInt(String key) {
    return _prefs.getInt(key);
  }

  /// Set an integer value in settings
  static Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  /// Get the text speed in milliseconds per character
  static int getTextSpeed() {
    return _prefs.getInt(_keyTextSpeed) ?? 40; // Default 40ms per character
  }

  /// Set the text speed in milliseconds per character
  static Future<void> setTextSpeed(int speed) async {
    await _prefs.setInt(_keyTextSpeed, speed);
  }

  /// Get the autoplay delay in milliseconds
  static int getAutoplayDelay() {
    return _prefs.getInt(_keyAutoplayDelay) ?? 2000; // Default 2 seconds
  }

  /// Set the autoplay delay in milliseconds
  static Future<void> setAutoplayDelay(int delay) async {
    await _prefs.setInt(_keyAutoplayDelay, delay);
  }

  /// Get the language level (1-5, representing JLPT levels)
  static int getLanguageLevel() {
    return _prefs.getInt(_keyLanguageLevel) ?? 5; // Default N5 (beginner)
  }

  /// Set the language level
  static Future<void> setLanguageLevel(int level) async {
    await _prefs.setInt(_keyLanguageLevel, level);
  }

  // Double settings

  /// Get a double value from settings
  static double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  /// Set a double value in settings
  static Future<void> setDouble(String key, double value) async {
    await _prefs.setDouble(key, value);
  }

  /// Get the text size
  static double getTextSize() {
    return _prefs.getDouble(_keyTextSize) ?? 16.0; // Default 16.0
  }

  /// Set the text size
  static Future<void> setTextSize(double size) async {
    await _prefs.setDouble(_keyTextSize, size);
  }

  /// Get the music volume (0.0 to 1.0)
  static double getMusicVolume() {
    return _prefs.getDouble(_keyMusicVolume) ?? 0.7; // Default 70%
  }

  /// Set the music volume
  static Future<void> setMusicVolume(double volume) async {
    await _prefs.setDouble(_keyMusicVolume, volume);
  }

  /// Get the SFX volume (0.0 to 1.0)
  static double getSfxVolume() {
    return _prefs.getDouble(_keySfxVolume) ?? 1.0; // Default 100%
  }

  /// Set the SFX volume
  static Future<void> setSfxVolume(double volume) async {
    await _prefs.setDouble(_keySfxVolume, volume);
  }
}
