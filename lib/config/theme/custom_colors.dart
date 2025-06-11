import 'package:flutter/material.dart';

/// Custom color extension to add app-specific colors to the theme
@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.dialogBox,
    required this.dialogBoxBorder,
    required this.dialogBoxText,
    required this.nameTag,
    required this.nameTagText,
    required this.choiceButton,
    required this.choiceButtonText,
    required this.choiceButtonBorder,
    required this.choiceButtonHover,
    required this.kizunaHigh,
    required this.kizunaMedium,
    required this.kizunaLow,
    required this.vocabularyNew,
    required this.vocabularyLearned,
    required this.vocabularyMastered,
    required this.grammarPoint,
    required this.culturalNote,
  });

  final Color dialogBox;
  final Color dialogBoxBorder;
  final Color dialogBoxText;
  final Color nameTag;
  final Color nameTagText;
  final Color choiceButton;
  final Color choiceButtonText;
  final Color choiceButtonBorder;
  final Color choiceButtonHover;
  final Color kizunaHigh;
  final Color kizunaMedium;
  final Color kizunaLow;
  final Color vocabularyNew;
  final Color vocabularyLearned;
  final Color vocabularyMastered;
  final Color grammarPoint;
  final Color culturalNote;

  @override
  CustomColors copyWith({
    Color? dialogBox,
    Color? dialogBoxBorder,
    Color? dialogBoxText,
    Color? nameTag,
    Color? nameTagText,
    Color? choiceButton,
    Color? choiceButtonText,
    Color? choiceButtonBorder,
    Color? choiceButtonHover,
    Color? kizunaHigh,
    Color? kizunaMedium,
    Color? kizunaLow,
    Color? vocabularyNew,
    Color? vocabularyLearned,
    Color? vocabularyMastered,
    Color? grammarPoint,
    Color? culturalNote,
  }) {
    return CustomColors(
      dialogBox: dialogBox ?? this.dialogBox,
      dialogBoxBorder: dialogBoxBorder ?? this.dialogBoxBorder,
      dialogBoxText: dialogBoxText ?? this.dialogBoxText,
      nameTag: nameTag ?? this.nameTag,
      nameTagText: nameTagText ?? this.nameTagText,
      choiceButton: choiceButton ?? this.choiceButton,
      choiceButtonText: choiceButtonText ?? this.choiceButtonText,
      choiceButtonBorder: choiceButtonBorder ?? this.choiceButtonBorder,
      choiceButtonHover: choiceButtonHover ?? this.choiceButtonHover,
      kizunaHigh: kizunaHigh ?? this.kizunaHigh,
      kizunaMedium: kizunaMedium ?? this.kizunaMedium,
      kizunaLow: kizunaLow ?? this.kizunaLow,
      vocabularyNew: vocabularyNew ?? this.vocabularyNew,
      vocabularyLearned: vocabularyLearned ?? this.vocabularyLearned,
      vocabularyMastered: vocabularyMastered ?? this.vocabularyMastered,
      grammarPoint: grammarPoint ?? this.grammarPoint,
      culturalNote: culturalNote ?? this.culturalNote,
    );
  }

  @override
  ThemeExtension<CustomColors> lerp(
    covariant ThemeExtension<CustomColors>? other,
    double t,
  ) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      dialogBox: Color.lerp(dialogBox, other.dialogBox, t)!,
      dialogBoxBorder: Color.lerp(dialogBoxBorder, other.dialogBoxBorder, t)!,
      dialogBoxText: Color.lerp(dialogBoxText, other.dialogBoxText, t)!,
      nameTag: Color.lerp(nameTag, other.nameTag, t)!,
      nameTagText: Color.lerp(nameTagText, other.nameTagText, t)!,
      choiceButton: Color.lerp(choiceButton, other.choiceButton, t)!,
      choiceButtonText: Color.lerp(choiceButtonText, other.choiceButtonText, t)!,
      choiceButtonBorder: Color.lerp(choiceButtonBorder, other.choiceButtonBorder, t)!,
      choiceButtonHover: Color.lerp(choiceButtonHover, other.choiceButtonHover, t)!,
      kizunaHigh: Color.lerp(kizunaHigh, other.kizunaHigh, t)!,
      kizunaMedium: Color.lerp(kizunaMedium, other.kizunaMedium, t)!,
      kizunaLow: Color.lerp(kizunaLow, other.kizunaLow, t)!,
      vocabularyNew: Color.lerp(vocabularyNew, other.vocabularyNew, t)!,
      vocabularyLearned: Color.lerp(vocabularyLearned, other.vocabularyLearned, t)!,
      vocabularyMastered: Color.lerp(vocabularyMastered, other.vocabularyMastered, t)!,
      grammarPoint: Color.lerp(grammarPoint, other.grammarPoint, t)!,
      culturalNote: Color.lerp(culturalNote, other.culturalNote, t)!,
    );
  }

  Color getKizunaColor(BuildContext context, int points) {
    if (points >= 75) {
      return Colors.purple;
    } else if (points >= 50) {
      return Colors.blue;
    } else if (points >= 25) {
      return Colors.teal;
    } else {
      return Colors.white.withOpacity(0.8);
    }
  }

  Color getOnKizunaColor(BuildContext context, int points) {
    if (points >= 25) {
      return Theme.of(context).colorScheme.onPrimaryContainer;
    } else {
      return Colors.black.withOpacity(0.7);
    }
  }
}

/// Light theme custom colors
final lightCustomColors = CustomColors(
  dialogBox: const Color(0xFFF8F8F8).withOpacity(0.95),
  dialogBoxBorder: const Color(0xFF6750A4),
  dialogBoxText: const Color(0xFF1C1B1F),
  nameTag: const Color(0xFF6750A4),
  nameTagText: Colors.white,
  choiceButton: const Color(0xFFEBE5FC),
  choiceButtonText: const Color(0xFF1C1B1F),
  choiceButtonBorder: const Color(0xFF6750A4),
  choiceButtonHover: const Color(0xFFD0BCFF),
  kizunaHigh: const Color(0xFFD73BFF),
  kizunaMedium: const Color(0xFF8B51FF),
  kizunaLow: const Color(0xFF5271FF),
  vocabularyNew: const Color(0xFFFFD740),
  vocabularyLearned: const Color(0xFF80CBC4),
  vocabularyMastered: const Color(0xFF81C784),
  grammarPoint: const Color(0xFFEF5350),
  culturalNote: const Color(0xFF9575CD),
);

/// Dark theme custom colors
final darkCustomColors = CustomColors(
  dialogBox: const Color(0xFF2D2D2D).withOpacity(0.95),
  dialogBoxBorder: const Color(0xFFD0BCFF),
  dialogBoxText: const Color(0xFFF8F8F8),
  nameTag: const Color(0xFFD0BCFF),
  nameTagText: const Color(0xFF2D2D2D),
  choiceButton: const Color(0xFF413A56),
  choiceButtonText: const Color(0xFFF8F8F8),
  choiceButtonBorder: const Color(0xFFD0BCFF),
  choiceButtonHover: const Color(0xFF6750A4),
  kizunaHigh: const Color(0xFFD73BFF),
  kizunaMedium: const Color(0xFF8B51FF),
  kizunaLow: const Color(0xFF5271FF),
  vocabularyNew: const Color(0xFFFFD740),
  vocabularyLearned: const Color(0xFF80CBC4),
  vocabularyMastered: const Color(0xFF81C784),
  grammarPoint: const Color(0xFFEF5350),
  culturalNote: const Color(0xFF9575CD),
);
