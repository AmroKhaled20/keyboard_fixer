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
        await TextConversionService.convertSelectedText();
      },
    );
  }
}
