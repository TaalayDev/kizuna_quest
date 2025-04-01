import 'package:equatable/equatable.dart';

/// Domain model for player's overall game progress statistics
class GameProgressModel extends Equatable {
  /// Vocabulary progress statistics
  final VocabularyProgressStats vocabularyStats;

  /// Grammar progress statistics
  final GrammarProgressStats grammarStats;

  /// Cultural notes progress statistics
  final CulturalNotesProgressStats culturalNotesStats;

  /// Relationship progress statistics
  final RelationshipProgressStats relationshipStats;

  /// Overall progress percentage (0-100)
  final double totalProgressPercentage;

  /// Create a game progress model
  const GameProgressModel({
    required this.vocabularyStats,
    required this.grammarStats,
    required this.culturalNotesStats,
    required this.relationshipStats,
    required this.totalProgressPercentage,
  });

  /// Create from statistics map (from PlayerProgressDao.getProgressStatistics)
  factory GameProgressModel.fromMap(Map<String, dynamic> statsMap) {
    final vocabMap = statsMap['vocabulary'] as Map<String, dynamic>;
    final grammarMap = statsMap['grammar'] as Map<String, dynamic>;
    final culturalNotesMap = statsMap['culturalNotes'] as Map<String, dynamic>;
    final relationshipMap = statsMap['relationships'] as Map<String, dynamic>;

    return GameProgressModel(
      vocabularyStats: VocabularyProgressStats.fromMap(vocabMap),
      grammarStats: GrammarProgressStats.fromMap(grammarMap),
      culturalNotesStats: CulturalNotesProgressStats.fromMap(culturalNotesMap),
      relationshipStats: RelationshipProgressStats.fromMap(relationshipMap),
      totalProgressPercentage: statsMap['totalProgress'] as double? ?? 0.0,
    );
  }

  /// Get letter grade based on total progress
  String get progressGrade {
    if (totalProgressPercentage >= 90) return 'A';
    if (totalProgressPercentage >= 80) return 'B';
    if (totalProgressPercentage >= 70) return 'C';
    if (totalProgressPercentage >= 60) return 'D';
    return 'F';
  }

  /// Get a map of all progress stats
  Map<String, dynamic> toMap() {
    return {
      'vocabulary': vocabularyStats.toMap(),
      'grammar': grammarStats.toMap(),
      'culturalNotes': culturalNotesStats.toMap(),
      'relationships': relationshipStats.toMap(),
      'totalProgress': totalProgressPercentage,
    };
  }

  @override
  List<Object> get props => [
        vocabularyStats,
        grammarStats,
        culturalNotesStats,
        relationshipStats,
        totalProgressPercentage,
      ];
}

/// Domain model for vocabulary progress statistics
class VocabularyProgressStats extends Equatable {
  /// Total number of vocabulary items in the game
  final int total;

  /// Number of unlocked vocabulary items
  final int unlocked;

  /// Number of vocabulary items in "learning" state
  final int learning;

  /// Number of vocabulary items in "learned" state
  final int learned;

  /// Number of vocabulary items in "mastered" state
  final int mastered;

  /// Progress percentage (0-100)
  final double progressPercentage;

  /// Create vocabulary progress stats
  const VocabularyProgressStats({
    required this.total,
    required this.unlocked,
    required this.learning,
    required this.learned,
    required this.mastered,
    required this.progressPercentage,
  });

  /// Create from map
  factory VocabularyProgressStats.fromMap(Map<String, dynamic> map) {
    return VocabularyProgressStats(
      total: map['total'] as int? ?? 0,
      unlocked: map['unlocked'] as int? ?? 0,
      learning: map['learning'] as int? ?? 0,
      learned: map['learned'] as int? ?? 0,
      mastered: map['mastered'] as int? ?? 0,
      progressPercentage: map['progressPercentage'] as double? ?? 0.0,
    );
  }

  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'total': total,
      'unlocked': unlocked,
      'learning': learning,
      'learned': learned,
      'mastered': mastered,
      'progressPercentage': progressPercentage,
    };
  }

  @override
  List<Object> get props => [
        total,
        unlocked,
        learning,
        learned,
        mastered,
        progressPercentage,
      ];
}

