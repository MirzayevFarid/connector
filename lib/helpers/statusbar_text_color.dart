import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_statusbar_text_color/flutter_statusbar_text_color.dart';

class StatusbarTextHelper {
  static void changeColor({
    @required bool isDark,
  }) {
    if (Platform.isIOS) {
      FlutterStatusbarTextColor.setTextColor(
        isDark
            ? FlutterStatusbarTextColor.dark
            : FlutterStatusbarTextColor.light,
      );
    }
  }
}
