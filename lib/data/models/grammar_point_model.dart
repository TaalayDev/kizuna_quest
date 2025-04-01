import 'package:equatable/equatable.dart';
import 'package:kizuna_quest/core/database/app_database.dart';

/// Domain model for a grammar point with unlocked status
class GrammarPointModel extends Equatable {
  /// Grammar point ID
  final int id;

  /// Title/name of the grammar point
  final String title;

  /// Japanese grammar pattern
  final String patternJp;

  /// English explanation of the grammar point
  final String explanationEn;

  /// Example sentence in Japanese
  final String exampleJp;

  /// Example sentence translation in English
  final String exampleEn;

  /// JLPT level (N5-N1)
  final String jlptLevel;

  /// Chapter where this grammar point is first introduced
  final String chapterIntroduced;

  /// Whether this grammar point is unlocked
  final bool isUnlocked;

  /// Whether this grammar point is mastered
  final bool isMastered;

  /// When this grammar point was first encountered
  final DateTime? unlockedAt;

  /// Create a grammar point model
  const GrammarPointModel({
    required this.id,
    required this.title,
    required this.patternJp,
    required this.explanationEn,
    required this.exampleJp,
    required this.exampleEn,
    required this.jlptLevel,
    required this.chapterIntroduced,
    this.isUnlocked = false,
    this.isMastered = false,
    this.unlockedAt,
  });

  /// Create with unlocked status from database
  factory GrammarPointModel.withUnlockedStatus(
    GrammarPointModel model,
    UnlockedGrammarPoint? unlockedItem,
  ) {
    return GrammarPointModel(
      id: model.id,
      title: model.title,
      patternJp: model.patternJp,
      explanationEn: model.explanationEn,
      exampleJp: model.exampleJp,
      exampleEn: model.exampleEn,
      jlptLevel: model.jlptLevel,
      chapterIntroduced: model.chapterIntroduced,
      isUnlocked: unlockedItem != null,
      isMastered: unlockedItem?.isMastered ?? false,
      unlockedAt: unlockedItem?.unlockedAt,
    );
  }

  /// Create from map (can be used with PlayerProgressDao.getGrammarWithStatus)
  factory GrammarPointModel.fromMap(Map<String, dynamic> map) {
    final isUnlocked = map['unlocked'] as bool? ?? false;
    final isMastered = map['isMastered'] as bool? ?? false;
    final unlockedAt = map['unlockedAt'] as DateTime?;

    return GrammarPointModel(
      id: map['id'] as int,
      title: map['title'] as String,
      patternJp: map['patternJp'] as String,
      explanationEn: map['explanationEn'] as String,
      exampleJp: map['exampleJp'] as String,
      exampleEn: map['exampleEn'] as String,
      jlptLevel: map['jlptLevel'] as String,
      chapterIntroduced: map['chapterIntroduced'] as String,
      isUnlocked: isUnlocked,
      isMastered: isMastered,
      unlockedAt: unlockedAt,
    );
  }

  /// Get status description
  String get statusDescription {
    if (!isUnlocked) return 'Locked';
    if (isMastered) return 'Mastered';
    return 'Learning';
  }

  /// Copy with new values
  GrammarPointModel copyWith({
    int? id,
    String? title,
    String? patternJp,
    String? explanationEn,
    String? exampleJp,
    String? exampleEn,
    String? jlptLevel,
    String? chapterIntroduced,
    bool? isUnlocked,
    bool? isMastered,
    DateTime? unlockedAt,
  }) {
    return GrammarPointModel(
      id: id ?? this.id,
      title: title ?? this.title,
      patternJp: patternJp ?? this.patternJp,
      explanationEn: explanationEn ?? this.explanationEn,
      exampleJp: exampleJp ?? this.exampleJp,
      exampleEn: exampleEn ?? this.exampleEn,
      jlptLevel: jlptLevel ?? this.jlptLevel,
      chapterIntroduced: chapterIntroduced ?? this.chapterIntroduced,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isMastered: isMastered ?? this.isMastered,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'patternJp': patternJp,
      'explanationEn': explanationEn,
      'exampleJp': exampleJp,
      'exampleEn': exampleEn,
      'jlptLevel': jlptLevel,
      'chapterIntroduced': chapterIntroduced,
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        patternJp,
        explanationEn,
        exampleJp,
        exampleEn,
        jlptLevel,
        chapterIntroduced,
        isUnlocked,
        isMastered,
        unlockedAt,
      ];
}
