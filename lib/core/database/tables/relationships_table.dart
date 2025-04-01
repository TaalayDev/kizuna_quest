import 'package:drift/drift.dart';
import 'package:kizuna_quest/core/database/tables/characters_table.dart';
import 'package:kizuna_quest/core/database/tables/save_games_table.dart';

/// Table definition for character relationship levels (Kizuna)
@DataClassName('Relationship')
class Relationships extends Table {
  /// Primary key
  IntColumn get id => integer().autoIncrement()();

  /// Reference to save game
  IntColumn get saveGameId =>
      integer().references(SaveGames, #id, onDelete: KeyAction.cascade, onUpdate: KeyAction.cascade)();

  /// Reference to character
  IntColumn get characterId =>
      integer().references(Characters, #id, onDelete: KeyAction.cascade, onUpdate: KeyAction.cascade)();

  /// Relationship points (Kizuna)
  IntColumn get kizunaPoints => integer().withDefault(const Constant(0))();

  /// Creation timestamp
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Last update timestamp
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {saveGameId, characterId}, // Each character can only have one relationship per save game
      ];
}
