import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/extensions.dart';
import '../../../providers/sound_controller.dart';

class LearningJournalNotification extends StatefulWidget {
  final int vocabCount;
  final int grammarCount;
  final int cultureCount;
  final VoidCallback onVocabTap;
  final VoidCallback onGrammarTap;
  final VoidCallback onCultureTap;
  final VoidCallback onDismiss;

  const LearningJournalNotification({
    super.key,
    required this.vocabCount,
    required this.grammarCount,
    required this.cultureCount,
    required this.onVocabTap,
    required this.onGrammarTap,
    required this.onCultureTap,
    required this.onDismiss,
  });

  @override
  State<LearningJournalNotification> createState() => _LearningJournalNotificationState();
}

class _LearningJournalNotificationState extends State<LearningJournalNotification> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    // Auto-dismiss after 5 seconds if not interacted with
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && _controller.value > 0) {
        _dismissNotification();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _dismissNotification() {
    _controller.reverse().then((_) {
      widget.onDismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          margin: const EdgeInsets.only(top: 100, right: 16),
          width: 280,
          decoration: BoxDecoration(
            color: context.theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: context.theme.colorScheme.primaryContainer,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.primaryContainer,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.menu_book,
                      size: 20,
                      color: context.theme.colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Added to Journal',
                        style: context.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    Consumer(
                      builder: (context, ref, _) => GestureDetector(
                        onTap: () {
                          ref.read(soundControllerProvider.notifier).playClick();
                          _dismissNotification();
                        },
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: context.theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    // Only show items that have a count > 0
                    if (widget.vocabCount > 0)
                      _buildJournalItem(
                        context,
                        Icons.menu_book,
                        'Vocabulary',
                        widget.vocabCount,
                        Colors.amber.shade600,
                        widget.onVocabTap,
                      ),

                    if (widget.grammarCount > 0)
                      _buildJournalItem(
                        context,
                        Icons.school,
                        'Grammar Points',
                        widget.grammarCount,
                        Colors.deepPurple.shade400,
                        widget.onGrammarTap,
                      ),

                    if (widget.cultureCount > 0)
                      _buildJournalItem(
                        context,
                        Icons.lightbulb_outline,
                        'Cultural Notes',
                        widget.cultureCount,
                        Colors.teal.shade400,
                        widget.onCultureTap,
                      ),
                  ],
                ),
              ),

              // Footer
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0, left: 12.0, right: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Tap to view',
                      style: context.textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: context.theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.touch_app,
                      size: 14,
                      color: context.theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJournalItem(
    BuildContext context,
    IconData icon,
    String title,
    int count,
    Color color,
    VoidCallback onTap,
  ) {
    return Consumer(
      builder: (context, ref, _) => InkWell(
        onTap: () {
          ref.read(soundControllerProvider.notifier).playClick();
          onTap();
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: color,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '+$count',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
