import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';
import 'hotkey_service.dart';
import 'startup_service.dart';

class SystemTrayService with TrayListener {
  static final SystemTrayService _instance = SystemTrayService._internal();
  factory SystemTrayService() => _instance;
  SystemTrayService._internal();

  static Future<void> initSystemTray() async {
    await trayManager.setIcon('windows/runner/resources/app_icon.ico');
    trayManager.addListener(_instance);
    await updateTrayMenu();
  }

  static Future<void> updateTrayMenu() async {
    final bool isConversionActive = HotKeyService.isEnabled;
    final bool isStartupActive = await StartupService.isEnabled();

    await trayManager.setToolTip(
      isConversionActive
          ? 'Keyboard Fixer (مُفعّل - Ctrl+Alt+A/E)'
          : 'Keyboard Fixer (متوقف مؤقتاً)',
    );

    final Menu menu = Menu(
      items: [
        MenuItem(
          key: 'toggle_conversion',
          label: isConversionActive
              ? '⏸️ إيقاف التحويل مؤقتاً'
              : '▶️ تشغيل التحويل الآن',
        ),
        MenuItem(
          key: 'toggle_startup',
          label: isStartupActive
              ? '✅ يعمل تلقائياً مع الويندوز'
              : '⬜ تشغيل تلقائي مع الويندوز',
        ),
        MenuItem.separator(),
        MenuItem(key: 'show_window', label: 'إظهار النافذة'),
        MenuItem.separator(),
        MenuItem(key: 'exit_app', label: 'إغلاق البرنامج نهائياً'),
      ],
    );

    await trayManager.setContextMenu(menu);
  }

  static Future<void> hideToTray() async {
    await windowManager.setSkipTaskbar(true);
    await windowManager.hide();
  }

  static Future<void> showFromTray() async {
    await windowManager.setSkipTaskbar(false);
    await windowManager.show();
    await windowManager.focus();
  }

  @override
  void onTrayIconMouseDown() async {
    await showFromTray();
  }

  @override
  void onTrayIconRightMouseDown() async {
    await windowManager.focus();

    await trayManager.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) async {
    switch (menuItem.key) {
      case 'toggle_conversion':
        await HotKeyService.toggle();
        await updateTrayMenu();
        break;

      case 'toggle_startup':
        await StartupService.toggle();
        await updateTrayMenu();
        break;

      case 'show_window':
        await showFromTray();
        break;

      case 'exit_app':
        await HotKeyService.disable();
        await trayManager.destroy();
        await windowManager.destroy();
        break;
    }
  }
}
