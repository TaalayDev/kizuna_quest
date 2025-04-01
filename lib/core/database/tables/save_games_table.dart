import 'package:drift/drift.dart';

/// Table definition for save game slots
@DataClassName('SaveGame')
class SaveGames extends Table {
  /// Primary key
  IntColumn get id => integer().autoIncrement()();

  /// Save slot number (1-10)
  IntColumn get slotId => integer()();

  /// Player's chosen name
  TextColumn get playerName => text()();

  /// Current chapter ID
  TextColumn get currentChapter => text()();

  /// Current scene ID within the chapter
  TextColumn get currentScene => text()();

  /// Total play time in seconds
  IntColumn get playTimeSeconds => integer().withDefault(const Constant(0))();

  /// Last time the game was saved
  DateTimeColumn get lastSavedAt => dateTime().withDefault(currentDateAndTime)();

  /// Path to save thumbnail image
  TextColumn get thumbnailPath => text().nullable()();

  /// Game settings as JSON string
  TextColumn get settingsJson => text().withDefault(const Constant('{}'))();

  /// Creation timestamp
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Last update timestamp
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {slotId}, // Each slot ID must be unique
      ];
}
