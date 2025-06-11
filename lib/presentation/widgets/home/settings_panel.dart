import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsuzuki_connect/core/utils/extensions.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../core/utils/constants.dart';
import '../../../providers/settings_provider.dart';
import '../../../providers/sound_controller.dart';
import '../../../providers/theme_providers.dart';

class SettingsPanel extends ConsumerWidget {
  const SettingsPanel({
    super.key,
    this.onClose,
    this.onReplayTutorial,
    this.onShowAbout,
  });

  final VoidCallback? onClose;
  final VoidCallback? onReplayTutorial;
  final VoidCallback? onShowAbout;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchTheme(
      data: context.theme.switchTheme.copyWith(
        thumbColor: MaterialStateProperty.all(context.theme.colorScheme.primaryContainer),
        trackColor: MaterialStateProperty.all(context.theme.colorScheme.onSurface.withOpacity(0.5)),
      ),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              ref.read(soundControllerProvider.notifier).playClick();
              onClose?.call();
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            width: context.screenWidth * 0.4,
            child: Container(
              decoration: BoxDecoration(
                color: context.theme.colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(-2, 0),
                  ),
                ],
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    context.theme.colorScheme.primary,
                    context.theme.colorScheme.primaryContainer,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    child: Row(
                      children: [
                        Text(
                          'Settings',
                          style: context.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            ref.read(soundControllerProvider.notifier).playClick();
                            onClose?.call();
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),

                  const Divider(),

                  // Settings items with direct controls
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _buildThemeSettings(context, ref),
                        _buildTextSpeedSettings(context, ref),
                        _buildAudioSettings(context, ref),
                        _buildDisplaySettings(context, ref),
                        //  _buildGameplaySettings(context, ref),
                        if (onShowAbout != null)
                          ListTile(
                            leading: Icon(
                              Icons.info,
                              color: context.theme.colorScheme.onSurface,
                            ),
                            title: const Text('About'),
                            subtitle: const Text('App version and credits'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: onShowAbout,
                          ),
                        if (onReplayTutorial != null)
                          ListTile(
                            leading: Icon(
                              Icons.replay,
                              color: context.theme.colorScheme.onSurface,
                            ),
                            title: const Text('Replay Tutorial'),
                            subtitle: const Text('See the onboarding again'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: onReplayTutorial,
                          ),
                        Divider(),
                        ListTile(
                          leading: Icon(
                            Icons.privacy_tip,
                            color: context.theme.colorScheme.onSurface,
                          ),
                          title: const Text('Privacy Policy'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            launchUrlString(AppConstants.privacyPolicyUrl);
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.article,
                            color: context.theme.colorScheme.onSurface,
                          ),
                          title: const Text('Terms of Service'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            launchUrlString(AppConstants.termsOfServiceUrl);
                          },
                        ),
                      ],
                    ),
                  ),

                  // Version number
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Version 1.0.0',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ).animate().slideX(
                begin: 1,
                end: 0,
                duration: 300.ms,
                curve: Curves.easeOutQuad,
              ),
        ],
      ),
    );
  }

  Widget _buildThemeSettings(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final isSystem = themeMode == ThemeMode.system;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16, top: 16, bottom: 8),
          child: Text('Theme', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        SwitchListTile(
          title: const Text('Dark Mode'),
          value: isDark,
          onChanged: (value) {
            ref.read(themeModeProvider.notifier).setThemeMode(value ? AppThemeMode.dark : AppThemeMode.light);
          },
          secondary: Icon(
            isDark ? Icons.dark_mode : Icons.light_mode,
            color: context.theme.colorScheme.onSurface,
          ),
        ),
        SwitchListTile(
          title: const Text('Use System Theme'),
          value: isSystem,
          onChanged: (value) {
            if (value) {
              ref.read(themeModeProvider.notifier).setThemeMode(AppThemeMode.system);
            } else {
              ref.read(themeModeProvider.notifier).setThemeMode(isDark ? AppThemeMode.dark : AppThemeMode.light);
            }
          },
          secondary: Icon(
            Icons.settings_suggest,
            color: context.theme.colorScheme.onSurface,
          ),
        ),
        const Divider(),
      ],
    );
  }
}

Widget _buildTextSpeedSettings(BuildContext context, WidgetRef ref) {
  final textSpeed = ref.watch(textSpeedProvider);

  String getSpeedLabel() {
    if (textSpeed <= 20) return 'Fast';
    if (textSpeed <= 40) return 'Normal';
    return 'Slow';
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.only(left: 16, top: 16, bottom: 8),
        child: Text('Text Speed', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      ListTile(
        leading: Icon(
          Icons.speed,
          color: context.theme.colorScheme.onSurface,
        ),
        title: Text('Speed: ${getSpeedLabel()}'),
        subtitle: Slider(
          value: textSpeed.toDouble(),
          min: 10,
          max: 80,
          divisions: 7,
          label: getSpeedLabel(),
          onChanged: (value) {
            ref.read(textSpeedProvider.notifier).setTextSpeed(value.round());
          },
        ),
      ),
      const Divider(),
    ],
  );
}

