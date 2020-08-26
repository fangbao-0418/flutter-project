import 'dart:async';
import 'package:flutter/material.dart';
import 'package:xtflutter/Utils/Error/ReportError.dart';
import 'package:xtflutter/Widgets/CustomErrorWidget.dart';

// 错误监控
void monitor(runApp) {
  FlutterError.onError = (FlutterErrorDetails details) {
    print('============= flutter error start =============');
    print(details);
    print('============= flutter error end =============');
    reportError(details);
  };
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return CustomErrorWidget();
  };

  runZoned(() {
    runApp();
  }, onError: (e, stack) {
    print('============= zoned start =============');
    print(e);
    print(stack);
    print('============= zoned end =============');
  });
}
