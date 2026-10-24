import 'package:flutter/material.dart';
import '../widgets/shortcut_card.dart';
import '../widgets/window_controls.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/app_icon.png', width: 150, height: 150),
                    const SizedBox(height: 16),
                    const Text(
                      'التطبيق يعمل الآن في الخلفية...',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 35),

                    const ShortcutCard(
                      title: 'للتحويل إلى العربية',
                      keys: ['Ctrl', 'Alt', 'A'],
                    ),
                    const SizedBox(height: 12),
                    const ShortcutCard(
                      title: 'للتحويل إلى الإنجليزية',
                      keys: ['Ctrl', 'Alt', 'E'],
                    ),
                  ],
                ),
              ),
            ),

            const Positioned(right: 10, top: 10, child: WindowControls()),
          ],
        ),
      ),
    );
  }
}
