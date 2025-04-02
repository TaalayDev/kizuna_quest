import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:kizuna_quest/core/utils/app_logger.dart';

/// Base abstract class for data sources that read from JSON files in the assets directory
abstract class JsonDataSource<T> {
  /// Asset file path, e.g. 'assets/data/vocabulary_data.json'
  final List<({String asset, String chapter})> assetPaths;

  /// Constructor
  JsonDataSource(this.assetPaths);

  /// Get all items from the JSON file
  Future<List<T>> getAll({
    String? chapter,
  }) async {
    try {
      final result = <T>[];
      for (final assetPath in assetPaths) {
        if (chapter == null || assetPath.chapter == chapter) {
          final items = await _loadJson(assetPath.asset);
          result.addAll(items);
        }
      }
      return result;
    } catch (e, stack) {
      AppLogger.error('Failed to load JSON data from $assetPaths', error: e, stackTrace: stack);
      return [];
    }
  }

  /// Load JSON data from the asset file
  Future<List<T>> _loadJson(String assetPath) async {
    try {
      final jsonString = await rootBundle.loadString(assetPath);
      final jsonList = json.decode(jsonString) as List<dynamic>;
      return jsonList.map((item) => fromJson(item as Map<String, dynamic>)).toList();
    } catch (e, stack) {
      AppLogger.error('Failed to load JSON data from $assetPath', error: e, stackTrace: stack);
      return [];
    }
  }

  /// Get a single item by ID from the JSON file
  Future<T?> getById(int id, String chapter) async {
    try {
      final items = await getByChapter(chapter);
      return items.firstWhere((item) => getId(item) == id, orElse: () => null as T);
    } catch (e, stack) {
      AppLogger.error('Failed to get item with ID $id from $assetPaths', error: e, stackTrace: stack);
      return null;
    }
  }

  /// Get all items from a specific chapter
  Future<List<T>> getByChapter(String chapter) async {
    try {
      final result = <T>[];
      for (final assetPath in assetPaths) {
        if (assetPath.chapter == chapter) {
          final items = await _loadJson(assetPath.asset);
          result.addAll(items);
        }
      }

      return result;
    } catch (e, stack) {
      AppLogger.error('Failed to get items from chapter $chapter', error: e);
      return [];
    }
  }

  /// Create an object from JSON
  T fromJson(Map<String, dynamic> json);

  /// Get ID from an object (for searching)
  int getId(T item);

  /// Get chapter from an object (for filtering)
  String getChapter(T item);
}
