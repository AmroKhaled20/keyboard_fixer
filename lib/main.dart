import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'core/services/hotkey_service.dart';
import 'core/services/startup_service.dart';
import 'core/services/system_tray_service.dart';
import 'features/home/presentation/views/home_view.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();
  await StartupService.init();
  await HotKeyService.initGlobalHotKey();
  await SystemTrayService.initSystemTray();

  const WindowOptions windowOptions = WindowOptions(
    size: Size(450, 350),
    center: true,
    backgroundColor: Colors.white,
    skipTaskbar: true,
    titleBarStyle: TitleBarStyle.hidden,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.hide();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeView(),
    );
  }
}
