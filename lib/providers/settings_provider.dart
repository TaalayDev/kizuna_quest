// lib/providers/settings_providers.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kizuna_quest/core/services/settings_service.dart';
import 'package:kizuna_quest/core/utils/app_logger.dart';

// Text speed settings
class TextSpeedNotifier extends StateNotifier<int> {
  TextSpeedNotifier() : super(SettingsService.getTextSpeed()) {
    _loadSetting();
  }

  Future<void> _loadSetting() async {
    state = SettingsService.getTextSpeed();
  }

  Future<void> setTextSpeed(int speed) async {
    await SettingsService.setTextSpeed(speed);
    state = speed;
  }
}

final textSpeedProvider = StateNotifierProvider<TextSpeedNotifier, int>((ref) {
  return TextSpeedNotifier();
});

// Audio settings
class AudioSettingsNotifier extends StateNotifier<Map<String, dynamic>> {
  AudioSettingsNotifier()
      : super({
          'musicVolume': SettingsService.getMusicVolume(),
          'sfxVolume': SettingsService.getSfxVolume(),
          'audioEnabled': SettingsService.isAudioEnabled(),
        }) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    state = {
      'musicVolume': SettingsService.getMusicVolume(),
      'sfxVolume': SettingsService.getSfxVolume(),
      'audioEnabled': SettingsService.isAudioEnabled(),
    };
  }

  Future<void> setMusicVolume(double volume) async {
    await SettingsService.setMusicVolume(volume);
    state = {...state, 'musicVolume': volume};
  }

  Future<void> setSfxVolume(double volume) async {
    await SettingsService.setSfxVolume(volume);
    state = {...state, 'sfxVolume': volume};
  }

  Future<void> setAudioEnabled(bool enabled) async {
    await SettingsService.setAudioEnabled(enabled);
    state = {...state, 'audioEnabled': enabled};
  }
}

final audioSettingsProvider = StateNotifierProvider<AudioSettingsNotifier, Map<String, dynamic>>((ref) {
  return AudioSettingsNotifier();
});

// Display settings
class DisplaySettingsNotifier extends StateNotifier<Map<String, dynamic>> {
  DisplaySettingsNotifier()
      : super({
          'showFurigana': SettingsService.isShowFurigana(),
          'showRomaji': SettingsService.isShowRomaji(),
          'textSize': SettingsService.getTextSize(),
        }) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    state = {
      'showFurigana': SettingsService.isShowFurigana(),
      'showRomaji': SettingsService.isShowRomaji(),
      'textSize': SettingsService.getTextSize(),
    };
  }

  Future<void> setShowFurigana(bool show) async {
    await SettingsService.setShowFurigana(show);
    state = {...state, 'showFurigana': show};
  }

  Future<void> setShowRomaji(bool show) async {
    await SettingsService.setShowRomaji(show);
    state = {...state, 'showRomaji': show};
  }

  Future<void> setTextSize(double size) async {
    await SettingsService.setTextSize(size);
    state = {...state, 'textSize': size};
  }
}

final displaySettingsProvider = StateNotifierProvider<DisplaySettingsNotifier, Map<String, dynamic>>((ref) {
  return DisplaySettingsNotifier();
});

// Gameplay settings
class GameplaySettingsNotifier extends StateNotifier<Map<String, dynamic>> {
  GameplaySettingsNotifier()
      : super({
          'autoplayEnabled': SettingsService.isAutoplayEnabled(),
          'autoplayDelay': SettingsService.getAutoplayDelay(),
          'languageLevel': SettingsService.getLanguageLevel(),
        }) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    state = {
      'autoplayEnabled': SettingsService.isAutoplayEnabled(),
      'autoplayDelay': SettingsService.getAutoplayDelay(),
      'languageLevel': SettingsService.getLanguageLevel(),
    };
  }

  Future<void> setAutoplayEnabled(bool enabled) async {
    await SettingsService.setAutoplayEnabled(enabled);
    state = {...state, 'autoplayEnabled': enabled};
  }

  Future<void> setAutoplayDelay(int delay) async {
    await SettingsService.setAutoplayDelay(delay);
    state = {...state, 'autoplayDelay': delay};
  }

  Future<void> setLanguageLevel(int level) async {
    await SettingsService.setLanguageLevel(level);
    state = {...state, 'languageLevel': level};
  }
}

final gameplaySettingsProvider = StateNotifierProvider<GameplaySettingsNotifier, Map<String, dynamic>>((ref) {
  return GameplaySettingsNotifier();
});
