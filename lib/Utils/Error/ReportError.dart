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
import './CollectData.dart' as Collection;
import './XtError.dart';

//
// ios ijmtxxg4t
// android pn8njdku4
// env https://rlcas.hzxituan.com/  prod https://test-rlcas.hzxituan.com/

const TO_REPORT = true;
const moonid = 'ijmtxxg4t';
const XT_LOGDATA_KEY = 'xt-logdata';
final logEnv = Global.isRelease ? 'prod' : 'test';
// 分段上传数据量阙值，文字修饰(__part{n})+固定格式({"env":"prod","xt-logdata":[]})+最大3位数分段量编号合计30左右
const threshold = 100;
// 上报数据大小 200kb
const maxUploadSize = 10 * 1024;
// 最大分段上传个数，超出丢弃
const maxSectionNum = 5;
// 上报超时时长单位毫秒
const connectTimeout = 10000;
// 上报成功后延时监测未发送日志时长，单位毫秒
const inspectDelay = 1000;
final baseUrl = Global.isRelease
    ? 'https://rlcas.hzxituan.com'
    : 'https://test-rlcas.hzxituan.com';

// 发送上报请求
Future _sendRequest(List<String> info) {
  final List xtLogdata = info.map((text) => jsonDecode(text)).toList();
  // 如果修改固定格式，根据实际情况修改上报数据阙值
  final data = {'env': logEnv, 'xt_logdata': xtLogdata};

  String dataStr = jsonEncode(data);
  if (dataStr.length > maxUploadSize) {
    // 数据大的情况下拆解数据上传
    _sectionSend(info);
    return Future.error('send report failed, The data is too large');
  }
  final url = baseUrl + "/rlcas/ijmtxxg4t";
  Dio dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
      headers: {'referer': 'https://myouxuan.hzxituan.com/'}));
  local.helper(dio);
  print('send report start');
  return dio.post(url, data: data).then((v) {
    print('send report success');
    // 上报成功监测是否存在未发送日志
    Future.delayed(Duration(milliseconds: inspectDelay), () {
      _detectionUnSendLog();
    });
  }, onError: (e) {
    _collectData(info);
    print('send report failed');
    // throw e;
  });
}

// 数据上报
void _sendReport(
    {String message, String req, String res, StackTrace stack, int timestamp}) {
  if (!Global.isDebugger) {
    return;
  }

  String stackString = stack?.toString() ?? '';
  List<String> stackList = stackString.split(new RegExp(r'[\t\r\n\v]'));
  // 提取前10错误栈信息
  stackString = stackList.sublist(0, min(stackList.length, 10)).join('\r\n');

  Map<String, dynamic> baseInfo = _getBaseInfo();
  Map<String, dynamic> info = {
    ...baseInfo,
    'message': message,
    'stack': stackString,
    '_res': res,
    '_req': req
  };
  Future.delayed(Duration(milliseconds: 100), () {
    _sendRequest([jsonEncode(info)]);
  });
}

// 获取基本上报数据信息
Map<String, dynamic> _getBaseInfo() {
  Map<String, dynamic> baseInfo = {
    'flutter': true,
    'env': logEnv,
    't': 'error',
    'ap': 'AppStore',
    'av': AppConfig.soft.av,
    'dv': AppConfig.soft.dv,
    'md': AppConfig.soft.md,
    'mid': AppConfig.user.id,
    'at': new DateTime.now().millisecondsSinceEpoch,
    // 'ip': '220.173.134.120',
    'gid': AppConfig.soft.gid,
    'os': AppConfig.soft.os,
    'ov': AppConfig.soft.ov,
  };
  if (baseInfo.toString().length > maxUploadSize) {
    return {
      'flutter': true,
      'env': logEnv,
      't': 'error',
      'overflow': baseInfo.toString().length
    };
  }
  return baseInfo;
}

