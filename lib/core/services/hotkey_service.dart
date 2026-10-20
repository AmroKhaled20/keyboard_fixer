import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'text_conversion_service.dart';

class HotKeyService {
  static bool _isEnabled = false;

  static bool get isEnabled => _isEnabled;

  static final HotKey _hotKey = HotKey(
    key: PhysicalKeyboardKey.keyA,
    modifiers: [HotKeyModifier.control, HotKeyModifier.alt],
    scope: HotKeyScope.system,
  );

  static Future<void> initGlobalHotKey() async {
    await enable();
  }

  static Future<void> enable() async {
    if (_isEnabled) return;

    await hotKeyManager.unregisterAll();
    await hotKeyManager.register(
      _hotKey,
      keyDownHandler: (hotKey) async {
        await TextConversionService.convertSelectedText();
      },
    );

    _isEnabled = true;
  }

  static Future<void> disable() async {
    if (!_isEnabled) return;

    await hotKeyManager.unregisterAll();
    _isEnabled = false;
  }

  static Future<bool> toggle() async {
    if (_isEnabled) {
      await disable();
    } else {
      await enable();
    }
    return _isEnabled;
  }
}
