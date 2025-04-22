import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tsuzuki_connect/core/utils/app_logger.dart';
import 'package:uuid/uuid.dart';

/// Service for handling user feedback and error reports using Firestore
class ReportService {
  /// Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Collection for translation error reports
  static const String _translationErrorsCollection = 'translation_errors';

  /// Collection for general feedback
  static const String _feedbackCollection = 'feedback';

  /// Singleton instance
  static final ReportService _instance = ReportService._internal();

  /// Private constructor
  ReportService._internal();

  /// Factory constructor that returns the singleton instance
  factory ReportService() => _instance;

  /// Submit a translation error report to Firestore
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
      print('Submitting translation error report...');
      final reportId = const Uuid().v4();
      final timestamp = Timestamp.now();

      await _firestore.collection(_translationErrorsCollection).doc(reportId).set({
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

  /// Submit general app feedback to Firestore
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
      final timestamp = Timestamp.now();

      await _firestore.collection(_feedbackCollection).doc(feedbackId).set({
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
      final snapshot = await _firestore.collection(_translationErrorsCollection).get();
      final reports = <Map<String, dynamic>>[];

      for (var doc in snapshot.docs) {
        reports.add(doc.data());
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
      await _firestore.collection(_translationErrorsCollection).doc(reportId).update({'status': status});

      AppLogger.info('Updated report $reportId status to: $status');
      return true;
    } catch (e, stack) {
      AppLogger.error('Failed to update report status', error: e, stackTrace: stack);
      return false;
    }
  }

  /// Get recent translation error reports with pagination (for admin use)
  Future<List<Map<String, dynamic>>> getRecentTranslationErrors({
    int limit = 20,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      Query query =
          _firestore.collection(_translationErrorsCollection).orderBy('timestamp', descending: true).limit(limit);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final snapshot = await query.get();
      final reports = <Map<String, dynamic>>[];

      for (var doc in snapshot.docs) {
        reports.add(doc.data() as Map<String, dynamic>);
      }

      return reports;
    } catch (e, stack) {
      AppLogger.error('Failed to get recent translation errors', error: e, stackTrace: stack);
      return [];
    }
  }

  /// Find translation errors by search criteria
  Future<List<Map<String, dynamic>>> searchTranslationErrors({
    String? errorType,
    String? statusFilter,
    String? textQuery,
  }) async {
    try {
      Query query = _firestore.collection(_translationErrorsCollection);

      if (errorType != null) {
        query = query.where('errorType', isEqualTo: errorType);
      }

      if (statusFilter != null) {
        query = query.where('status', isEqualTo: statusFilter);
      }

      final snapshot = await query.get();
      final reports = <Map<String, dynamic>>[];

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        // Handle text search client-side if necessary
        if (textQuery != null && textQuery.isNotEmpty) {
          final description = (data['description'] as String).toLowerCase();
          final context = (data['context'] as String).toLowerCase();

          if (description.contains(textQuery.toLowerCase()) || context.contains(textQuery.toLowerCase())) {
            reports.add(data);
          }
        } else {
          reports.add(data);
        }
      }

      return reports;
    } catch (e, stack) {
      AppLogger.error('Failed to search translation errors', error: e, stackTrace: stack);
      return [];
    }
  }
}
