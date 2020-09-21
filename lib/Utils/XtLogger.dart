import 'dart:developer' as developer;

import 'package:flutter/material.dart';

/// log 打印类
/// create by yuanl at 2020/09/19
class XtLogger {
  static final String NAME_TAG = "xt-flutter";

  static void logPrint(Object object) {
    print(object);
  }

  static void devLog(String log) {
    developer.log(
      log,
      name: NAME_TAG,
    );
  }

  static void devTagLog(String tagName, String log) {
    developer.log(
      log,
      name: tagName,
    );
  }

  static void logDebugDumpApp() {
    debugDumpApp();
  }

  static void logDebugDUnpRenderTree() {
    debugDumpRenderTree();
  }
}
