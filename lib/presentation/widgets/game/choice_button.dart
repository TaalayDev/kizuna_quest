import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kizuna_quest/config/theme/custom_colors.dart';
import 'package:kizuna_quest/data/models/dialogue_model.dart';
import 'package:kizuna_quest/core/utils/extensions.dart';

/// Widget that displays a dialogue choice button
class ChoiceButton extends StatefulWidget {
  /// The dialogue choice to display
  final DialogueChoice choice;

  /// Callback when the choice is tapped
  final VoidCallback onTap;

  /// Whether to show furigana
  final bool showFurigana;

  /// Whether the player can make this choice
  final bool canMakeChoice;

  /// Index for animation delay
  final int index;

  /// Creates a ChoiceButton widget
  const ChoiceButton({
    super.key,
    required this.choice,
    required this.onTap,
    required this.showFurigana,
    required this.canMakeChoice,
    required this.index,
  });

  @override
  State<ChoiceButton> createState() => _ChoiceButtonState();
}

class _ChoiceButtonState extends State<ChoiceButton> with SingleTickerProviderStateMixin {
  bool _isHovering = false;
  late AnimationController _hoverController;

  @override
  void initState() {
    super.initState();

    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovering = true;
        });
        _hoverController.forward();
      },
      onExit: (_) {
        setState(() {
          _isHovering = false;
        });
        _hoverController.reverse();
      },
      child: GestureDetector(
        onTap: widget.canMakeChoice ? widget.onTap : null,
        child: AnimatedBuilder(
          animation: _hoverController,
          builder: (context, child) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: widget.canMakeChoice
                    ? Color.lerp(
                        customColors.choiceButton,
                        customColors.choiceButtonHover,
                        _hoverController.value,
                      )
                    : customColors.choiceButton.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.canMakeChoice
                      ? customColors.choiceButtonBorder
                      : customColors.choiceButtonBorder.withOpacity(0.4),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1 + (_hoverController.value * 0.1)),
                    blurRadius: 4 + (_hoverController.value * 4),
                    offset: Offset(0, 2 + (_hoverController.value * 2)),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Choice meaning (what this choice communicates)
                  Text(
                    widget.choice.meaning,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: widget.canMakeChoice
                          ? customColors.choiceButtonText.withOpacity(0.7)
                          : customColors.choiceButtonText.withOpacity(0.5),
                      fontStyle: FontStyle.italic,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Japanese text
                  Text(
                    widget.choice.textJp,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: widget.canMakeChoice
                          ? customColors.choiceButtonText
                          : customColors.choiceButtonText.withOpacity(0.6),
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Furigana (if enabled and available)
                  if (widget.showFurigana && widget.choice.furiganaJp != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        widget.choice.furiganaJp!,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: widget.canMakeChoice
                              ? customColors.choiceButtonText.withOpacity(0.6)
                              : customColors.choiceButtonText.withOpacity(0.4),
                        ),
                      ),
                    ),

                  const SizedBox(height: 4),

                  // English text
                  Text(
                    widget.choice.textEn,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: widget.canMakeChoice
                          ? customColors.choiceButtonText.withOpacity(0.8)
                          : customColors.choiceButtonText.withOpacity(0.5),
                    ),
                  ),

                  // Required level indicator (if player doesn't meet the requirements)
                  if (!widget.canMakeChoice)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lock,
                            size: 16,
                            color: customColors.choiceButtonText.withOpacity(0.5),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Requires Level ${widget.choice.requiredLevel}',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: customColors.choiceButtonText.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: 100 * widget.index),
          duration: const Duration(milliseconds: 300),
        )
        .slideY(
          begin: 0.2,
          end: 0,
          delay: Duration(milliseconds: 100 * widget.index),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutQuad,
        );
  }
}
