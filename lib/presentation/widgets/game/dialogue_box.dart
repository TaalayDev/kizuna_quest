import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kizuna_quest/config/theme/custom_colors.dart';
import 'package:kizuna_quest/data/models/character_model.dart';
import 'package:kizuna_quest/data/models/dialogue_model.dart';
import 'package:kizuna_quest/core/utils/extensions.dart';

/// Widget that displays the dialogue text box with typing animation
class DialogueBox extends StatefulWidget {
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
  });

  @override
  State<DialogueBox> createState() => _DialogueBoxState();
}

class _DialogueBoxState extends State<DialogueBox> with SingleTickerProviderStateMixin {
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
  void didUpdateWidget(DialogueBox oldWidget) {
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

                // Continue indicator (only if typing is complete)
                if (_isTypingComplete)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: AnimatedBuilder(
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
        borderRadius: BorderRadius.circular(20),
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
}
