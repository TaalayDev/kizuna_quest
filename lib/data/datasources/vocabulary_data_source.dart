import 'package:tsuzuki_connect/data/datasources/json_data_source.dart';
import 'package:tsuzuki_connect/data/models/vocabulary_model.dart';

/// Data source for vocabulary items from JSON file
class VocabularyDataSource extends JsonDataSource<VocabularyModel> {
  /// Create a vocabulary data source
  VocabularyDataSource()
      : super(
          [
            (
              asset: 'assets/data/chapter_1/vocabulary_data.json',
              chapter: 'chapter_1',
            ),
          ],
        );

  @override
  VocabularyModel fromJson(Map<String, dynamic> json) {
    return VocabularyModel(
      id: json['id'] as int,
      wordJp: json['wordJp'] as String,
      reading: json['reading'] as String,
      meaningEn: json['meaningEn'] as String,
      partOfSpeech: json['partOfSpeech'] as String,
      exampleJp: json['exampleJp'] as String,
      exampleEn: json['exampleEn'] as String,
      jlptLevel: json['jlptLevel'] as String,
      tags: json['tags'] as String,
      chapterIntroduced: json['chapterIntroduced'] as String,
    );
  }

  @override
  int getId(VocabularyModel item) => item.id;

  @override
  String getChapter(VocabularyModel item) => item.chapterIntroduced;

  /// Search vocabulary by word, reading, or meaning
  Future<List<VocabularyModel>> search(String query, String chapter) async {
    final lowercaseQuery = query.toLowerCase();
    final items = await getByChapter(chapter);

    return items.where((item) {
      return item.wordJp.toLowerCase().contains(lowercaseQuery) ||
          item.reading.toLowerCase().contains(lowercaseQuery) ||
          item.meaningEn.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  /// Get vocabulary by JLPT level
  Future<List<VocabularyModel>> getByJlptLevel(String level, String chapter) async {
    final items = await getByChapter(chapter);
    return items.where((item) => item.jlptLevel == level).toList();
  }
}
