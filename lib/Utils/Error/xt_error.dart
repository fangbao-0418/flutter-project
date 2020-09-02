import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'error_report.dart';

enum XTNetErrorType { DIO_ERROR, SYNTAX_ERROR, DEFAULT }

// 网络错误类
class XTNetError {
  XTNetErrorType type;
  String message;
  dynamic data;
  DioErrorType dioErrorType;
  // DioError or Error
  dynamic error;
  int timestamp = new DateTime.now().millisecondsSinceEpoch;
  XTNetError(
      {this.type = XTNetErrorType.DEFAULT,
      this.message,
      this.data,
      this.dioErrorType,
      @required this.error}) {
        print('============= XtError start =============');
    print(this.toString());
    print('============= XtError end =============');
    reportNetError(this);
  }
  String toString() {
    var msg = 'XTNetError $type, ${message ?? error.toString()}';
    if (error is Error) {
      msg += '\n${error.stackTrace}';
    }
    return msg;
  }
}
