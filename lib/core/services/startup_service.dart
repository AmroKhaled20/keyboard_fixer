import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:launch_at_startup/launch_at_startup.dart';

class StartupService {
  static Future<void> init() async {
    LaunchAtStartup.instance.setup(
      appName: 'KeyboardFixer',
      appPath: Platform.resolvedExecutable,
      args: ['--autostart'],
    );

    if (kReleaseMode) {
      final bool isEnabled = await LaunchAtStartup.instance.isEnabled();

      if (!isEnabled) {
        await LaunchAtStartup.instance.enable();
      }
    }
  }

  static Future<bool> isEnabled() async {
    return await LaunchAtStartup.instance.isEnabled();
  }

  static Future<bool> toggle() async {
    final bool currentState = await isEnabled();

    if (currentState) {
      await LaunchAtStartup.instance.disable();
      return false;
    } else {
      await LaunchAtStartup.instance.enable();
      return true;
    }
  }
}
