import 'package:drift/drift.dart';
import 'package:kizuna_quest/core/database/app_database.dart';
import 'package:kizuna_quest/core/database/tables/characters_table.dart';
import 'package:kizuna_quest/core/database/tables/relationships_table.dart';
import 'package:kizuna_quest/core/database/tables/save_games_table.dart';
import 'package:kizuna_quest/core/database/tables/unlocked_cultural_notes_table.dart';
import 'package:kizuna_quest/core/database/tables/unlocked_grammar_table.dart';
import 'package:kizuna_quest/core/database/tables/unlocked_vocabulary_table.dart';
import 'package:kizuna_quest/core/utils/app_logger.dart';

part 'player_progress_dao.g.dart';

/// Data Access Object for player progress - manages relationships and unlocked content
@DriftAccessor(tables: [
  Relationships,
  UnlockedVocabulary,
  UnlockedGrammar,
  UnlockedCulturalNotes,
  Characters,
  SaveGames,
])
class PlayerProgressDao extends DatabaseAccessor<AppDatabase> with _$PlayerProgressDaoMixin {
  /// Constructor
  PlayerProgressDao(super.db);

  // ==================== Relationship Methods ====================

  /// Get all character relationships for a save game
  Future<List<Relationship>> getRelationshipsForSave(int saveGameId) {
    return (select(relationships)..where((r) => r.saveGameId.equals(saveGameId))).get();
  }

  /// Get a specific character relationship
  Future<Relationship?> getRelationship(int saveGameId, int characterId) {
    return (select(relationships)..where((r) => r.saveGameId.equals(saveGameId) & r.characterId.equals(characterId)))
        .getSingleOrNull();
  }

