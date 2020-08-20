import 'package:dio/dio.dart';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:xtflutter/Utils/Global.dart';
import 'dart:convert';
import 'dart:async';
import 'package:xtflutter/local/helper.dart' as local;
import './XtError.dart';

/**
 * ios ijmtxxg4t
 * android pn8njdku4
 * api https://rlcas.hzxituan.com/
 */
const moonid = 'ijmtxxg4t';

String baseUrl = 'https://rlcas.hzxituan.com';

void sendReport(
    {String message, String req, String res, StackTrace stack, int timestamp}) {
  if (!Global.isDebugger) {
    return;
  }
  timestamp = timestamp ?? new DateTime.now().millisecondsSinceEpoch;
  // 1.发送网络请求
  final url = baseUrl + "/rlcas/ijmtxxg4t";
  final List<dynamic> xtLogdata = [];
  String stackString = stack?.toString();
  stackString =
      stackString.split(new RegExp(r'[\t\r\n\v]')).sublist(0, 10).join('\r\n');
  xtLogdata.add({
    'flutter': true,
    'env': 'prod',
    't': 'error',
    'ap': 'AppStore',
    'at': timestamp,
    'av': '2.1.1',
    'code': 2222,
    'dv': 'E79B5B23-034D-4D55-A472-C2D23A645DB2',
    'md': 'iPhone 7 Plus',
    'mid': '142185',
    'ip': '220.173.134.120',
    'gid': 'k61uk8df90',
    'os': 'iOS',
    'ov': '13.3.1',
    'message': message,
    'stack': stackString,
    '_res': res,
    '_req': req
  });
  final data = {'env': 'prod', 'xt_logdata': xtLogdata};
  Dio dio = Dio(BaseOptions(baseUrl: baseUrl));
  dio.interceptors
      .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
    options.headers['referer'] = 'https://xt-crmadmin.hzxituan.com/';
    return options; //continue
  }));
  local.helper(dio);
  new Timer(Duration(microseconds: 100), () {
    dio.post(url, data: data).then((v) {
      //
    }, onError: () {
      //
    });
  });
}

void reportError(FlutterErrorDetails details) {
  sendReport(message: details.toString(), stack: details.stack);
}

// TODO
void throwError(String title, String message) {
  // throw(message);
  // const stack = StackTrace(message: '').current;
  // try {

  // } catch (e) {
  //   print('eeeeeee');
  //   print(e?.stack);
  // print(message);
  // reportError(FlutterErrorDetails(stack: StackTrace.fromString(message), library: 'xxx', exception: message));
  // }
  // FlutterErrorDetails details = ;
  //
}

void reportNetError(XTNetError xtNetError) {
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
    sendReport(req: req, res: res, message: message, timestamp: timestamp);
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
    sendReport(req: req, res: res, message: dioError.toString());
  } else if (xTNetErrorType == XTNetErrorType.SYNTAX_ERROR) {
    Error error = xtNetError.error;
    sendReport(message: error.toString(), stack: error.stackTrace);
  }
}
