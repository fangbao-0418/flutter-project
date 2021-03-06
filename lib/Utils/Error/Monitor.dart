import 'dart:async';
import 'package:flutter/material.dart';
import 'package:xtflutter/Utils/Error/ReportError.dart';

// 错误监控
void monitor(cb) {
  FlutterError.onError = (FlutterErrorDetails details) {
    print('============= flutter error start =============');
    // print(details);
    print(details);
    print('============= flutter error end =============');
    reportError(details);
  };
  ErrorWidget.builder = (FlutterErrorDetails details) {
    // print(details.toString());
    return Material(
        child: Center(
      child: Text("Flutter 走神了"),
    ));
  };
   cb();
  // runZoned(() {
  //   cb();
  // }, onError: (e, stack) {
  //   print('============= zoned start =============');
  //   print(e);
  //   print(stack);
  //   print('============= zoned end =============');
  // });
}
