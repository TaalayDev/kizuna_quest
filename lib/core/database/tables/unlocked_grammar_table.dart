import 'package:drift/drift.dart';
import 'package:tsuzuki_connect/core/database/tables/save_games_table.dart';

/// Table definition for grammar points unlocked in each save game
@DataClassName('UnlockedGrammarPoint')
class UnlockedGrammar extends Table {
  /// Primary key
  IntColumn get id => integer().autoIncrement()();

  /// Reference to save game
  IntColumn get saveGameId =>
      integer().references(SaveGames, #id, onDelete: KeyAction.cascade, onUpdate: KeyAction.cascade)();

  /// Reference to grammar point ID (now just an integer, not a foreign key)
  IntColumn get grammarId => integer()();

  /// Whether this grammar point is mastered
  BoolColumn get isMastered => boolean().withDefault(const Constant(false))();

  /// When this grammar point was first encountered
  DateTimeColumn get unlockedAt => dateTime().withDefault(currentDateAndTime)();

  /// Creation timestamp
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Last update timestamp
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {saveGameId, grammarId}, // Each grammar point can only be unlocked once per save game
      ];
}
