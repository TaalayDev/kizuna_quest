import 'package:drift/drift.dart';

/// Table definition for game characters
@DataClassName('Character')
class Characters extends Table {
  /// Primary key
  IntColumn get id => integer().autoIncrement()();

  /// Character's Japanese name
  TextColumn get nameJp => text()();

  /// Character's English name
  TextColumn get nameEn => text()();

  /// Brief personality description
  TextColumn get personality => text()();

  /// Path to character avatar image
  TextColumn get avatarPath => text()();

  /// Folder containing character sprites
  TextColumn get spriteFolder => text()();

  /// Creation timestamp
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Last update timestamp
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
