import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class WindowControls extends StatelessWidget {
  const WindowControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove, color: Colors.black54, size: 24),
            splashRadius: 20,
            tooltip: 'إخفاء في الخلفية',
            hoverColor: Colors.black.withOpacity(0.05),
            onPressed: () async {
              await windowManager.hide();
            },
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black54, size: 22),
            splashRadius: 20,
            tooltip: 'إغلاق البرنامج نهائياً',
            hoverColor: Colors.red.withOpacity(0.1),
            color: Colors.black54,
            onPressed: () async {
              await windowManager.close();
            },
          ),
        ],
      ),
    );
  }
}
