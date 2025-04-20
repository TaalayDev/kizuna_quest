import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/in_app_review_service.dart';
import '../core/services/report_service.dart';

final inAppReviewProvider = Provider<InAppReviewService>((ref) {
  return InAppReviewService();
});

final reportServiceProvider = Provider<ReportService>((ref) {
  return ReportService();
});

/// Provider for tracking the state of report submission
final reportSubmissionStateProvider = StateProvider<AsyncValue<bool>>((ref) {
  return const AsyncValue.data(false);
});

/// Provider for tracking the state of feedback submission
final feedbackSubmissionStateProvider = StateProvider<AsyncValue<bool>>((ref) {
  return const AsyncValue.data(false);
});

/// Class to hold report form data
class TranslationErrorReport {
  final String errorType;
  final String description;
  final String? context;
  final String? screenshot;

  TranslationErrorReport({
    required this.errorType,
    required this.description,
    this.context,
    this.screenshot,
  });
}

/// Class to hold feedback form data
class AppFeedback {
  final String feedbackType;
  final String content;
  final int? rating;

  AppFeedback({
    required this.feedbackType,
    required this.content,
    this.rating,
  });
}

/// Controller for submitting translation error reports
class ReportController {
  final ReportService _reportService;
  final Ref _ref;

  ReportController(this._reportService, this._ref);

  /// Submit a translation error report
  Future<bool> submitTranslationError(TranslationErrorReport report) async {
    _ref.read(reportSubmissionStateProvider.notifier).state = const AsyncValue.loading();

    try {
      final result = await _reportService.submitTranslationError(
        errorType: report.errorType,
        description: report.description,
        context: report.context,
        screenshot: report.screenshot,
      );

      _ref.read(reportSubmissionStateProvider.notifier).state = AsyncValue.data(result);
      return result;
    } catch (e, stack) {
      _ref.read(reportSubmissionStateProvider.notifier).state = AsyncValue.error(e, stack);
      return false;
    }
  }

  /// Submit app feedback
  Future<bool> submitFeedback(AppFeedback feedback) async {
    _ref.read(feedbackSubmissionStateProvider.notifier).state = const AsyncValue.loading();

    try {
      final result = await _reportService.submitFeedback(
        feedbackType: feedback.feedbackType,
        content: feedback.content,
        rating: feedback.rating,
      );

      _ref.read(feedbackSubmissionStateProvider.notifier).state = AsyncValue.data(result);
      return result;
    } catch (e, stack) {
      _ref.read(feedbackSubmissionStateProvider.notifier).state = AsyncValue.error(e, stack);
      return false;
    }
  }
}

/// Provider for the ReportController
final reportControllerProvider = Provider<ReportController>((ref) {
  final reportService = ref.watch(reportServiceProvider);
  return ReportController(reportService, ref);
});
