import 'package:drift/drift.dart';
import 'package:kizuna_quest/core/database/app_database.dart';
import 'package:kizuna_quest/core/database/tables/characters_table.dart';
import 'package:kizuna_quest/core/utils/app_logger.dart';

part 'character_dao.g.dart';

/// Data Access Object for Characters table
@DriftAccessor(tables: [Characters])
class CharacterDao extends DatabaseAccessor<AppDatabase> with _$CharacterDaoMixin {
  /// Constructor
  CharacterDao(super.db);

  /// Get all characters
  Future<List<Character>> getAllCharacters() {
    return select(characters).get();
  }

  /// Get a character by ID
  Future<Character?> getCharacterById(int id) {
    return (select(characters)..where((c) => c.id.equals(id))).getSingleOrNull();
  }

  /// Get a character by Japanese name
  Future<Character?> getCharacterByJapaneseName(String nameJp) {
    return (select(characters)..where((c) => c.nameJp.equals(nameJp))).getSingleOrNull();
  }

  /// Insert a new character
  Future<int> insertCharacter(CharactersCompanion character) {
    return into(characters).insert(character);
  }

  /// Update a character
  Future<bool> updateCharacter(Character character) {
    return update(characters).replace(character);
  }

  /// Delete a character
  Future<int> deleteCharacter(int id) {
    return (delete(characters)..where((c) => c.id.equals(id))).go();
  }

  /// Watch for changes to a specific character
  Stream<Character?> watchCharacter(int id) {
    return (select(characters)..where((c) => c.id.equals(id))).watchSingleOrNull();
  }

  /// Watch for changes to all characters
  Stream<List<Character>> watchAllCharacters() {
    return select(characters).watch();
  }
}