/// Domain model for grammar progress statistics
class GrammarProgressStats extends Equatable {
  /// Total number of grammar points in the game
  final int total;

  /// Number of unlocked grammar points
  final int unlocked;

  /// Number of mastered grammar points
  final int mastered;

  /// Progress percentage (0-100)
  final double progressPercentage;

  /// Create grammar progress stats
  const GrammarProgressStats({
    required this.total,
    required this.unlocked,
    required this.mastered,
    required this.progressPercentage,
  });

  /// Create from map
  factory GrammarProgressStats.fromMap(Map<String, dynamic> map) {
    return GrammarProgressStats(
      total: map['total'] as int? ?? 0,
      unlocked: map['unlocked'] as int? ?? 0,
      mastered: map['mastered'] as int? ?? 0,
      progressPercentage: map['progressPercentage'] as double? ?? 0.0,
    );
  }

  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'total': total,
      'unlocked': unlocked,
      'mastered': mastered,
      'progressPercentage': progressPercentage,
    };
  }

  @override
  List<Object> get props => [
        total,
        unlocked,
        mastered,
        progressPercentage,
      ];
}

/// Domain model for cultural notes progress statistics
class CulturalNotesProgressStats extends Equatable {
  /// Total number of cultural notes in the game
  final int total;

  /// Number of unlocked cultural notes
  final int unlocked;

  /// Number of read cultural notes
  final int read;

  /// Progress percentage (0-100)
  final double progressPercentage;

  /// Create cultural notes progress stats
  const CulturalNotesProgressStats({
    required this.total,
    required this.unlocked,
    required this.read,
    required this.progressPercentage,
  });

  /// Create from map
  factory CulturalNotesProgressStats.fromMap(Map<String, dynamic> map) {
    return CulturalNotesProgressStats(
      total: map['total'] as int? ?? 0,
      unlocked: map['unlocked'] as int? ?? 0,
      read: map['read'] as int? ?? 0,
      progressPercentage: map['progressPercentage'] as double? ?? 0.0,
    );
  }

  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'total': total,
      'unlocked': unlocked,
      'read': read,
      'progressPercentage': progressPercentage,
    };
  }

  @override
  List<Object> get props => [
        total,
        unlocked,
        read,
        progressPercentage,
      ];
}

/// Domain model for relationship progress statistics
class RelationshipProgressStats extends Equatable {
  /// Total number of characters in the game
  final int totalCharacters;

  /// Number of low-level relationships (0-25 points)
  final int lowRelationships;

  /// Number of medium-level relationships (26-50 points)
  final int mediumRelationships;

  /// Number of high-level relationships (51+ points)
  final int highRelationships;

  /// Average relationship points across all characters
  final double averagePoints;

  /// Create relationship progress stats
  const RelationshipProgressStats({
    required this.totalCharacters,
    required this.lowRelationships,
    required this.mediumRelationships,
    required this.highRelationships,
    required this.averagePoints,
  });

  /// Create from map
  factory RelationshipProgressStats.fromMap(Map<String, dynamic> map) {
    return RelationshipProgressStats(
      totalCharacters: map['totalCharacters'] as int? ?? 0,
      lowRelationships: map['lowRelationships'] as int? ?? 0,
      mediumRelationships: map['mediumRelationships'] as int? ?? 0,
      highRelationships: map['highRelationships'] as int? ?? 0,
      averagePoints: map['averagePoints'] as double? ?? 0.0,
    );
  }

  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'totalCharacters': totalCharacters,
      'lowRelationships': lowRelationships,
      'mediumRelationships': mediumRelationships,
      'highRelationships': highRelationships,
      'averagePoints': averagePoints,
    };
  }

  @override
  List<Object> get props => [
        totalCharacters,
        lowRelationships,
        mediumRelationships,
        highRelationships,
        averagePoints,
      ];
}
