import 'package:firebase_database/firebase_database.dart';
import 'package:kizuna_quest/core/utils/app_logger.dart';
import 'package:uuid/uuid.dart';

/// Service for handling user feedback and error reports
class ReportService {
  /// Firebase realtime database reference
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  /// Path for translation error reports in the database
  static const String _translationErrorsPath = 'reports/translation_errors';

  /// Path for general feedback in the database
  static const String _feedbackPath = 'reports/feedback';

  /// Singleton instance
  static final ReportService _instance = ReportService._internal();

  /// Private constructor
  ReportService._internal();

  /// Factory constructor that returns the singleton instance
  factory ReportService() => _instance;

  /// Submit a translation error report to Firebase
  ///
  /// [errorType] - The type of error (translation, grammar, ui, other)
  /// [description] - User's description of the error
  /// [context] - Where the error was found (e.g., chapter, scene, dialogue)
  /// [screenshot] - Optional base64 encoded screenshot
  Future<bool> submitTranslationError({
    required String errorType,
    required String description,
    String? context,
    String? screenshot,
  }) async {
    try {
      final reportId = const Uuid().v4();
      final timestamp = DateTime.now().toIso8601String();

      await _database.child('$_translationErrorsPath/$reportId').set({
        'id': reportId,
        'errorType': errorType,
        'description': description,
        'context': context ?? 'Not specified',
        'screenshot': screenshot,
        'timestamp': timestamp,
        'status': 'pending',
      });

      AppLogger.info('Translation error report submitted: $reportId');
      return true;
    } catch (e, stack) {
      AppLogger.error('Failed to submit translation error report', error: e, stackTrace: stack);
      return false;
    }
  }

  /// Submit general app feedback to Firebase
  ///
  /// [feedbackType] - Type of feedback (suggestion, praise, complaint, etc.)
  /// [content] - The feedback content
  /// [rating] - Optional rating (1-5)
  Future<bool> submitFeedback({
    required String feedbackType,
    required String content,
    int? rating,
  }) async {
    try {
      final feedbackId = const Uuid().v4();
      final timestamp = DateTime.now().toIso8601String();

      await _database.child('$_feedbackPath/$feedbackId').set({
        'id': feedbackId,
        'feedbackType': feedbackType,
        'content': content,
        'rating': rating,
        'timestamp': timestamp,
      });

      AppLogger.info('Feedback submitted: $feedbackId');
      return true;
    } catch (e, stack) {
      AppLogger.error('Failed to submit feedback', error: e, stackTrace: stack);
      return false;
    }
  }

  /// Get all submitted translation error reports (for admin use)
  Future<List<Map<String, dynamic>>> getTranslationErrorReports() async {
    try {
      final snapshot = await _database.child(_translationErrorsPath).get();
      final reports = <Map<String, dynamic>>[];

      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          reports.add(Map<String, dynamic>.from(value as Map));
        });
      }

      return reports;
    } catch (e, stack) {
      AppLogger.error('Failed to get translation error reports', error: e, stackTrace: stack);
      return [];
    }
  }

  /// Update the status of a translation error report (for admin use)
  Future<bool> updateReportStatus(String reportId, String status) async {
    try {
      await _database.child('$_translationErrorsPath/$reportId/status').set(status);

      AppLogger.info('Updated report $reportId status to: $status');
      return true;
    } catch (e, stack) {
      AppLogger.error('Failed to update report status', error: e, stackTrace: stack);
      return false;
    }
  }
}
