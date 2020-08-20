import 'package:dio/dio.dart';
import 'dart:core';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:xtflutter/local/helper.dart' as local;

/**
 * ios ijmtxxg4t
 * android pn8njdku4
 * api https://rlcas.hzxituan.com/
 */
const moonid = 'ijmtxxg4t';

// http://127.0.0.1:2222/    https://rlcas.hzxituan.com
String baseUrl = 'https://rlcas.hzxituan.com';

void sendReport(String message, StackTrace stack) {
  // 1.发送网络请求
  final url = baseUrl + "/rlcas/ijmtxxg4t";
  final List<dynamic> xtLogdata = [];
  xtLogdata.add({
    'flutter': true,
    'env': 'prod',
    't': 'error',
    'ap': 'AppStore',
    'at': new DateTime.now().millisecondsSinceEpoch,
    'av': '2.1.1',
    'code': 2222,
    'dv': 'E79B5B23-034D-4D55-A472-C2D23A645DB2',
    'md': 'iPhone 7 Plus',
    'mid': '142185',
    'ip': '220.173.134.120',
    // 'ei': jsonEncode({'EVT_MSG': '所有IP都已经尝试失败,可以放弃治疗'}),
    'gid': 'k61uk8df90',
    'os': 'iOS',
    'ov': '13.3.1',
    // 'moonid': 'ijmtxxg4t',
    'message': message,
    'stack': stack?.toString()
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
    dio.post(url, data: data);
  });
}

void reportError(FlutterErrorDetails details) {
  print('reportError');
  // print(details);
  // sendReport(details.toString(), details.stack);
}

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
