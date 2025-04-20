import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kizuna_quest/core/database/app_database.dart';
import 'package:kizuna_quest/data/repositories/game_repository.dart';
import 'package:kizuna_quest/core/utils/app_logger.dart';
import 'package:kizuna_quest/data/datasources/vocabulary_data_source.dart';
import 'package:kizuna_quest/data/datasources/grammar_data_source.dart';
import 'package:kizuna_quest/data/datasources/cultural_notes_data_source.dart';

import '../core/services/settings_service.dart';
import '../data/models/character_model.dart';
import '../data/models/cultural_note_model.dart';
import '../data/models/dialogue_model.dart';
import '../data/models/game_progress_model.dart';
import '../data/models/grammar_point_model.dart';
import '../data/models/save_game_model.dart';
import '../data/models/vocabulary_model.dart';

/// Provider for the AppDatabase
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();

  // Dispose the database when the provider is disposed
  ref.onDispose(() async {
    AppLogger.info('Closing database connection');
    await db.close();
  });

  return db;
});

/// Provider for the VocabularyDataSource
final vocabularyDataSourceProvider = Provider<VocabularyDataSource>((ref) {
  return VocabularyDataSource();
});

/// Provider for the GrammarDataSource
final grammarDataSourceProvider = Provider<GrammarDataSource>((ref) {
  return GrammarDataSource();
});

/// Provider for the CulturalNotesDataSource
final culturalNotesDataSourceProvider = Provider<CulturalNotesDataSource>((ref) {
  return CulturalNotesDataSource();
});

/// Provider for the GameRepository
final gameRepositoryProvider = Provider<GameRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final vocabularyDataSource = ref.watch(vocabularyDataSourceProvider);
  final grammarDataSource = ref.watch(grammarDataSourceProvider);
  final culturalNotesDataSource = ref.watch(culturalNotesDataSourceProvider);

  final repository = GameRepository(db, vocabularyDataSource, grammarDataSource, culturalNotesDataSource);

  // Dispose the repository when the provider is disposed
  ref.onDispose(() async {
    AppLogger.info('Disposing game repository');
    await repository.dispose();
  });

  return repository;
});

class ActiveSaveIdNotifier extends StateNotifier<int?> {
  ActiveSaveIdNotifier() : super(null) {
    _loadActiveSaveId();
  }

  /// Load the saved active save ID from preferences
  Future<void> _loadActiveSaveId() async {
    try {
      final savedId = SettingsService.getActiveSaveId();
      state = savedId;
      AppLogger.info('Loaded active save ID: $savedId');
    } catch (e, stack) {
      AppLogger.error('Failed to load active save ID', error: e, stackTrace: stack);
    }
  }

  /// Set the active save ID and save to preferences
  Future<void> setActiveSaveId(int? saveId) async {
    try {
      state = saveId;
      await SettingsService.setActiveSaveId(saveId);
      AppLogger.info('Set active save ID: $saveId');
    } catch (e, stack) {
      AppLogger.error('Failed to save active save ID', error: e, stackTrace: stack);
    }
  }
}

/// Provider for the current active save game ID
final activeSaveIdProvider = StateNotifierProvider<ActiveSaveIdNotifier, int?>((ref) {
  return ActiveSaveIdNotifier();
});

/// Provider for watching the current active save game
final activeSaveGameProvider = StreamProvider((ref) {
  final gameRepository = ref.watch(gameRepositoryProvider);
  final activeSaveId = ref.watch(activeSaveIdProvider);

  if (activeSaveId == null) {
    return Stream.value(null);
  }

  return gameRepository.watchAllSaveGames().map((saveGames) {
    return saveGames.firstWhere(
      (save) => save.id == activeSaveId,
      orElse: () {
        // If the save game is not found, clear the active save ID
        ref.read(activeSaveIdProvider.notifier).setActiveSaveId(null);
        return throw StateError('Active save game not found');
      },
    );
  });
});

/// Provider for character relationships in the active save
final characterRelationshipsProvider = StreamProvider<List<CharacterModel>>((ref) {
  final gameRepository = ref.watch(gameRepositoryProvider);
  final activeSaveId = ref.watch(activeSaveIdProvider);

  if (activeSaveId == null) {
    return Stream.value(<CharacterModel>[]);
  }

  return gameRepository.getCharactersWithRelationships(activeSaveId);
});

final allCharactersProvider = FutureProvider<List<CharacterModel>>((ref) async {
  final gameRepository = ref.watch(gameRepositoryProvider);
  return gameRepository.getAllCharacters();
});

/// Provider for vocabulary with status in the active save
final vocabularyWithStatusProvider = FutureProvider.autoDispose<List<VocabularyModel>>((ref) {
  final gameRepository = ref.watch(gameRepositoryProvider);
  final activeSaveId = ref.watch(activeSaveIdProvider);

  if (activeSaveId == null) {
    return <VocabularyModel>[];
  }

  return gameRepository.getVocabularyWithStatus(activeSaveId);
});

/// Provider for grammar points with status in the active save
final grammarWithStatusProvider = FutureProvider.autoDispose<List<GrammarPointModel>>((ref) {
  final gameRepository = ref.watch(gameRepositoryProvider);
  final activeSaveId = ref.watch(activeSaveIdProvider);

  if (activeSaveId == null) {
    return <GrammarPointModel>[];
  }

  return gameRepository.getGrammarWithStatus(activeSaveId);
});

/// Provider for cultural notes with status in the active save
final culturalNotesWithStatusProvider = FutureProvider.autoDispose<List<CulturalNoteModel>>((ref) {
  final gameRepository = ref.watch(gameRepositoryProvider);
  final activeSaveId = ref.watch(activeSaveIdProvider);

  if (activeSaveId == null) {
    return <CulturalNoteModel>[];
  }

  return gameRepository.getCulturalNotesWithStatus(activeSaveId);
});

/// Provider for overall game progress in the active save
final gameProgressProvider = FutureProvider.autoDispose<GameProgressModel?>((ref) async {
  final gameRepository = ref.watch(gameRepositoryProvider);
  final activeSaveId = ref.watch(activeSaveIdProvider);

  if (activeSaveId == null) {
    return null;
  }

  return gameRepository.getGameProgress(activeSaveId);
});

/// Provider for all available chapters
final allChaptersProvider = FutureProvider.autoDispose<List<GameChapter>>((ref) {
  final gameRepository = ref.watch(gameRepositoryProvider);
  return gameRepository.getAllChapters();
});

/// Provider for the current chapter
final currentChapterProvider = FutureProvider.family<dynamic, String>((ref, chapterId) {
  final gameRepository = ref.watch(gameRepositoryProvider);
  return gameRepository.loadChapter(chapterId);
});

/// Provider for a specific scene
final sceneProvider = FutureProvider.family<dynamic, (String, String)>((ref, params) {
  final gameRepository = ref.watch(gameRepositoryProvider);
  final (chapterId, sceneId) = params;
  return gameRepository.loadScene(chapterId, sceneId);
});

final allSaveGamesProvider = StreamProvider.autoDispose<List<SaveGameModel>>((ref) {
  final gameRepository = ref.watch(gameRepositoryProvider);
  return gameRepository.getAllSaveGames().map((saveGames) {
    // Sort save games by last saved date
    saveGames.sort((a, b) => b.lastSavedAt.compareTo(a.lastSavedAt));
    return saveGames;
  });
});
