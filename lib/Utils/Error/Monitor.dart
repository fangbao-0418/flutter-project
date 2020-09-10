import 'dart:async';
import 'package:flutter/material.dart';
import 'package:xtflutter/utils/error/error_report.dart';
// import 'package:xtflutter/pages/normal/custom_error.dart';

void monitor(runApp) {
  FlutterError.onError = (FlutterErrorDetails details) {
    print('=============  flutter error start =============');
    print(details.context.toString());
    print(details.exceptionAsString());
    print('=============  flutter error end   =============');
    reportError(details);
  };
  // ErrorWidget.builder = (FlutterErrorDetails details) {
  //   print("============= CustomErrorWidget =============");
  //   return CustomErrorWidget();
  // };

  runZoned(() {
    runApp();
  }, onError: (e, stack) {
    print('============= zoned start =============');
    print(e);
    print(stack);
    print('============= zoned end =============');
  });
}
