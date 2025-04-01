import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:kizuna_quest/core/database/app_database.dart';
import 'package:kizuna_quest/core/database/tables/save_games_table.dart';
import 'package:kizuna_quest/utils/app_logger.dart';
import 'package:kizuna_quest/utils/constants.dart';

part 'save_game_dao.g.dart';

/// Data Access Object for SaveGames table
@DriftAccessor(tables: [SaveGames])
class SaveGameDao extends DatabaseAccessor<AppDatabase> with _$SaveGameDaoMixin {
  /// Constructor
  SaveGameDao(super.db);

  /// Get all save games
  Future<List<SaveGame>> getAllSaveGames() {
    return (select(saveGames)..orderBy([(t) => OrderingTerm(expression: t.lastSavedAt, mode: OrderingMode.desc)]))
        .get();
  }

  /// Get save game by ID
  Future<SaveGame?> getSaveGameById(int id) {
    return (select(saveGames)..where((s) => s.id.equals(id))).getSingleOrNull();
  }

  /// Get save game by slot ID
  Future<SaveGame?> getSaveGameBySlot(int slotId) {
    return (select(saveGames)..where((s) => s.slotId.equals(slotId))).getSingleOrNull();
  }

  /// Get available (empty) save slot
  Future<int?> getAvailableSaveSlot() async {
    final usedSlots =
        await (select(saveGames)..orderBy([(t) => OrderingTerm(expression: t.slotId)])).map((row) => row.slotId).get();

    // Find the first available slot from 1 to maxSaveSlots
    for (int i = 1; i <= AppConstants.maxSaveSlots; i++) {
      if (!usedSlots.contains(i)) {
        return i;
      }
    }

    // All slots are used
    return null;
  }

  /// Insert a new save game
  Future<int> insertSaveGame(SaveGamesCompanion saveGame) {
    return into(saveGames).insert(saveGame);
  }

  /// Update a save game
  Future<bool> updateSaveGame(SaveGame saveGame) {
    return update(saveGames).replace(saveGame.copyWith(
      updatedAt: DateTime.now(),
      lastSavedAt: DateTime.now(),
    ));
  }

  /// Delete a save game
  Future<int> deleteSaveGame(int id) {
    return (delete(saveGames)..where((s) => s.id.equals(id))).go();
  }

  /// Delete a save game by slot ID
  Future<int> deleteSaveGameBySlot(int slotId) {
    return (delete(saveGames)..where((s) => s.slotId.equals(slotId))).go();
  }

  /// Watch for changes to all save games
  Stream<List<SaveGame>> watchAllSaveGames() {
    return (select(saveGames)..orderBy([(t) => OrderingTerm(expression: t.lastSavedAt, mode: OrderingMode.desc)]))
        .watch();
  }

  /// Update game settings
  Future<bool> updateGameSettings(int saveId, Map<String, dynamic> settings) async {
    final saveGame = await getSaveGameById(saveId);
    if (saveGame == null) {
      return false;
    }

    final settingsJson = jsonEncode(settings);
    return updateSaveGame(saveGame.copyWith(settingsJson: settingsJson));
  }

  /// Get game settings
  Future<Map<String, dynamic>> getGameSettings(int saveId) async {
    final saveGame = await getSaveGameById(saveId);
    if (saveGame == null) {
      return {};
    }

    try {
      return jsonDecode(saveGame.settingsJson) as Map<String, dynamic>;
    } catch (e) {
      AppLogger.error('Failed to parse game settings', error: e);
      return {};
    }
  }

  /// Update play time
  Future<bool> updatePlayTime(int saveId, int additionalSeconds) async {
    final saveGame = await getSaveGameById(saveId);
    if (saveGame == null) {
      return false;
    }

    final newPlayTime = saveGame.playTimeSeconds + additionalSeconds;
    return updateSaveGame(saveGame.copyWith(playTimeSeconds: newPlayTime));
  }

  /// Create a quick save
  Future<int> createQuickSave({
    required String playerName,
    required String currentChapter,
    required String currentScene,
    required int playTimeSeconds,
    String? thumbnailPath,
    Map<String, dynamic>? settings,
  }) async {
    // Use slot 0 for quick save
    const quickSaveSlotId = 0;

    // Check if quick save exists and delete it
    await deleteSaveGameBySlot(quickSaveSlotId);

    // Create new quick save
    return insertSaveGame(SaveGamesCompanion.insert(
      slotId: quickSaveSlotId,
      playerName: playerName,
      currentChapter: currentChapter,
      currentScene: currentScene,
      playTimeSeconds: Value(playTimeSeconds),
      thumbnailPath: Value(thumbnailPath),
      settingsJson: Value(settings != null ? jsonEncode(settings) : '{}'),
    ));
  }
}
