import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'text_conversion_service.dart';

class HotKeyService {
  static Future<void> initGlobalHotKey() async {
    await hotKeyManager.unregisterAll();

    final hotKey = HotKey(
      key: PhysicalKeyboardKey.keyA,
      modifiers: [HotKeyModifier.control, HotKeyModifier.alt],
      scope: HotKeyScope.system,
    );

    await hotKeyManager.register(
      hotKey,
      keyDownHandler: (hotKey) async {
        debugPrint('\n========================================');
        debugPrint('🎯 [HotKeyService] تم التقاط الاختصار (Ctrl + Alt + A)');
        await TextConversionService.convertSelectedText();
      },
    );

    debugPrint(
      '✅ [HotKeyService] تم تسجيل الاختصار العام بنجاح وجاهز للاستماع',
    );
  }
}
