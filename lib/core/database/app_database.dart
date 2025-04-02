import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:kizuna_quest/core/database/tables/characters_table.dart';
import 'package:kizuna_quest/core/database/tables/relationships_table.dart';
import 'package:kizuna_quest/core/database/tables/save_games_table.dart';
import 'package:kizuna_quest/core/database/tables/unlocked_cultural_notes_table.dart';
import 'package:kizuna_quest/core/database/tables/unlocked_grammar_table.dart';
import 'package:kizuna_quest/core/database/tables/unlocked_vocabulary_table.dart';
import 'package:kizuna_quest/core/utils/app_logger.dart';

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

      // Handle version upgrades
      onUpgrade: (Migrator m, int from, int to) async {
        AppLogger.info('Upgrading database from $from to $to');

        // Add migration logic here when schema changes
        if (from < 2) {
          // Example: if (from < 2) { await m.addColumn(table, column); }
        }
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
      name: kReleaseMode ? _databaseFileName : 'kizuna_quest_dev_2.db',
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
        personality: 'Friendly and studious classmate',
        avatarPath: 'assets/images/characters/yuki/avatar.webp',
        spriteFolder: 'assets/images/characters/yuki',
      ),
      CharactersCompanion.insert(
        nameJp: '田中先生',
        nameEn: 'Tanaka-sensei',
        personality: 'Strict but fair Japanese teacher',
        avatarPath: 'assets/images/characters/tanaka/avatar.webp',
        spriteFolder: 'assets/images/characters/tanaka',
      ),
      CharactersCompanion.insert(
        nameJp: '佐藤',
        nameEn: 'Sato',
        personality: 'Friendly neighborhood shopkeeper',
        avatarPath: 'assets/images/characters/sato/avatar.webp',
        spriteFolder: 'assets/images/characters/sato',
      ),
      CharactersCompanion.insert(
        nameEn: 'Mei',
        nameJp: 'メイ',
        personality: 'Curious and knowledgeable about Japanese culture classmate',
        avatarPath: 'assets/images/characters/mei/avatar.webp',
        spriteFolder: 'assets/images/characters/mei',
      ),
      CharactersCompanion.insert(
        nameEn: 'Kenta',
        nameJp: 'ケンタ',
        personality: 'Athletic and competitive classmate',
        avatarPath: 'assets/images/characters/kenta/avatar.webp',
        spriteFolder: 'assets/images/characters/kenta',
      ),
      CharactersCompanion.insert(
        nameEn: 'Nakamura',
        nameJp: '中村',
        personality: 'A gentle elderly woman.',
        avatarPath: 'assets/images/characters/nakamura/avatar.webp',
        spriteFolder: 'assets/images/characters/nakamura',
      ),
      CharactersCompanion.insert(
        nameEn: 'Hiroshi',
        nameJp: 'ヒロシ',
        personality: 'Tour guide with a passion for history.',
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
