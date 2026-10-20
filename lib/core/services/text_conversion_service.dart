import 'package:flutter/services.dart';
import 'package:win32/win32.dart';
import '../utils/keyboard_converter.dart';
import 'windows_simulator_service.dart';

class TextConversionService {
  static bool _isProcessing = false;

  static Future<void> convertSelectedText() async {
    if (_isProcessing) return;
    _isProcessing = true;

    try {
      final bool modifiersReleased =
          await WindowsSimulatorService.waitForModifiersRelease();
      if (!modifiersReleased) return;

      final ClipboardData? previousClipboardData = await Clipboard.getData(
        Clipboard.kTextPlain,
      );
      final String? previousText = previousClipboardData?.text;

      final int initialSequenceNumber = GetClipboardSequenceNumber();

      final bool copySent = WindowsSimulatorService.copySelectedText();
      if (!copySent) return;

      final bool clipboardUpdated = await _waitForClipboardUpdate(
        initialSequenceNumber,
      );
      if (!clipboardUpdated) return;

      final ClipboardData? clipboardData = await Clipboard.getData(
        Clipboard.kTextPlain,
      );
      final String? originalText = clipboardData?.text;

      if (originalText == null || originalText.isEmpty) return;

      final String convertedText = KeyboardConverter.convertToArabic(
        originalText,
      );

      if (convertedText == originalText) {
        await _restoreClipboard(previousText);
        return;
      }

      await Clipboard.setData(ClipboardData(text: convertedText));

      final bool pasteSent = WindowsSimulatorService.pasteText();
      if (!pasteSent) {
        await _restoreClipboard(previousText);
        return;
      }

      await Future.delayed(const Duration(milliseconds: 100));
      await _restoreClipboard(previousText);
    } finally {
      _isProcessing = false;
    }
  }

  static Future<void> _restoreClipboard(String? previousText) async {
    if (previousText != null) {
      await Clipboard.setData(ClipboardData(text: previousText));
    } else {
      await Clipboard.setData(const ClipboardData(text: ''));
    }
  }

  static Future<bool> _waitForClipboardUpdate(
    int initialSequenceNumber, {
    Duration timeout = const Duration(seconds: 1),
  }) async {
    final stopwatch = Stopwatch()..start();

    while (stopwatch.elapsed < timeout) {
      final int currentSequenceNumber = GetClipboardSequenceNumber();

      if (currentSequenceNumber != initialSequenceNumber) {
        return true;
      }
      await Future.delayed(const Duration(milliseconds: 10));
    }

    return false;
  }
}
