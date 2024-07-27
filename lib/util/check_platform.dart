import 'package:window_size/window_size.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class CheckPlatform {
  static void sizeWindowByPlatforms() {
    if (Platform.isWindows) {
      CheckPlatform.testWindowFunctions();
    }
  }

  static Future testWindowFunctions() async {
    setWindowTitle('My App');
    setWindowMinSize(const Size(900, 950));
  }
}
