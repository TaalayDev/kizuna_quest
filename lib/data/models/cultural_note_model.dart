import 'package:equatable/equatable.dart';
import 'package:tsuzuki_connect/core/database/app_database.dart';

/// Domain model for a cultural note with unlocked status
class CulturalNoteModel extends Equatable {
  /// Cultural note ID
  final int id;

  /// Title of the cultural note
  final String title;

  /// Content/text of the cultural note
  final String content;

  /// Category of the cultural note (e.g., etiquette, food, traditions)
  final String category;

  /// Chapter where this cultural note is first introduced
  final String chapterIntroduced;

  /// Whether this cultural note is unlocked
  final bool isUnlocked;

  /// Whether this cultural note has been read
  final bool isRead;

  /// When this cultural note was first encountered
  final DateTime? unlockedAt;

  /// Create a cultural note model
  const CulturalNoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.chapterIntroduced,
    this.isUnlocked = false,
    this.isRead = false,
    this.unlockedAt,
  });

  /// Create from unlocked info from database
  factory CulturalNoteModel.withUnlockedStatus(
    CulturalNoteModel model,
    UnlockedCulturalNote? unlockedItem,
  ) {
    return CulturalNoteModel(
      id: model.id,
      title: model.title,
      content: model.content,
      category: model.category,
      chapterIntroduced: model.chapterIntroduced,
      isUnlocked: unlockedItem != null,
      isRead: unlockedItem?.isRead ?? false,
      unlockedAt: unlockedItem?.unlockedAt,
    );
  }

  /// Create from map (can be used with PlayerProgressDao.getCulturalNotesWithStatus)
  factory CulturalNoteModel.fromMap(Map<String, dynamic> map) {
    final isUnlocked = map['unlocked'] as bool? ?? false;
    final isRead = map['isRead'] as bool? ?? false;
    final unlockedAt = map['unlockedAt'] as DateTime?;

    return CulturalNoteModel(
      id: map['id'] as int,
      title: map['title'] as String,
      content: map['content'] as String,
      category: map['category'] as String,
      chapterIntroduced: map['chapterIntroduced'] as String,
      isUnlocked: isUnlocked,
      isRead: isRead,
      unlockedAt: unlockedAt,
    );
  }

  /// Get status description
  String get statusDescription {
    if (!isUnlocked) return 'Locked';
    if (isRead) return 'Read';
    return 'New';
  }

  /// Get abbreviated content (first 100 characters)
  String get abbreviatedContent {
    if (content.length <= 100) return content;
    return '${content.substring(0, 97)}...';
  }

  /// Copy with new values
  CulturalNoteModel copyWith({
    int? id,
    String? title,
    String? content,
    String? category,
    String? chapterIntroduced,
    bool? isUnlocked,
    bool? isRead,
    DateTime? unlockedAt,
  }) {
    return CulturalNoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      chapterIntroduced: chapterIntroduced ?? this.chapterIntroduced,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isRead: isRead ?? this.isRead,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'chapterIntroduced': chapterIntroduced,
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        category,
        chapterIntroduced,
        isUnlocked,
        isRead,
        unlockedAt,
      ];
}