  /// Initialize relationships for a new save game - only initial character
  Future<void> initializeRelationships(int saveGameId) async {
    // Instead of initializing all characters, only add the first character
    // that the player meets in chapter 1 (assuming it's Yuki with ID 1)
    try {
      final firstCharacter = await (select(characters)..where((c) => c.id.equals(1))).getSingle();

      await into(relationships).insert(
        RelationshipsCompanion.insert(
          saveGameId: saveGameId,
          characterId: firstCharacter.id,
          kizunaPoints: const Value(0),
        ),
      );

      AppLogger.info('Initialized relationship with first character: ${firstCharacter.nameEn}');
    } catch (e, stack) {
      AppLogger.error('Failed to initialize first character relationship', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Unlock a new character when they are encountered
  Future<bool> unlockCharacter(int saveGameId, int characterId) async {
    // Check if relationship already exists
    final existing = await (select(relationships)
          ..where((r) => r.saveGameId.equals(saveGameId) & r.characterId.equals(characterId)))
        .getSingleOrNull();

    if (existing != null) {
      // Already unlocked
      return false;
    }

    // Get character info
    final character = await (select(characters)..where((c) => c.id.equals(characterId))).getSingleOrNull();
    if (character == null) {
      AppLogger.error('Tried to unlock non-existent character ID: $characterId');
      return false;
    }

    // Create new relationship
    await into(relationships).insert(
      RelationshipsCompanion.insert(
        saveGameId: saveGameId,
        characterId: characterId,
        kizunaPoints: const Value(0),
      ),
    );

    AppLogger.info('Unlocked new character: ${character.nameEn}');
    return true;
  }

  /// Update relationship points (Kizuna)
  Future<bool> updateKizunaPoints(int saveGameId, int characterId, int deltaPoints) async {
    final relationship = await getRelationship(saveGameId, characterId);
    if (relationship == null) {
      // Character not unlocked yet, unlock and set initial points
      await unlockCharacter(saveGameId, characterId);

      // Insert relationship with points
      await into(relationships).insert(
        RelationshipsCompanion.insert(
          saveGameId: saveGameId,
          characterId: characterId,
          kizunaPoints: Value(deltaPoints),
        ),
      );
      return true;
    }

    // Update existing relationship
    final newPoints = relationship.kizunaPoints + deltaPoints;
    return update(relationships).replace(
      relationship.copyWith(
        kizunaPoints: newPoints,
        updatedAt: DateTime.now(),
      ),
    );
  }

  // Rest of the code remains the same...
  // (The other methods for vocabulary, grammar, cultural notes, etc.)

  /// Get character with relationship for a save game
  Future<List<Map<String, dynamic>>> getCharactersWithRelationships(int saveGameId) async {
    // Join characters and relationships tables
    final query = select(characters).join([
      leftOuterJoin(
        relationships,
        relationships.characterId.equalsExp(characters.id) & relationships.saveGameId.equals(saveGameId),
      ),
    ]);

    // Execute query
    final rows = await query.get();

    // Map results
    return rows.map((row) {
      final character = row.readTable(characters);
      final relationship = row.readTableOrNull(relationships);

      return {
        'character': character,
        'relationship': relationship,
        'kizunaPoints': relationship?.kizunaPoints ?? 0,
      };
    }).toList();
  }

  // ==================== Vocabulary Methods ====================

  /// Get all unlocked vocabulary for a save game
  Future<List<UnlockedVocabularyItem>> getUnlockedVocabulary(int saveGameId) {
    return (select(unlockedVocabulary)..where((uv) => uv.saveGameId.equals(saveGameId))).get();
  }

  /// Unlock a vocabulary item for a save game
  Future<int> unlockVocabulary(int saveGameId, int vocabularyId) async {
    // Check if already unlocked
    final existing = await (select(unlockedVocabulary)
          ..where((uv) => uv.saveGameId.equals(saveGameId) & uv.vocabularyId.equals(vocabularyId)))
        .getSingleOrNull();

    if (existing != null) {
      // Already unlocked, return existing ID
      return existing.id;
    }

    AppLogger.info('Unlocking vocabulary item: $vocabularyId for save $saveGameId');

    // Unlock new vocabulary
    return into(unlockedVocabulary).insert(
      UnlockedVocabularyCompanion.insert(
        saveGameId: saveGameId,
        vocabularyId: vocabularyId,
        masteryLevel: const Value(1), // Initial mastery level (learning)
      ),
    );
  }

  /// Update vocabulary mastery level
  Future<bool> updateVocabularyMastery(int saveGameId, int vocabularyId, int masteryLevel) async {
    final unlocked = await (select(unlockedVocabulary)
          ..where((uv) => uv.saveGameId.equals(saveGameId) & uv.vocabularyId.equals(vocabularyId)))
        .getSingleOrNull();

    if (unlocked == null) {
      // Not unlocked yet, unlock with the specified mastery level
      await into(unlockedVocabulary).insert(
        UnlockedVocabularyCompanion.insert(
          saveGameId: saveGameId,
          vocabularyId: vocabularyId,
          masteryLevel: Value(masteryLevel),
        ),
      );
      return true;
    }

    // Update existing mastery level
    return update(unlockedVocabulary).replace(
      unlocked.copyWith(
        masteryLevel: masteryLevel,
        lastReviewed: Value(DateTime.now()),
        updatedAt: DateTime.now(),
      ),
    );
  }

  // ==================== Grammar Methods ====================

  /// Get all unlocked grammar points for a save game
  Future<List<UnlockedGrammarPoint>> getUnlockedGrammar(int saveGameId) {
    return (select(unlockedGrammar)..where((ug) => ug.saveGameId.equals(saveGameId))).get();
  }

  /// Unlock a grammar point for a save game
  Future<int> unlockGrammar(int saveGameId, int grammarId) async {
    // Check if already unlocked
    final existing = await (select(unlockedGrammar)
          ..where((ug) => ug.saveGameId.equals(saveGameId) & ug.grammarId.equals(grammarId)))
        .getSingleOrNull();

    if (existing != null) {
      // Already unlocked, return existing ID
      return existing.id;
    }

    AppLogger.info('Unlocking grammar point: $grammarId for save $saveGameId');

    // Unlock new grammar point
    return into(unlockedGrammar).insert(
      UnlockedGrammarCompanion.insert(
        saveGameId: saveGameId,
        grammarId: grammarId,
      ),
    );
  }

  /// Update grammar mastery status
  Future<bool> updateGrammarMastery(int saveGameId, int grammarId, bool isMastered) async {
    final unlocked = await (select(unlockedGrammar)
          ..where((ug) => ug.saveGameId.equals(saveGameId) & ug.grammarId.equals(grammarId)))
        .getSingleOrNull();

    if (unlocked == null) {
      // Not unlocked yet, unlock with the specified mastery status
      await into(unlockedGrammar).insert(
        UnlockedGrammarCompanion.insert(
          saveGameId: saveGameId,
          grammarId: grammarId,
          isMastered: Value(isMastered),
        ),
      );
      return true;
    }

    // Update existing mastery status
    return update(unlockedGrammar).replace(
      unlocked.copyWith(
        isMastered: isMastered,
        updatedAt: DateTime.now(),
      ),
    );
  }

  // ==================== Cultural Notes Methods ====================

  /// Get all unlocked cultural notes for a save game
  Future<List<UnlockedCulturalNote>> getUnlockedCulturalNotes(int saveGameId) {
    return (select(unlockedCulturalNotes)..where((ucn) => ucn.saveGameId.equals(saveGameId))).get();
  }

  /// Unlock a cultural note for a save game
  Future<int> unlockCulturalNote(int saveGameId, int culturalNoteId) async {
    // Check if already unlocked
    final existing = await (select(unlockedCulturalNotes)
          ..where((ucn) => ucn.saveGameId.equals(saveGameId) & ucn.culturalNoteId.equals(culturalNoteId)))
        .getSingleOrNull();

    if (existing != null) {
      // Already unlocked, return existing ID
      return existing.id;
    }

    AppLogger.info('Unlocking cultural note: $culturalNoteId for save $saveGameId');

    // Unlock new cultural note
    return into(unlockedCulturalNotes).insert(
      UnlockedCulturalNotesCompanion.insert(
        saveGameId: saveGameId,
        culturalNoteId: culturalNoteId,
      ),
    );
  }

  /// Mark cultural note as read
  Future<bool> markCulturalNoteAsRead(int saveGameId, int culturalNoteId) async {
    final unlocked = await (select(unlockedCulturalNotes)
          ..where((ucn) => ucn.saveGameId.equals(saveGameId) & ucn.culturalNoteId.equals(culturalNoteId)))
        .getSingleOrNull();

    if (unlocked == null) {
      // Not unlocked yet, unlock and mark as read
      await into(unlockedCulturalNotes).insert(
        UnlockedCulturalNotesCompanion.insert(
          saveGameId: saveGameId,
          culturalNoteId: culturalNoteId,
          isRead: const Value(true),
        ),
      );
      return true;
    }

    // Update existing read status
    return update(unlockedCulturalNotes).replace(
      unlocked.copyWith(
        isRead: true,
        updatedAt: DateTime.now(),
      ),
    );
  }
}
