import 'package:equatable/equatable.dart';
import 'package:kizuna_quest/core/database/app_database.dart';

/// Domain model for a vocabulary item with unlocked status
class VocabularyModel extends Equatable {
  /// Vocabulary ID
  final int id;

  /// Japanese word/phrase
  final String wordJp;

  /// Reading in hiragana/katakana
  final String reading;

  /// English meaning/translation
  final String meaningEn;

  /// Part of speech (noun, verb, adjective, etc.)
  final String partOfSpeech;

  /// Example sentence in Japanese
  final String exampleJp;

  /// Example sentence translation in English
  final String exampleEn;

  /// JLPT level (N5-N1)
  final String jlptLevel;

  /// Comma-separated tags for categorization
  final String tags;

  /// Chapter where this vocabulary is first introduced
  final String chapterIntroduced;

  /// Whether this vocabulary item is unlocked
  final bool isUnlocked;

  /// Mastery level (0: locked, 1: learning, 2: learned, 3: mastered)
  final int masteryLevel;

  /// When this vocabulary item was first encountered
  final DateTime? unlockedAt;

  /// When this vocabulary item was last reviewed
  final DateTime? lastReviewed;

  /// Create a vocabulary model
  const VocabularyModel({
    required this.id,
    required this.wordJp,
    required this.reading,
    required this.meaningEn,
    required this.partOfSpeech,
    required this.exampleJp,
    required this.exampleEn,
    required this.jlptLevel,
    required this.tags,
    required this.chapterIntroduced,
    this.isUnlocked = false,
    this.masteryLevel = 0,
    this.unlockedAt,
    this.lastReviewed,
  });

  /// Create with unlocked status from database
  factory VocabularyModel.withUnlockedStatus(
    VocabularyModel model,
    UnlockedVocabularyItem? unlockedItem,
  ) {
    return VocabularyModel(
      id: model.id,
      wordJp: model.wordJp,
      reading: model.reading,
      meaningEn: model.meaningEn,
      partOfSpeech: model.partOfSpeech,
      exampleJp: model.exampleJp,
      exampleEn: model.exampleEn,
      jlptLevel: model.jlptLevel,
      tags: model.tags,
      chapterIntroduced: model.chapterIntroduced,
      isUnlocked: unlockedItem != null,
      masteryLevel: unlockedItem?.masteryLevel ?? 0,
      unlockedAt: unlockedItem?.unlockedAt,
      lastReviewed: unlockedItem?.lastReviewed,
    );
  }

  /// Create from map (can be used with PlayerProgressDao.getVocabularyWithStatus)
  factory VocabularyModel.fromMap(Map<String, dynamic> map) {
    final isUnlocked = map['unlocked'] as bool? ?? false;
    final masteryLevel = map['masteryLevel'] as int? ?? 0;
    final unlockedAt = map['unlockedAt'] as DateTime?;
    final lastReviewed = map['lastReviewed'] as DateTime?;

    return VocabularyModel(
      id: map['id'] as int,
      wordJp: map['wordJp'] as String,
      reading: map['reading'] as String,
      meaningEn: map['meaningEn'] as String,
      partOfSpeech: map['partOfSpeech'] as String,
      exampleJp: map['exampleJp'] as String,
      exampleEn: map['exampleEn'] as String,
      jlptLevel: map['jlptLevel'] as String,
      tags: map['tags'] as String,
      chapterIntroduced: map['chapterIntroduced'] as String,
      isUnlocked: isUnlocked,
      masteryLevel: masteryLevel,
      unlockedAt: unlockedAt,
      lastReviewed: lastReviewed,
    );
  }

  /// Get mastery level description
  String get masteryLevelName {
    switch (masteryLevel) {
      case 0:
        return 'Locked';
      case 1:
        return 'Learning';
      case 2:
        return 'Learned';
      case 3:
        return 'Mastered';
      default:
        return 'Unknown';
    }
  }

  /// Get list of tags
  List<String> get tagList => tags.split(',').map((t) => t.trim()).toList();

  /// Copy with new values
  VocabularyModel copyWith({
    int? id,
    String? wordJp,
    String? reading,
    String? meaningEn,
    String? partOfSpeech,
    String? exampleJp,
    String? exampleEn,
    String? jlptLevel,
    String? tags,
    String? chapterIntroduced,
    bool? isUnlocked,
    int? masteryLevel,
    DateTime? unlockedAt,
    DateTime? lastReviewed,
  }) {
    return VocabularyModel(
      id: id ?? this.id,
      wordJp: wordJp ?? this.wordJp,
      reading: reading ?? this.reading,
      meaningEn: meaningEn ?? this.meaningEn,
      partOfSpeech: partOfSpeech ?? this.partOfSpeech,
      exampleJp: exampleJp ?? this.exampleJp,
      exampleEn: exampleEn ?? this.exampleEn,
      jlptLevel: jlptLevel ?? this.jlptLevel,
      tags: tags ?? this.tags,
      chapterIntroduced: chapterIntroduced ?? this.chapterIntroduced,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      masteryLevel: masteryLevel ?? this.masteryLevel,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      lastReviewed: lastReviewed ?? this.lastReviewed,
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'wordJp': wordJp,
      'reading': reading,
      'meaningEn': meaningEn,
      'partOfSpeech': partOfSpeech,
      'exampleJp': exampleJp,
      'exampleEn': exampleEn,
      'jlptLevel': jlptLevel,
      'tags': tags,
      'chapterIntroduced': chapterIntroduced,
    };
  }

  @override
  List<Object?> get props => [
        id,
        wordJp,
        reading,
        meaningEn,
        partOfSpeech,
        exampleJp,
        exampleEn,
        jlptLevel,
        tags,
        chapterIntroduced,
        isUnlocked,
        masteryLevel,
        unlockedAt,
        lastReviewed,
      ];
}
