import 'package:tsuzuki_connect/data/datasources/json_data_source.dart';
import 'package:tsuzuki_connect/data/models/cultural_note_model.dart';

/// Data source for cultural notes from JSON file
class CulturalNotesDataSource extends JsonDataSource<CulturalNoteModel> {
  /// Create a cultural notes data source
  CulturalNotesDataSource()
      : super(
          [
            (
              asset: 'assets/data/chapter_1/cultural_notes_data.json',
              chapter: 'chapter_1',
            ),
          ],
        );

  @override
  CulturalNoteModel fromJson(Map<String, dynamic> json) {
    return CulturalNoteModel(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      category: json['category'] as String,
      chapterIntroduced: json['chapterIntroduced'] as String,
    );
  }

  @override
  int getId(CulturalNoteModel item) => item.id;

  @override
  String getChapter(CulturalNoteModel item) => item.chapterIntroduced;

  /// Search cultural notes by title or content
  Future<List<CulturalNoteModel>> search(String query) async {
    final lowercaseQuery = query.toLowerCase();
    final items = await getAll();

    return items.where((item) {
      return item.title.toLowerCase().contains(lowercaseQuery) || item.content.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  /// Get cultural notes by category
  Future<List<CulturalNoteModel>> getByCategory(String category) async {
    final items = await getAll();
    return items.where((item) => item.category == category).toList();
  }
}
