import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

class WindowsSimulatorService {
  static bool copySelectedText() {
    return _sendCtrlShortcut(VK_C);
  }

  static bool pasteText() {
    return _sendCtrlShortcut(VK_V);
  }

  static Future<bool> waitForModifiersRelease({
    Duration timeout = const Duration(milliseconds: 500),
  }) async {
    final stopwatch = Stopwatch()..start();

    while (_areModifiersPressed()) {
      if (stopwatch.elapsed >= timeout) {
        return false;
      }

      await Future.delayed(const Duration(milliseconds: 15));
    }

    return true;
  }

  static bool _areModifiersPressed() {
    const int keyPressedMask = 0x8000;

    final bool isAltPressed = (GetAsyncKeyState(VK_MENU) & keyPressedMask) != 0;
    final bool isShiftPressed =
        (GetAsyncKeyState(VK_SHIFT) & keyPressedMask) != 0;
    final bool isCtrlPressed =
        (GetAsyncKeyState(VK_CONTROL) & keyPressedMask) != 0;

    return isAltPressed || isShiftPressed || isCtrlPressed;
  }

  static bool _sendCtrlShortcut(int targetKey) {
    const int inputCount = 4;
    final Pointer<INPUT> inputs = calloc<INPUT>(inputCount);

    try {
      _setKeyEvent(inputs, 0, VK_CONTROL, isKeyUp: false);
      _setKeyEvent(inputs, 1, targetKey, isKeyUp: false);
      _setKeyEvent(inputs, 2, targetKey, isKeyUp: true);
      _setKeyEvent(inputs, 3, VK_CONTROL, isKeyUp: true);

      final int result = SendInput(inputCount, inputs, sizeOf<INPUT>());

      return result == inputCount;
    } finally {
      calloc.free(inputs);
    }
  }

  static void _setKeyEvent(
    Pointer<INPUT> inputs,
    int index,
    int virtualKey, {
    required bool isKeyUp,
  }) {
    inputs[index].type = INPUT_KEYBOARD;
    inputs[index].ki.wVk = virtualKey;
    inputs[index].ki.dwFlags = isKeyUp ? KEYEVENTF_KEYUP : 0;
  }
}
