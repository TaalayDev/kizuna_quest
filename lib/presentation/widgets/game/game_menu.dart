import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kizuna_quest/core/utils/extensions.dart';

import '../../../providers/sound_controller.dart';

/// Widget that displays the in-game menu
class GameMenu extends StatelessWidget {
  /// Callback when the menu is closed
  final VoidCallback onClose;

  /// Callback when save is pressed
  final VoidCallback onSave;

  /// Callback when load is pressed
  final VoidCallback onLoad;

  /// Callback when settings is pressed
  final VoidCallback onSettings;

  /// Callback when exit is pressed
  final VoidCallback onExit;

  /// Creates a GameMenu widget
  const GameMenu({
    super.key,
    required this.onClose,
    required this.onSave,
    required this.onLoad,
    required this.onSettings,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Semi-transparent backdrop
        GestureDetector(
          onTap: onClose,
          child: Container(
            color: Colors.black.withOpacity(0.7),
          ),
        ),

        // Menu panel
        Center(
          child: Container(
            width: context.screenWidth * 0.8,
            constraints: const BoxConstraints(maxWidth: 500),
            decoration: BoxDecoration(
              color: context.theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                _buildHeader(context),

                // Menu buttons
                _buildMenuItems(context),

                // Close button
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Consumer(
                    builder: (context, ref, _) => ElevatedButton(
                      onPressed: () {
                        ref.read(soundControllerProvider.notifier).playClick();
                        onClose();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: context.theme.colorScheme.onPrimary,
                        backgroundColor: context.theme.colorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text('Return to Game'),
                    ),
                  ),
                ),
              ],
            ),
          ).animate().scale(
                begin: const Offset(0.9, 0.9),
                end: const Offset(1.0, 1.0),
                duration: 300.ms,
                curve: Curves.easeOutBack,
              ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.primary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Game Menu',
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.theme.colorScheme.onPrimary,
            ),
          ),
          const Spacer(),
          Consumer(
            builder: (context, ref, _) => IconButton(
              onPressed: () {
                ref.read(soundControllerProvider.notifier).playClick();
                onClose();
              },
              icon: Icon(
                Icons.close,
                color: context.theme.colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            _buildMenuItem(
              context,
              icon: Icons.save,
              title: 'Save Game',
              subtitle: 'Save your current progress',
              onTap: () {
                ref.read(soundControllerProvider.notifier).playClick();
                onSave();
              },
              index: 0,
            ),
            _buildMenuItem(
              context,
              icon: Icons.restore,
              title: 'Load Game',
              subtitle: 'Load a previously saved game',
              onTap: () {
                ref.read(soundControllerProvider.notifier).playClick();
                onLoad();
              },
              index: 1,
            ),
            _buildMenuItem(
              context,
              icon: Icons.settings,
              title: 'Settings',
              subtitle: 'Adjust game settings',
              onTap: () {
                ref.read(soundControllerProvider.notifier).playClick();
                onSettings();
              },
              index: 2,
            ),
            _buildMenuItem(
              context,
              icon: Icons.menu_book,
              title: 'Kotoba Log',
              subtitle: 'View your vocabulary progress',
              onTap: () {
                ref.read(soundControllerProvider.notifier).playClick();
                context.push('/kotoba');
              },
              index: 3,
            ),
            _buildMenuItem(
              context,
              icon: Icons.lightbulb,
              title: 'Culture Notes',
              subtitle: 'Browse cultural information',
              onTap: () {
                ref.read(soundControllerProvider.notifier).playClick();
                context.push('/culture');
              },
              index: 4,
            ),
            _buildMenuItem(
              context,
              icon: Icons.exit_to_app,
              title: 'Exit to Main Menu',
              subtitle: 'Return to the main menu',
              onTap: () {
                ref.read(soundControllerProvider.notifier).playClick();
                onExit();
              },
              isDestructive: true,
              index: 5,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required int index,
    bool isDestructive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isDestructive
                      ? context.theme.colorScheme.error.withOpacity(0.1)
                      : context.theme.colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isDestructive ? context.theme.colorScheme.error : context.theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDestructive ? context.theme.colorScheme.error : context.theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: context.theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: 50 * index),
          duration: 200.ms,
        )
        .slideX(
          begin: 0.1,
          end: 0,
          delay: Duration(milliseconds: 50 * index),
          duration: 200.ms,
          curve: Curves.easeOutQuad,
        );
  }
}
