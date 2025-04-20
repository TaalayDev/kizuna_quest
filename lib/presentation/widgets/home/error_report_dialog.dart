import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kizuna_quest/core/utils/extensions.dart';
import 'package:screenshot/screenshot.dart';

import '../../../providers/app_providers.dart';

/// A dialog for reporting translation errors in the game
class ErrorReportDialog extends ConsumerStatefulWidget {
  static Future<void> show(
    BuildContext context, {
    String? currentContext,
    ScreenshotController? screenshotController,
  }) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) {
        return ErrorReportDialog(
          currentContext: currentContext,
          screenshotController: screenshotController,
        );
      },
    );
  }

  /// Current game context (optional - to help locate the error)
  final String? currentContext;

  /// Screenshot controller for capturing the error
  final ScreenshotController? screenshotController;

  /// Creates an ErrorReportDialog
  const ErrorReportDialog({
    super.key,
    this.currentContext,
    this.screenshotController,
  });

  @override
  ConsumerState<ErrorReportDialog> createState() => _ErrorReportDialogState();
}

class _ErrorReportDialogState extends ConsumerState<ErrorReportDialog> with SingleTickerProviderStateMixin {
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedErrorType = 'translation';
  bool _isSubmitting = false;
  bool _includeScreenshot = false;
  String? _screenshotBase64;

  // Animation controller
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _captureScreenshotIfAvailable();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );

    // Start animation
    _animationController.forward();
  }

  Future<void> _captureScreenshotIfAvailable() async {
    if (widget.screenshotController != null) {
      try {
        final Uint8List? imageBytes = await widget.screenshotController!.capture();
        if (imageBytes != null) {
          setState(() {
            _screenshotBase64 = base64Encode(imageBytes);
            _includeScreenshot = true; // Auto-include if available
          });
        }
      } catch (e) {
        debugPrint('Failed to capture screenshot: $e');
      }
    }
  }

  Future<void> _submitReport() async {
    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide a description of the error'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final report = TranslationErrorReport(
      errorType: _selectedErrorType,
      description: _descriptionController.text.trim(),
      context: widget.currentContext,
      screenshot: _includeScreenshot ? _screenshotBase64 : null,
    );

    final reportController = ref.read(reportControllerProvider);
    final success = await reportController.submitTranslationError(report);

    setState(() {
      _isSubmitting = false;
    });

    if (!mounted) return;

    if (success) {
      // Animate the dialog out
      _animationController.reverse().then((_) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thank you for your feedback! Your report has been submitted.'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3),
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to submit report. Please try again later.',
            style: TextStyle(color: context.theme.colorScheme.error),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 8,
        backgroundColor: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          decoration: BoxDecoration(
            color: context.theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: context.theme.colorScheme.primaryContainer,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.primaryContainer,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.feedback,
                      size: 22,
                      color: context.theme.colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Report Translation Error',
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => Navigator.of(context).pop(),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(
                            Icons.close,
                            size: 20,
                            color: context.theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Help us improve by reporting any translation errors or issues you find.',
                      style: context.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    _buildErrorTypeSelector(),
                    const SizedBox(height: 16),
                    _buildDescriptionField(),
                    if (_screenshotBase64 != null) _buildScreenshotOption(),
                    if (widget.currentContext != null) _buildLocationInfo(),
                  ],
                ),
              ),

              // Action buttons
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.surface.withOpacity(0.9),
                  border: Border(
                    top: BorderSide(
                      color: context.theme.colorScheme.primaryContainer.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        foregroundColor: context.theme.colorScheme.onSurface.withOpacity(0.8),
                      ),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitReport,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.theme.colorScheme.primary,
                        foregroundColor: context.theme.colorScheme.onPrimary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      child: _isSubmitting
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: context.theme.colorScheme.onPrimary,
                              ),
                            )
                          : const Text('Submit'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 300.ms),
    );
  }

  Widget _buildErrorTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Error Type',
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: context.theme.colorScheme.outline.withOpacity(0.5),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedErrorType,
              isExpanded: true,
              borderRadius: BorderRadius.circular(8),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              icon: Icon(
                Icons.arrow_drop_down,
                color: context.theme.colorScheme.primary,
              ),
              items: const [
                DropdownMenuItem(value: 'translation', child: Text('Translation Error')),
                DropdownMenuItem(value: 'grammar', child: Text('Grammar Mistake')),
                DropdownMenuItem(value: 'furigana', child: Text('Furigana Error')),
                DropdownMenuItem(value: 'romaji', child: Text('Romaji Error')),
                DropdownMenuItem(value: 'ui', child: Text('UI Text Problem')),
                DropdownMenuItem(value: 'other', child: Text('Other Issue')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedErrorType = value;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _descriptionController,
          decoration: InputDecoration(
            hintText: 'Please describe the error in detail',
            hintStyle: TextStyle(
              color: context.theme.colorScheme.onSurface.withOpacity(0.5),
              fontSize: 14,
            ),
            contentPadding: const EdgeInsets.all(12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: context.theme.colorScheme.outline.withOpacity(0.5),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: context.theme.colorScheme.outline.withOpacity(0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: context.theme.colorScheme.primary,
              ),
            ),
          ),
          maxLines: 4,
          style: context.textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildScreenshotOption() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Container(
        decoration: BoxDecoration(
          color: context.theme.colorScheme.primaryContainer.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: context.theme.colorScheme.primaryContainer.withOpacity(0.3),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(
              Icons.photo_camera,
              size: 20,
              color: context.theme.colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Include Screenshot',
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Help us locate the error faster',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: _includeScreenshot,
              activeColor: context.theme.colorScheme.primary,
              onChanged: (value) {
                setState(() {
                  _includeScreenshot = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationInfo() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: context.theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.location_pin,
              size: 16,
              color: context.theme.colorScheme.primary.withOpacity(0.7),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Location: ${widget.currentContext}',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.theme.colorScheme.onSurface.withOpacity(0.7),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