Widget _buildAudioSettings(BuildContext context, WidgetRef ref) {
  final audioSettings = ref.watch(soundControllerProvider);
  final audioEnabled = audioSettings.isSoundEnabled;
  final musicVolume = audioSettings.musicVolume;
  final sfxVolume = audioSettings.soundVolume;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.only(left: 16, top: 16, bottom: 8),
        child: Text('Audio', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      SwitchListTile(
        title: const Text('Enable Audio'),
        value: audioEnabled,
        onChanged: (value) {
          ref.read(soundControllerProvider.notifier).playClick();
          ref.read(soundControllerProvider.notifier).setSoundEnabled(value);
        },
        secondary: Icon(
          audioEnabled ? Icons.volume_up : Icons.volume_off,
          color: context.theme.colorScheme.onSurface,
        ),
      ),
      if (audioEnabled) ...[
        ListTile(
          leading: Icon(
            Icons.music_note,
            color: context.theme.colorScheme.onSurface,
          ),
          title: const Text('Music Volume'),
          subtitle: Slider(
            value: musicVolume,
            min: 0.0,
            max: 1.0,
            divisions: 10,
            label: '${(musicVolume * 100).round()}%',
            onChanged: (value) {
              ref.read(soundControllerProvider.notifier).setMusicVolume(value);
            },
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.surround_sound,
            color: context.theme.colorScheme.onSurface,
          ),
          title: const Text('Sound Effects Volume'),
          subtitle: Slider(
            value: sfxVolume,
            min: 0.0,
            max: 1.0,
            divisions: 10,
            label: '${(sfxVolume * 100).round()}%',
            onChanged: (value) {
              ref.read(soundControllerProvider.notifier).setSoundVolume(value);
            },
          ),
        ),
      ],
      const Divider(),
    ],
  );
}

Widget _buildDisplaySettings(BuildContext context, WidgetRef ref) {
  final displaySettings = ref.watch(displaySettingsProvider);
  final showFurigana = displaySettings['showFurigana'] ?? true;
  final showRomaji = displaySettings['showRomaji'] ?? true;
  final textSize = displaySettings['textSize'] ?? 16.0;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.only(left: 16, top: 16, bottom: 8),
        child: Text('Display', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      SwitchListTile(
        title: const Text('Show Furigana'),
        subtitle: const Text('Hiragana reading above kanji'),
        value: showFurigana,
        onChanged: (value) {
          ref.read(displaySettingsProvider.notifier).setShowFurigana(value);
        },
        secondary: Icon(
          Icons.text_fields,
          color: context.theme.colorScheme.onSurface,
        ),
      ),
      SwitchListTile(
        title: const Text('Show Romaji'),
        subtitle: const Text('Latin alphabet transliteration'),
        value: showRomaji,
        onChanged: (value) {
          ref.read(displaySettingsProvider.notifier).setShowRomaji(value);
        },
        secondary: Icon(
          Icons.abc,
          color: context.theme.colorScheme.onSurface,
        ),
      ),
      ListTile(
        leading: Icon(
          Icons.format_size,
          color: context.theme.colorScheme.onSurface,
        ),
        title: Text('Text Size: ${textSize.toStringAsFixed(1)}'),
        subtitle: Slider(
          value: textSize,
          min: 12.0,
          max: 24.0,
          divisions: 12,
          label: textSize.toStringAsFixed(1),
          onChanged: (value) {
            ref.read(displaySettingsProvider.notifier).setTextSize(value);
          },
        ),
      ),
      const Divider(),
    ],
  );
}

Widget _buildGameplaySettings(BuildContext context, WidgetRef ref) {
  final gameplaySettings = ref.watch(gameplaySettingsProvider);
  final autoplayEnabled = gameplaySettings['autoplayEnabled'] ?? false;
  final autoplayDelay = gameplaySettings['autoplayDelay'] ?? 2000;
  final languageLevel = gameplaySettings['languageLevel'] ?? 5;

  String getLevelName(int level) {
    switch (level) {
      case 1:
        return 'N1 - Advanced';
      case 2:
        return 'N2 - Upper Intermediate';
      case 3:
        return 'N3 - Intermediate';
      case 4:
        return 'N4 - Lower Intermediate';
      case 5:
        return 'N5 - Beginner';
      default:
        return 'Unknown';
    }
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.only(left: 16, top: 16, bottom: 8),
        child: Text('Gameplay', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      SwitchListTile(
        title: const Text('Auto-play'),
        subtitle: const Text('Automatically advance dialogue'),
        value: autoplayEnabled,
        onChanged: (value) {
          ref.read(gameplaySettingsProvider.notifier).setAutoplayEnabled(value);
        },
        secondary: Icon(
          Icons.play_circle,
          color: context.theme.colorScheme.onSurface,
        ),
      ),
      if (autoplayEnabled)
        ListTile(
          leading: Icon(
            Icons.timer,
            color: context.theme.colorScheme.onSurface,
          ),
          title: Text('Auto-play Delay: ${(autoplayDelay / 1000).toStringAsFixed(1)}s'),
          subtitle: Slider(
            value: autoplayDelay.toDouble(),
            min: 1000,
            max: 5000,
            divisions: 8,
            label: '${(autoplayDelay / 1000).toStringAsFixed(1)}s',
            onChanged: (value) {
              ref.read(gameplaySettingsProvider.notifier).setAutoplayDelay(value.round());
            },
          ),
        ),
      ListTile(
        leading: Icon(
          Icons.school,
          color: context.theme.colorScheme.onSurface,
        ),
        title: Text('JLPT Level: ${getLevelName(languageLevel)}'),
        subtitle: Slider(
          value: languageLevel.toDouble(),
          min: 1,
          max: 5,
          divisions: 4,
          label: 'N$languageLevel',
          onChanged: (value) {
            ref.read(gameplaySettingsProvider.notifier).setLanguageLevel(value.round());
          },
        ),
      ),
      const Divider(),
    ],
  );
}
