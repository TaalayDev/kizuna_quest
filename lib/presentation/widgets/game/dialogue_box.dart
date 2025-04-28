import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsuzuki_connect/config/theme/custom_colors.dart';
import 'package:tsuzuki_connect/data/models/character_model.dart';
import 'package:tsuzuki_connect/data/models/dialogue_model.dart';
import 'package:tsuzuki_connect/core/utils/extensions.dart';
import 'package:tsuzuki_connect/providers/sound_controller.dart';

/// Widget that displays the dialogue text box with typing animation
class DialogueBox extends ConsumerStatefulWidget {
  /// Current dialogue line to display
  final DialogueLine line;

  /// Character speaking (if any)
  final CharacterModel? character;

  /// Text speed in milliseconds per character
  final int textSpeed;

  /// Whether to show furigana
  final bool showFurigana;

  /// Whether to show romaji
  final bool showRomaji;

  /// Whether to show the text instantly
  final bool instantComplete;

  /// Callback when the text is fully displayed
  final VoidCallback onTextComplete;

  /// Callback when vocab button is tapped
  final VoidCallback? onVocabTap;

  /// Callback when grammar button is tapped
  final VoidCallback? onGrammarTap;

  /// Callback when cultural note button is tapped
  final VoidCallback? onCultureTap;

  /// Creates a DialogueBox widget
  const DialogueBox({
    super.key,
    required this.line,
    this.character,
    required this.textSpeed,
    required this.showFurigana,
    required this.showRomaji,
    this.instantComplete = false,
    required this.onTextComplete,
    this.onVocabTap,
    this.onGrammarTap,
    this.onCultureTap,
  });

  @override
  ConsumerState<DialogueBox> createState() => _DialogueBoxState();
}

class _DialogueBoxState extends ConsumerState<DialogueBox> with SingleTickerProviderStateMixin {
  // Typing animation state
  String _currentJapaneseText = '';
  String _currentEnglishText = '';
  Timer? _typingTimer;
  int _currentCharIndex = 0;
  bool _isTypingComplete = false;

  // Animation
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();

