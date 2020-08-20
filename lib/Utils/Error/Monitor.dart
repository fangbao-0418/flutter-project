import 'dart:async';
import 'package:flutter/material.dart';
import 'package:xtflutter/Utils/Error/ReportError.dart';

// 错误监控
void monitor (cb) {
  FlutterError.onError = (FlutterErrorDetails details) {
    // print('111111111111-----------');
    // print(details);
    // print('--------111111111111');
    reportError(details);
  };
  ErrorWidget.builder = (FlutterErrorDetails details){
    // print(details.toString());
    return Material(
      child: Center(
      child: Text("Flutter 走神了"),
    ));
  };
  runZoned(() {
    cb();
  }, onError: (e, stack) {
    // reportError(e.toString(), stack);
    // print('error: start --------------------------------');
    // print(e);
    // print('---------------------------------------');
    // print(stack);
    // print('error: end --------------------------------');
  });
}