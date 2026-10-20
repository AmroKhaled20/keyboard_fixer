import 'package:flutter/material.dart';
import '../../../../core/services/system_tray_service.dart';

class CustomCloseButton extends StatelessWidget {
  const CustomCloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.close, color: Colors.grey),
      padding: EdgeInsets.zero,
      onPressed: () async {
        await SystemTrayService.hideToTray();
      },
    );
  }
}