    // Set up animation for continue indicator
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    // Start typing animation
    if (widget.instantComplete) {
      _completeTextImmediately();
    } else {
      _startTypingAnimation();
    }
  }

  @override
  void didUpdateWidget(covariant DialogueBox oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If line changes, restart typing
    if (widget.line.id != oldWidget.line.id) {
      _resetTyping();

      if (widget.instantComplete) {
        _completeTextImmediately();
      } else {
        _startTypingAnimation();
      }
    } else if (!oldWidget.instantComplete && widget.instantComplete) {
      // If instant complete is newly enabled
      _completeTextImmediately();
    }
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _resetTyping() {
    _typingTimer?.cancel();
    _currentCharIndex = 0;
    _currentJapaneseText = '';
    _currentEnglishText = '';
    _isTypingComplete = false;
  }

  void _startTypingAnimation() {
    _resetTyping();

    // Calculate the total length of both texts
    final totalLength = widget.line.textJp.length + widget.line.textEn.length;

    // Start the typing animation
    _typingTimer = Timer.periodic(Duration(milliseconds: widget.textSpeed), (timer) {
      if (_currentCharIndex < widget.line.textJp.length) {
        // Still typing Japanese
        setState(() {
          _currentJapaneseText = widget.line.textJp.substring(0, _currentCharIndex + 1);
        });
      } else if (_currentCharIndex < totalLength) {
        // Typing English
        final englishIndex = _currentCharIndex - widget.line.textJp.length;
        setState(() {
          _currentEnglishText = widget.line.textEn.substring(0, englishIndex + 1);
        });
      } else {
        // Done typing
        _completeTyping();
        return;
      }

      _currentCharIndex++;
    });
  }

  void _completeTextImmediately() {
    _typingTimer?.cancel();
    setState(() {
      _currentJapaneseText = widget.line.textJp;
      _currentEnglishText = widget.line.textEn;
      _isTypingComplete = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onTextComplete();
    });
  }

  void _completeTyping() {
    _typingTimer?.cancel();
    setState(() {
      _currentJapaneseText = widget.line.textJp;
      _currentEnglishText = widget.line.textEn;
      _isTypingComplete = true;
    });
    widget.onTextComplete();
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    // Check if any learning buttons should be shown
    final hasVocab = widget.line.vocabularyIds.isNotEmpty && widget.onVocabTap != null;
    final hasGrammar = widget.line.grammarIds.isNotEmpty && widget.onGrammarTap != null;
    final hasCulture = widget.line.culturalNoteIds.isNotEmpty && widget.onCultureTap != null;
    final showLearningButtons = hasVocab || hasGrammar || hasCulture;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Speaker name tag (if a character is speaking)
          if (widget.character != null) _buildNameTag(context, customColors),

          // Main dialogue box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: customColors.dialogBox,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: customColors.dialogBoxBorder,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Japanese text
                Text(
                  _currentJapaneseText,
                  style: context.textTheme.titleLarge?.copyWith(
                    color: customColors.dialogBoxText,
                    height: 1.5,
                  ),
                ),

                // Furigana (if enabled and available)
                if (widget.showFurigana && widget.line.furiganaJp != null && _currentJapaneseText.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      widget.line.furiganaJp!,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: customColors.dialogBoxText.withOpacity(0.7),
                      ),
                    ),
                  ),

                // Romaji (if enabled and available)
                if (widget.showRomaji && widget.line.romajiJp != null && _currentJapaneseText.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      widget.line.romajiJp!,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: customColors.dialogBoxText.withOpacity(0.6),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),

                const SizedBox(height: 8),

                // English text
                Text(
                  _currentEnglishText,
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: customColors.dialogBoxText.withOpacity(0.8),
                  ),
                ),

                // Learning items buttons and continue indicator row
                if (_isTypingComplete)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      children: [
                        // Learning buttons (only if completed typing and buttons are needed)
                        if (showLearningButtons) ...[
                          _buildLearningButtonsRow(hasVocab, hasGrammar, hasCulture),
                          const Spacer(),
                        ],

                        // Continue indicator
                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: 0.8 + (_pulseController.value * 0.2),
                              child: Opacity(
                                opacity: 0.5 + (_pulseController.value * 0.5),
                                child: child,
                              ),
                            );
                          },
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: customColors.dialogBoxText.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameTag(BuildContext context, CustomColors customColors) {
    return Container(
      margin: const EdgeInsets.only(left: 20, bottom: 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: customColors.nameTag,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        widget.character?.nameJp ?? '',
        style: context.textTheme.titleMedium?.copyWith(
          color: customColors.nameTagText,
          fontWeight: FontWeight.bold,
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildLearningButtonsRow(bool hasVocab, bool hasGrammar, bool hasCulture) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasVocab)
          _buildLearningButton(
            icon: Icons.menu_book,
            color: Colors.amber.shade600,
            count: widget.line.vocabularyIds.length,
            onTap: widget.onVocabTap!,
          ),
        if (hasGrammar)
          _buildLearningButton(
            icon: Icons.school,
            color: Colors.deepPurple.shade400,
            count: widget.line.grammarIds.length,
            onTap: widget.onGrammarTap!,
          ),
        if (hasCulture)
          _buildLearningButton(
            icon: Icons.lightbulb_outline,
            color: Colors.teal.shade400,
            count: widget.line.culturalNoteIds.length,
            onTap: widget.onCultureTap!,
          ),
      ],
    ).animate().fadeIn(duration: 300.ms).scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1.0, 1.0),
          duration: 300.ms,
        );
  }

  Widget _buildLearningButton({
    required IconData icon,
    required Color color,
    required int count,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: InkWell(
        onTap: () {
          ref.read(soundControllerProvider.notifier).playClick();
          onTap();
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: color,
              ),
              const SizedBox(width: 4),
              Text(
                '+$count',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
