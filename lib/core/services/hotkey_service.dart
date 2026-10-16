import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';

class HotKeyService {
  static Future<void> initGlobalHotKey() async {
    await hotKeyManager.unregisterAll();

    final hotKey = HotKey(
      key: PhysicalKeyboardKey.keyA,
      modifiers: [HotKeyModifier.shift, HotKeyModifier.alt],
      scope: HotKeyScope.system,
    );

    await hotKeyManager.register(
      hotKey,
      keyDownHandler: (hotKey) {
        print('تم التقاط الاختصار بنجاح من خارج التطبيق!');

        // Copy → Convert → Paste
      },
    );
  }
}
