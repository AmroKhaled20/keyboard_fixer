import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:win32/win32.dart';
import '../utils/keyboard_converter.dart';
import 'windows_simulator_service.dart';

class TextConversionService {
  static bool _isProcessing = false;

  static Future<void> convertSelectedText() async {
    if (_isProcessing) {
      debugPrint(
        '⚠️ [TextConversion] تم التجاهل: توجد عملية تحويل أخرى شغالة حالياً!',
      );
      return;
    }
    _isProcessing = true;

    final totalStopwatch = Stopwatch()..start();
    String? previousText;
    bool copyAttempted = false;

    try {
      debugPrint('⏳ [1/8] انتظار رفع اليد عن أزرار (Ctrl / Alt)...');
      final bool modifiersReleased =
          await WindowsSimulatorService.waitForModifiersRelease();

      if (!modifiersReleased) {
        debugPrint(
          '❌ [فشل في 1/8] انتهت المهلة (500ms) وما زلت ضاغطاً على أزرار الاختصار!',
        );
        return;
      }
      debugPrint(
        '✅ [1/8] تم رفع اليد عن الأزرار (${totalStopwatch.elapsedMilliseconds}ms)',
      );

      previousText = await _getClipboardTextWithRetry();
      debugPrint(
        '📋 [2/8] محتوى الحافظة القديم المحفوظ: "${previousText ?? "فارغ"}"',
      );

      final int initialSequenceNumber = GetClipboardSequenceNumber();
      debugPrint(
        '🔢 [3/8] رقم تسلسل الحافظة قبل النسخ: $initialSequenceNumber',
      );
      copyAttempted = true;

      final bool copySent = WindowsSimulatorService.copySelectedText();
      if (!copySent) {
        debugPrint(
          '❌ [فشل في 4/8] دالة SendInput فشلت في إرسال أمر (Ctrl + C)!',
        );
        return;
      }
      debugPrint('📤 [4/8] تم إرسال أمر (Ctrl + C) للويندوز بنجاح');

      debugPrint('⏳ [5/8] انتظار استجابة البرنامج المفتوح وتحديث الحافظة...');
      final String? originalText = await _waitForCopiedText(
        initialSequenceNumber,
      );

      if (originalText == null || originalText.isEmpty) {
        debugPrint(
          '❌ [فشل في 5/8] الحافظة لم تتحدث أو النص المحدد فارغ! (تأكد من تحديد نص أولاً)',
        );
        return;
      }
      debugPrint(
        '📥 [5/8] تم قراءة النص المنسوخ بنجاح: "$originalText" (${totalStopwatch.elapsedMilliseconds}ms)',
      );

      final String convertedText = KeyboardConverter.convertToArabic(
        originalText,
      );
      debugPrint('🔄 [6/8] النص بعد التحويل: "$convertedText"');

      if (convertedText == originalText) {
        debugPrint(
          'ℹ️ [توقف في 6/8] النص لم يتغير بعد التحويل (ربما عربي بالفعل أو أرقام)',
        );
        return;
      }

      final bool clipboardSet = await _setClipboardTextWithRetry(convertedText);
      if (!clipboardSet) {
        debugPrint(
          '❌ [فشل في 7/8] فشل وضع النص المحول في الحافظة بعد عدة محاولات!',
        );
        return;
      }
      debugPrint('✅ [7/8] تم وضع النص العربي في الحافظة بنجاح');

      final bool pasteSent = WindowsSimulatorService.pasteText();
      if (!pasteSent) {
        debugPrint(
          '❌ [فشل في 8/8] دالة SendInput فشلت في إرسال أمر اللصق (Ctrl + V)!',
        );
        return;
      }
      debugPrint(
        '🎉 [8/8] تم إرسال أمر اللصق (Ctrl + V) بنجاح! (${totalStopwatch.elapsedMilliseconds}ms)',
      );

      await Future.delayed(const Duration(milliseconds: 120));
    } finally {
      try {
        if (copyAttempted) {
          await _restoreClipboard(previousText ?? '');
          debugPrint(
            '♻️ [النهاية] تم استعادة الحافظة القديمة وإغلاق العملية (${totalStopwatch.elapsedMilliseconds}ms)',
          );
          debugPrint('========================================\n');
        }
      } finally {
        _isProcessing = false;
      }
    }
  }

  static Future<String?> _getClipboardTextWithRetry({
    int maxAttempts = 5,
  }) async {
    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      try {
        final ClipboardData? data = await Clipboard.getData(
          Clipboard.kTextPlain,
        );
        return data?.text;
      } on PlatformException catch (e) {
        debugPrint(
          '⚠️ [Clipboard Read] الحافظة مشغولة (محاولة ${attempt + 1}/$maxAttempts): ${e.message}',
        );
        if (attempt == maxAttempts - 1) {
          return null;
        }
        await Future.delayed(Duration(milliseconds: 30 * (attempt + 1)));
      }
    }
    return null;
  }

  static Future<bool> _setClipboardTextWithRetry(
    String text, {
    int maxAttempts = 5,
  }) async {
    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      try {
        await Clipboard.setData(ClipboardData(text: text));
        return true;
      } on PlatformException catch (e) {
        debugPrint(
          '⚠️ [Clipboard Write] الحافظة مشغولة (محاولة ${attempt + 1}/$maxAttempts): ${e.message}',
        );
        if (attempt == maxAttempts - 1) {
          return false;
        }
        await Future.delayed(Duration(milliseconds: 30 * (attempt + 1)));
      }
    }
    return false;
  }

  static Future<void> _restoreClipboard(String previousText) async {
    await _setClipboardTextWithRetry(previousText);
  }

  static Future<String?> _waitForCopiedText(
    int initialSequenceNumber, {
    Duration timeout = const Duration(seconds: 1),
  }) async {
    final stopwatch = Stopwatch()..start();

    while (stopwatch.elapsed < timeout) {
      final int currentSequence = GetClipboardSequenceNumber();

      if (currentSequence != initialSequenceNumber) {
        debugPrint(
          '⚡ [Clipboard Monitor] تغير رقم التسلسل إلى $currentSequence بعد ${stopwatch.elapsedMilliseconds}ms',
        );
        await Future.delayed(const Duration(milliseconds: 25));

        final String? copiedText = await _getClipboardTextWithRetry();
        if (copiedText != null) {
          return copiedText;
        }
      }

      await Future.delayed(const Duration(milliseconds: 15));
    }

    return null;
  }
}
