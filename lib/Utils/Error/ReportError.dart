import 'dart:math';
import 'package:xtflutter/XTConfig/AppConfig/AppConfig.dart';
import 'package:dio/dio.dart';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:xtflutter/Utils/Global.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'dart:async';
import 'package:crypto/crypto.dart';
import 'package:xtflutter/local/helper.dart' as local;
import 'package:xtflutter/Utils/Storage/SharedPreferences.dart';
import './XtError.dart';

/**
 * ios ijmtxxg4t
 * android pn8njdku4
 * api https://rlcas.hzxituan.com/
 */
const moonid = 'ijmtxxg4t';

// 上报数据大小 200kb
const maxUploadSize = 1024 * 200;

String baseUrl = 'https://rlcas.hzxituan.com';

Future _sendRequest(Map<String, dynamic> info) {
  final List<dynamic> xtLogdata = [];
  xtLogdata.add(info);
  final data = {'env': 'test', 'xt_logdata': xtLogdata};

  final url = baseUrl + "/rlcas/ijmtxxg4t";
  Dio dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: 10000,
      headers: {'referer': 'https://myouxuan.hzxituan.com/'}));
  local.helper(dio);

  // return dio.post(url, data: data).then((v) {
  //   print('send report success');
  //   _detectionUnSendLog();
  // }, onError: (e) {
  //   collectData(jsonEncode(info));
  //   print('send report failed');
  // });
  return Future.value();
}

void sendReport(
    {String message, String req, String res, StackTrace stack, int timestamp}) {
  if (!Global.isDebugger) {
    return;
  }
  timestamp = timestamp ?? new DateTime.now().millisecondsSinceEpoch;

  String stackString = stack?.toString() ?? '';
  List<String> stackList = stackString.split(new RegExp(r'[\t\r\n\v]'));
  stackString = stackList.sublist(0, min(stackList.length, 10)).join('\r\n');
  Map<String, dynamic> info = {
    'flutter': true,
    'env': 'prod',
    't': 'error',
    'ap': 'AppStore',
    'at': timestamp,
    'av': AppConfig.soft.av,
    'dv': AppConfig.soft.dv,
    'md': AppConfig.soft.md,
    'mid': AppConfig.user.id,
    // 'ip': '220.173.134.120',
    'gid': AppConfig.soft.gid,
    'os': AppConfig.soft.os,
    'ov': AppConfig.soft.ov,
    'message': message,
    'stack': stackString,
    '_res': res,
    '_req': req
  };

  new Timer(Duration(microseconds: 100), () {
    String infoStr = jsonEncode(info);
    if (infoStr.length > maxUploadSize) {
      // 数据大的情况下拆解数据上传
      _sectionSend(info);
    } else {
      _sendRequest(info);
    }
  });
}

Map<String, dynamic> _getBaseInfo() {
  return {
    'flutter': true,
    'env': 'prod',
    't': 'error',
    'ap': 'AppStore',
    'av': AppConfig.soft.av,
    'dv': AppConfig.soft.dv,
    'md': AppConfig.soft.md,
    'mid': AppConfig.user.id,
    // 'ip': '220.173.134.120',
    'gid': AppConfig.soft.gid,
    'os': AppConfig.soft.os,
    'ov': AppConfig.soft.ov,
  };
}

// md5 加密
String _generateMd5(String data) {
  var content = new Utf8Encoder().convert(data);
  var digest = md5.convert(content);
  // 这里其实就是 digest.toString()
  return hex.encode(digest.bytes);
}

void _sectionSend(Map<String, dynamic> info) {
  Map<String, dynamic> baseInfo = _getBaseInfo();
  String id = _generateMd5(baseInfo.toString());
  int totalSize = jsonEncode(baseInfo).length;
  // 每部分数据量
  int partialSize = maxUploadSize - baseInfo.length;
  // 分割长度
  int len = (totalSize / partialSize).floor();
  String ds = jsonEncode({
    'message': info['message'],
    'stack': info['stack'],
    '_res': info['_res'],
    '_req': info['_req']
  });
  List<Map<String, dynamic>> rows = [];
  List.generate(len, (i) {
    int start = i * maxUploadSize;
    int end = min((i + 1) * maxUploadSize, ds.length);
    String content = ds.substring(start, end);
    String message = "${id}__part" + i.toString() + ": " + content;
    Map<String, dynamic> info;
    info.addAll({
      ...baseInfo,
      'message': message,
    });
    rows.add(info);
    // rows.map(())
    _sendRequest(rows[0]).whenComplete(() {
      //
    });
  });
}

// 检测未成功的日志
void _detectionUnSendLog() {
  Prefs.getStringList('xt-logdata').then((data) {
    if (data.length > 0) {
      if (data[0].length > 1024 * 200) {
        data.removeAt(0);
      }
      final info = jsonDecode(data[0]);
      _sendRequest(info).then((res) {
        data.removeAt(0);
        Prefs.setStringList('xt-logdata', data);
      });
    }
  });
}

void collectData(String data) async {
  List<String> xtLogdata = await Prefs.getStringList('xt-logdata') ?? [];
  xtLogdata.add(data);
  Prefs.setStringList('xt-logdata', xtLogdata);
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
