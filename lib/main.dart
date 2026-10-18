import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'core/services/hotkey_service.dart';
import 'features/home/presentation/views/home_view.dart'; // استدعاء الواجهة

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تشغيل خدمة الكيبورد
  await HotKeyService.initGlobalHotKey();

  // إعدادات نافذة الويندوز
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(450, 350),
    center: true,
    backgroundColor: Colors.white,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
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
