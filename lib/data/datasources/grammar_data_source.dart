import 'package:kizuna_quest/data/datasources/json_data_source.dart';
import 'package:kizuna_quest/data/models/grammar_point_model.dart';

/// Data source for grammar points from JSON file
class GrammarDataSource extends JsonDataSource<GrammarPointModel> {
  /// Create a grammar data source
  GrammarDataSource()
      : super(
          [
            (
              asset: 'assets/data/chapter_1/grammar_data.json',
              chapter: 'chapter_1',
            ),
          ],
        );

  @override
  GrammarPointModel fromJson(Map<String, dynamic> json) {
    return GrammarPointModel(
      id: json['id'] as int,
      title: json['title'] as String,
      patternJp: json['patternJp'] as String,
      explanationEn: json['explanationEn'] as String,
      exampleJp: json['exampleJp'] as String,
      exampleEn: json['exampleEn'] as String,
      jlptLevel: json['jlptLevel'] as String,
      chapterIntroduced: json['chapterIntroduced'] as String,
    );
  }

  @override
  int getId(GrammarPointModel item) => item.id;

  @override
  String getChapter(GrammarPointModel item) => item.chapterIntroduced;

  /// Search grammar points by title, pattern or explanation
  Future<List<GrammarPointModel>> search(String query, String chapter) async {
    final lowercaseQuery = query.toLowerCase();
    final items = await getByChapter(chapter);

    return items.where((item) {
      return item.title.toLowerCase().contains(lowercaseQuery) ||
          item.patternJp.toLowerCase().contains(lowercaseQuery) ||
          item.explanationEn.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  /// Get grammar points by JLPT level
  Future<List<GrammarPointModel>> getByJlptLevel(String level, String chapter) async {
    final items = await getByChapter(chapter);
    return items.where((item) => item.jlptLevel == level).toList();
  }
}
