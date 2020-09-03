import 'dart:math';
import 'package:dio/dio.dart';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:xtflutter/utils/global.dart';
import 'dart:convert';
import 'dart:async';
import 'collect_data.dart' as Collection;
import 'error.dart';
import '../report.dart';

const TO_REPORT = true;

// 发送上报请求
Future _sendRequest(List<Map<String, dynamic>> xtLogdata) {
  return sendReportRequest(xtLogdata);
}

// 数据上报
void _handleReport(
    {String message, String req, String res, StackTrace stack, int timestamp}) {
  if (!Global.isDebugger) {
    return;
  }

  String stackString = stack?.toString() ?? '';
  List<String> stackList = stackString.split(new RegExp(r'[\t\r\n\v]'));
  // 提取前10错误栈信息
  stackString = stackList.sublist(0, min(stackList.length, 10)).join('\r\n');

  Map<String, dynamic> baseInfo = getBaseInfo();
  Map<String, dynamic> info = {
    ...baseInfo,
    't': 'error',
    'message': message,
    'stack': stackString,
    '_res': res,
    '_req': req
  };
  Future.delayed(Duration(milliseconds: 100), () {
    if (TO_REPORT) {
      _sendRequest([info]);
    }
  });
}

// 检测未成功的日志
void detectionUnSendLog() {
  Collection.takeData().then((value) {
    if (value.length == 0) {
      return;
    }
    List<List<Map<String, dynamic>>> data =
        value.map<List<Map<String, dynamic>>>((e) {
      return [jsonDecode(e)];
    }).toList();
    sequenceRequest(data);
  });
}

// TODO
void _throwError(Error error) {}

// 上报flutter错误
void reportError(FlutterErrorDetails details) {
  if (!TO_REPORT) {
    return;
  }
  _handleReport(message: details.toString(), stack: details.stack);
}

// 上报网络错误
void reportNetError(XTNetError xtNetError) {
  if (!TO_REPORT) {
    return;
  }
  int timestamp = xtNetError.timestamp;
  XTNetErrorType xTNetErrorType = xtNetError.type;
  String req;
  String res;
  String message = xtNetError.message;
  if (xTNetErrorType == XTNetErrorType.DEFAULT) {
    RequestOptions request = xtNetError.error.request;
    Response response = xtNetError.error.response;
    req = jsonEncode({
      'contentType': request.contentType,
      'path': request.path,
      'headers': request.headers,
      'params': request.data,
      'queryParameters': request.queryParameters
    });
    res = jsonEncode({'data': response.toString(), 'status': 200});
    _handleReport(req: req, res: res, message: message, timestamp: timestamp);
  } else if (xTNetErrorType == XTNetErrorType.DIO_ERROR) {
    DioError dioError = xtNetError.error;
    RequestOptions request = dioError.request;
    DioErrorType dioErrorType = xtNetError.dioErrorType;
    req = jsonEncode({
      'contentType': request.contentType,
      'path': request.path,
      'headers': request.headers,
      'params': request.data,
      'queryParameters': request.queryParameters
    });
    if (dioErrorType == DioErrorType.RESPONSE) {
      res = jsonEncode({
        'type': dioErrorType.toString(),
        'data': dioError.response.toString()
      });
    } else {
      res = jsonEncode({'type': dioErrorType.toString()});
    }
    _handleReport(req: req, res: res, message: dioError.toString());
  } else if (xTNetErrorType == XTNetErrorType.SYNTAX_ERROR) {
    Error error = xtNetError.error;
    _handleReport(message: error.toString(), stack: error.stackTrace);
  }
}