// md5 加密
String _generateMd5(String data) {
  var content = new Utf8Encoder().convert(data);
  var digest = md5.convert(content);
  // 这里其实就是 digest.toString()
  return hex.encode(digest.bytes);
}

List<String> divisionRecord(String text) {
  List<String> rows = [];
  Map<String, dynamic> baseInfo = _getBaseInfo();
  Map<String, String> info = jsonDecode(text);
  String id = _generateMd5(info.toString());
  // 每部分可上传数据量，20是阙值
  int partialSize =
      maxUploadSize - baseInfo.toString().length - id.length - threshold;
  print('partialSize');
  print(partialSize);
  print(baseInfo.toString().length);
  if (partialSize <= 0) {
    return;
  }
  // 拆分有效数据字符串，分到每段数报message字段上
  String ds = jsonEncode({
    'message': info['message'],
    'stack': info['stack'],
    '_res': info['_res'],
    '_req': info['_req']
  });
  int totalSize = ds.length;
  // 分割长度
  int len = min((ds.length / partialSize).ceil(), maxSectionNum);

  List.generate(len, (i) {
    int start = i * partialSize;
    int end = min((i + 1) * partialSize, ds.length);
    //  print('i: ${i} totalSize: ${totalSize} baseInfo: ${baseInfo.toString().length} partialSize: ${partialSize}  start: ${start} end: ${end}');
    if (start < totalSize) {
      String content = ds.substring(start, end);
      String message = "${id}__part" + i.toString() + ": " + content;
      print(message);
      Map<String, dynamic> info = {};
      info.addAll({
        ...baseInfo,
        'message': message,
      });
      rows.add(jsonEncode(info));
    }
  });
  return rows;
}

// 分段发送
void _sectionSend(List<String> list) {
  // 分批上传合并的数据集合
  List<List<String>> result = [];
  // 单次上报的数据集合
  List<String> records = [];
  list.forEach((text) {
    // 单次数据集合先填充，填充超限即完成
    records.add(text);
    if (records.toString().length > maxUploadSize) {
      // 超出回退添加项
      records.removeLast();
      if (records.length > 0) {
        result.add(records);
        // 置空单词上报，重新填充单次上报数据
        records = [];
      } else {
        // 单次上报数据为0，即text单条超限需进行分割
        // result.addAll(divisionRecord(text));
      }
    }
  });
  // Map<String, dynamic> info

  // 分段发送请求，第一个请求发送完成后，再发送下一个
  loop() {
    // _sendRequest([rows[0]]).whenComplete(() {
    //   rows.removeAt(0);
    //   if (rows.length > 0) {
    //     Future.delayed(new Duration(milliseconds: 5000), () {
    //       loop();
    //     });
    //   }
    // });
  }

  loop();
}

// 检测未成功的日志
void _detectionUnSendLog() {
  Prefs.getStringList(XT_LOGDATA_KEY).then((data) {
    print('待上报日志数量：${data.length}');
    if (data.length > 0) {
      if (data[0].length > 1024 * 200) {
        data.removeAt(0);
      }
      final info = jsonDecode(data[0]);
      _sendRequest(info).then((res) {
        data.removeAt(0);
        Prefs.setStringList(XT_LOGDATA_KEY, data);
      });
    }
  });
}

// 收集失败数据
void _collectData(List<String> info) async {
  Collection.record(info);
}

// TODO
void throwError(Error error) {}

// 上报flutter错误
void reportError(FlutterErrorDetails details) {
  if (!TO_REPORT) {
    return;
  }
  _sendReport(message: details.toString(), stack: details.stack);
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
    _sendReport(req: req, res: res, message: message, timestamp: timestamp);
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
    _sendReport(req: req, res: res, message: dioError.toString());
  } else if (xTNetErrorType == XTNetErrorType.SYNTAX_ERROR) {
    Error error = xtNetError.error;
    _sendReport(message: error.toString(), stack: error.stackTrace);
  }
}
