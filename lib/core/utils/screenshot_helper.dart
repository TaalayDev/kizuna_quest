import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:screenshot/screenshot.dart';
import 'package:tsuzuki_connect/core/utils/app_logger.dart';

/// Helper class for managing screenshot operations
class ScreenshotHelper {
  /// Takes a screenshot and saves it to the app's documents directory
  /// Returns the path to the saved screenshot file
  static Future<String?> takeAndSaveScreenshot({
    required ScreenshotController controller,
    required String fileName,
    int quality = 80,
  }) async {
    try {
      // Capture screenshot
      final Uint8List? imageBytes = await controller.capture(
        delay: const Duration(milliseconds: 10),
        pixelRatio: 1.0,
      );

      if (imageBytes == null) {
        AppLogger.error('Failed to capture screenshot: imageBytes is null');
        return null;
      }

      // Get app documents directory
      final directory = await getApplicationDocumentsDirectory();

      // Create screenshots directory if it doesn't exist
      final screenshotsDir = Directory(path.join(directory.path, 'screenshots'));
      if (!await screenshotsDir.exists()) {
        await screenshotsDir.create(recursive: true);
      }

      // Create file path
      final filePath = path.join(
        screenshotsDir.path,
        '$fileName.jpg',
      );

      // Write to file
      final file = File(filePath);
      await file.writeAsBytes(imageBytes);

      AppLogger.info('Screenshot saved to: $filePath');
      return filePath;
    } catch (e, stack) {
      AppLogger.error('Failed to save screenshot', error: e, stackTrace: stack);
      return null;
    }
  }

  /// Generates a thumbnail from a screenshot with the specified dimensions
  /// Returns the path to the saved thumbnail file
  static Future<String?> generateThumbnail({
    required String screenshotPath,
    required String thumbnailName,
    int width = 320,
    int height = 180,
    int quality = 70,
  }) async {
    try {
      // Read the screenshot file
      final file = File(screenshotPath);
      if (!await file.exists()) {
        AppLogger.error('Screenshot file does not exist: $screenshotPath');
        return null;
      }

      final Uint8List bytes = await file.readAsBytes();

      // Decode the image
      final ui.Image image = await decodeImageFromList(bytes);

      // Create a thumbnail
      final thumbnailData = await _resizeImage(
        image: image,
        targetWidth: width,
        targetHeight: height,
        quality: quality,
      );

      if (thumbnailData == null) {
        AppLogger.error('Failed to resize image');
        return null;
      }

      // Get app documents directory
      final directory = await getApplicationDocumentsDirectory();

      // Create thumbnails directory if it doesn't exist
      final thumbnailsDir = Directory(path.join(directory.path, 'thumbnails'));
      if (!await thumbnailsDir.exists()) {
        await thumbnailsDir.create(recursive: true);
      }

      final thumbnailPath = path.join(
        thumbnailsDir.path,
        '$thumbnailName.jpg',
      );

      // Write to file
      final thumbnailFile = File(thumbnailPath);
      await thumbnailFile.writeAsBytes(thumbnailData);

      AppLogger.info('Thumbnail saved to: $thumbnailPath');
      return thumbnailPath;
    } catch (e, stack) {
      AppLogger.error('Failed to generate thumbnail', error: e, stackTrace: stack);
      return null;
    }
  }

  /// Resizes an image to the target dimensions
  static Future<Uint8List?> _resizeImage({
    required ui.Image image,
    required int targetWidth,
    required int targetHeight,
    int quality = 70,
  }) async {
    try {
      // Create a picture recorder
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);

      // Draw the image scaled to the target size
      canvas.drawImageRect(
        image,
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
        Rect.fromLTWH(0, 0, targetWidth.toDouble(), targetHeight.toDouble()),
        Paint()..filterQuality = FilterQuality.medium,
      );

      // End recording and convert to image
      final picture = recorder.endRecording();
      final resizedImage = await picture.toImage(targetWidth, targetHeight);

      // Convert to bytes
      final byteData = await resizedImage.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        return null;
      }

      return byteData.buffer.asUint8List();
    } catch (e, stack) {
      AppLogger.error('Error resizing image', error: e, stackTrace: stack);
      return null;
    }
  }
}
