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

      final initialSequenceNumber = GetClipboardSequenceNumber();

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

      if (convertedText == originalText) return;

      await Clipboard.setData(ClipboardData(text: convertedText));

      await Future.delayed(const Duration(milliseconds: 20));

      WindowsSimulatorService.pasteText();
    } finally {
      _isProcessing = false;
    }
  }

  static Future<bool> _waitForClipboardUpdate(
    Object initialSequenceNumber, {
    Duration timeout = const Duration(milliseconds: 300),
  }) async {
    final stopwatch = Stopwatch()..start();

    while (stopwatch.elapsed < timeout) {
      final currentSequenceNumber = GetClipboardSequenceNumber();

      if (currentSequenceNumber != initialSequenceNumber) {
        return true;
      }
      await Future.delayed(const Duration(milliseconds: 10));
    }

    return false;
  }
}
