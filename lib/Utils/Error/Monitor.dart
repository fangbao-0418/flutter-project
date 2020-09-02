import 'dart:async';
import 'package:flutter/material.dart';
import 'package:xtflutter/utils/error/error_report.dart';
import 'package:xtflutter/xt_widgets/custom_error.dart';


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
