import 'package:drift/drift.dart';
import 'package:tsuzuki_connect/core/database/tables/save_games_table.dart';

/// Table definition for cultural notes unlocked in each save game
@DataClassName('UnlockedCulturalNote')
class UnlockedCulturalNotes extends Table {
  /// Primary key
  IntColumn get id => integer().autoIncrement()();

  /// Reference to save game
  IntColumn get saveGameId =>
      integer().references(SaveGames, #id, onDelete: KeyAction.cascade, onUpdate: KeyAction.cascade)();

  /// Reference to cultural note ID (now just an integer, not a foreign key)
  IntColumn get culturalNoteId => integer()();

  /// Whether this cultural note has been read
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();

  /// When this cultural note was first encountered
  DateTimeColumn get unlockedAt => dateTime().withDefault(currentDateAndTime)();

  /// Creation timestamp
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Last update timestamp
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {saveGameId, culturalNoteId}, // Each cultural note can only be unlocked once per save game
      ];
}
