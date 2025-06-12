import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:tsuzuki_connect/core/database/tables/characters_table.dart';
import 'package:tsuzuki_connect/core/database/tables/relationships_table.dart';
import 'package:tsuzuki_connect/core/database/tables/save_games_table.dart';
import 'package:tsuzuki_connect/core/database/tables/unlocked_cultural_notes_table.dart';
import 'package:tsuzuki_connect/core/database/tables/unlocked_grammar_table.dart';
import 'package:tsuzuki_connect/core/database/tables/unlocked_vocabulary_table.dart';
import 'package:tsuzuki_connect/core/utils/app_logger.dart';

import 'daos/character_dao.dart';
import 'daos/player_progress_dao.dart';
import 'daos/save_game_dao.dart';

part 'app_database.g.dart';

/// Database version - increment when schema changes
const int _databaseVersion = 1;

/// The name of the database file
const String _databaseFileName = 'kizuna_quest.db';

/// Main application database class using Drift
@DriftDatabase(
  tables: [
    Characters,
    SaveGames,
    Relationships,
    UnlockedVocabulary,
    UnlockedGrammar,
    UnlockedCulturalNotes,
  ],
  daos: [
    CharacterDao,
    SaveGameDao,
    PlayerProgressDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Create an instance of the database
  AppDatabase() : super(_openConnection());

  /// Get the database version
  @override
  int get schemaVersion => _databaseVersion;

  /// Handle database migrations when schema version is increased
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      // Handle schema changes
      onCreate: (Migrator m) async {
        AppLogger.info('Creating database tables');
        await m.createAll();

        // Seed initial data
        await _seedInitialData();
      },

      onUpgrade: (Migrator m, int from, int to) async {
        AppLogger.info('Upgrading database from $from to $to');
      },

      // Run after migrations
      beforeOpen: (details) async {
        AppLogger.info('Opening database version ${details.versionNow}');

        // Enable foreign keys
        // await customStatement('PRAGMA foreign_keys = ON');

        // // Check if we need to seed initial data (fresh install but not new creation)
        // if (details.wasCreated == false) {
        //   final countQuery = selectOnly(characters)..addColumns([countAll()]);
        //   final vocabularyCount = await countQuery.map((row) => row.read(countAll())).getSingle();
        //   if (vocabularyCount == 0) {
        //     AppLogger.info('Database exists but is empty, seeding data');
        //     await _seedInitialData();
        //   }
        // }
      },
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: kReleaseMode ? _databaseFileName : 'tsuzuki_connect_dev_3.db',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
        onResult: (result) {
          if (result.missingFeatures.isNotEmpty) {
            print(
              'Using ${result.chosenImplementation} due to unsupported '
              'browser features: ${result.missingFeatures}',
            );
          }
        },
      ),
    );
  }

  /// Seeds the database with initial data
  Future<void> _seedInitialData() async {
    AppLogger.info('Seeding initial data to database');

    // Transaction ensures all-or-nothing operations
    await transaction(() async {
      try {
        // Seed characters
        await _seedCharacters();

        AppLogger.info('Finished seeding database');
      } catch (e, stack) {
        AppLogger.error('Error seeding database', error: e, stackTrace: stack);
        rethrow; // Ensures transaction is rolled back
      }
    });
  }

  /// Seeds character data
  Future<void> _seedCharacters() async {
    AppLogger.info('Seeding characters');

    final charactersToInsert = [
      CharactersCompanion.insert(
        nameJp: 'ユキ',
        nameEn: 'Yuki',
        personality: 'Friendly classmate who loves helping international students',
        avatarPath: 'assets/images/characters/yuki/avatar.webp',
        spriteFolder: 'assets/images/characters/yuki',
      ),
      CharactersCompanion.insert(
        nameJp: '田中先生',
        nameEn: 'Tanaka-sensei',
        personality: 'Experienced Japanese language teacher with a passion for cultural exchange',
        avatarPath: 'assets/images/characters/tanaka/avatar.webp',
        spriteFolder: 'assets/images/characters/tanaka',
      ),
      CharactersCompanion.insert(
        nameJp: '佐藤',
        nameEn: 'Sato',
        personality: 'Kind shopkeeper near the school who enjoys chatting with students',
        avatarPath: 'assets/images/characters/sato/avatar.webp',
        spriteFolder: 'assets/images/characters/sato',
      ),
      CharactersCompanion.insert(
        nameEn: 'Mei',
        nameJp: 'メイ',
        personality: 'Advanced Japanese student from Korea who offers study tips',
        avatarPath: 'assets/images/characters/mei/avatar.webp',
        spriteFolder: 'assets/images/characters/mei',
      ),
      CharactersCompanion.insert(
        nameEn: 'Kenta',
        nameJp: 'ケンタ',
        personality: 'Energetic conversation partner who helps with speaking practice',
        avatarPath: 'assets/images/characters/kenta/avatar.webp',
        spriteFolder: 'assets/images/characters/kenta',
      ),
      CharactersCompanion.insert(
        nameEn: 'Nakamura',
        nameJp: '中村',
        personality: 'Gentle homestay mother who teaches daily life Japanese',
        avatarPath: 'assets/images/characters/nakamura/avatar.webp',
        spriteFolder: 'assets/images/characters/nakamura',
      ),
      CharactersCompanion.insert(
        nameEn: 'Hiroshi',
        nameJp: 'ヒロシ',
        personality: 'Local university student who organizes cultural exchange events',
        avatarPath: 'assets/images/characters/hiroshi/avatar.webp',
        spriteFolder: 'assets/images/characters/hiroshi',
      ),
    ];

    for (final character in charactersToInsert) {
      await into(characters).insert(character);
    }
  }

  /// Close the database
  @override
  Future<void> close() {
    AppLogger.info('Closing database connection');
    return super.close();
  }
}
