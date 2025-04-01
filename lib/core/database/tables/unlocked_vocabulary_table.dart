import 'package:drift/drift.dart';
import 'package:kizuna_quest/core/database/tables/save_games_table.dart';

/// Table definition for vocabulary items unlocked in each save game
@DataClassName('UnlockedVocabularyItem')
class UnlockedVocabulary extends Table {
  /// Primary key
  IntColumn get id => integer().autoIncrement()();

  /// Reference to save game
  IntColumn get saveGameId =>
      integer().references(SaveGames, #id, onDelete: KeyAction.cascade, onUpdate: KeyAction.cascade)();

  /// Reference to vocabulary item ID (now just an integer, not a foreign key)
  IntColumn get vocabularyId => integer()();

  /// Mastery level (0: not learned, 1: learning, 2: learned, 3: mastered)
  IntColumn get masteryLevel => integer().withDefault(const Constant(0))();

  /// When this vocabulary item was first encountered
  DateTimeColumn get unlockedAt => dateTime().withDefault(currentDateAndTime)();

  /// When this vocabulary item was last reviewed
  DateTimeColumn get lastReviewed => dateTime().nullable()();

  /// Creation timestamp
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Last update timestamp
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {saveGameId, vocabularyId}, // Each vocabulary item can only be unlocked once per save game
      ];
}
