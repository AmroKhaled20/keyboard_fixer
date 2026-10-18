import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class CustomCloseButton extends StatelessWidget {
  const CustomCloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      hoverColor: Colors.red,
      // تحديد شكل وأيقونة الزرار
      icon: const Icon(Icons.close, color: Colors.grey),
      // إزالة أي مسافات إضافية حول الزرار ليكون دقيق في الزاوية
      padding: EdgeInsets.zero,
      onPressed: () async {
        // الاتصال بحزمة الويندوز لإرسال أمر الإغلاق الفوري للنافذة
        await windowManager.close();
      },
    );
  }
}
