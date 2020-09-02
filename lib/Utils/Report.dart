import 'package:dio/dio.dart';
import 'package:xtflutter/utils/global.dart';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'dart:async';
import 'package:convert/convert.dart';
import 'package:xtflutter/local/helper.dart' as local;
import 'error/collect_data.dart' as Collection;
import 'package:xtflutter/xt_config/app_config/appconfig.dart';

// 是否上报数据
const TO_REPORT = true;

const moonid = 'ijmtxxg4t';
const XT_LOGDATA_KEY = 'xt-logdata';
final logEnv = Global.isRelease ? 'prod' : 'test';
// 分段上传数据量阙值，文字修饰(__part{n})+固定格式({"env":"prod","xt-logdata":[]})+最大3位数分段量编号合计50左右
const threshold = 80;
// 上报数据大小 150kb
const maxUploadSize = 150 * 1024;
// 最大分段上传个数，丢入任务进行上报
const maxSectionNum = 5;
// 上报超时时长单位毫秒
const connectTimeout = 5000;
// 上报成功后延时监测未发送日志时长，单位毫秒
const inspectDelay = 1000;
final baseUrl = Global.isRelease
    ? 'https://rlcas.hzxituan.com'
    : 'https://test-rlcas.hzxituan.com';

// 发送上报请求
Future sendReportRequest(List<Map<String, dynamic>> xtLogdata) {
  if (!TO_REPORT) {
    return Future.value();
  }
  // 如果修改固定格式，根据实际情况修改上报数据阙值
  final data = {'env': logEnv, 'xt_logdata': xtLogdata};
  String dataStr = jsonEncode(data);
  if (dataStr.length > maxUploadSize + threshold) {
    // 数据大的情况下拆解数据上传
    print('上报数据长度：${dataStr.length.toString()}');
    _sectionSend(xtLogdata);
    return Future.error('send report failed, The data is too large');
  }
  final url = baseUrl + "/rlcas/ijmtxxg4t";
  Dio dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
      headers: {'referer': 'https://myouxuan.hzxituan.com/'}));
  local.helper(dio);
  // print('send report start');
  return dio.post(url, data: data).then((v) {
    print('send report success');
  }, onError: (e) {
    print('send report failed');
    print('________日志收集________');
    print('日志数：${xtLogdata.length.toString()}');
    _collectData(xtLogdata);
    // print('send report failed num: ${xtLogdata.length}');
    // throw e;
  });
}

// 页面追溯
void tracePage(String url, Map<String, dynamic> param) {
  url = 'flutter://' + url;

  Map<String, dynamic> data = {
    ...getBaseInfo(),
    't': 'pu',
    'pageurl': url,
    'param': param != null ? param.toString() : null
  };
  sendReportRequest([data]);
}

// md5 加密
String _generateMd5(String data) {
  var content = new Utf8Encoder().convert(data);
  var digest = md5.convert(content);
  // 这里其实就是 digest.toString()
  return hex.encode(digest.bytes);
}

// 分割单条超限数据的日志
List<Map<String, dynamic>> _divisionRecord(Map<String, dynamic> record) {
  List<Map<String, dynamic>> rows = [];
  Map<String, dynamic> baseInfo = getBaseInfo();

  String id = _generateMd5(record.toString());
  // 每部分可上传数据量，threshold是阙值
  int partialSize = maxUploadSize - baseInfo.toString().length - threshold;
  if (partialSize <= 0) {
    return [];
  }
  // 拆分有效数据字符串，分到每段数报message字段上
  String ds = jsonEncode({
    'message': record['message'],
    'stack': record['stack'],
    '_res': record['_res'],
    '_req': record['_req']
  });

  int totalSize = ds.length;
  // 分割长度
  int len = (totalSize / partialSize).ceil();
  print(
      'len: $len, totalSize: $totalSize, partialSize: $partialSize, base len: ${baseInfo.toString().length + id.length}');
  List.generate(len, (i) {
    int start = i * partialSize;
    int end = min((i + 1) * partialSize, ds.length);
    //  print('i: ${i} totalSize: ${totalSize} baseInfo: ${baseInfo.toString().length} partialSize: ${partialSize}  start: ${start} end: ${end}');
    if (start < totalSize) {
      String content = ds.substring(start, end);
      Map<String, dynamic> info = {};
      info.addAll({
        ...baseInfo,
        'g': id + '_' + (i + 1).toString() + "_" + len.toString(),
        'message': content,
      });
      rows.add(info);
    }
  });

  print('段数: ');
  print(record.toString().length);
  print(rows.length);
  return rows;
}

// 分段发送
// scene1 多条数据(xt-logdata)合并上传超限, 分拆集合
// secene2, 单条超限，分割单条
void _sectionSend(List<Map<String, dynamic>> xtLogData) {
  // 分批上传合并的数据集合
  List<List<Map<String, dynamic>>> result = [];
  // 单次上报的数据集合
  List<Map<String, dynamic>> records = [];
  xtLogData.forEach((record) {
    // 单次数据集合先填充，填充超限即完成
    records.add(record);
    if (records.toString().length > maxUploadSize + threshold) {
      // 超出回退添加项
      records.removeLast();
      //
      if (records.length > 0) {
        result.add(records);
        // 置空单词上报，重新填充单次上报数据
        records = [];
      } else {
        // 单次上报数据为0，即text单条超限需进行分割
        result.addAll(_divisionRecord(record).map((val) => [val]));
      }
    }
  });
  // print(result);
  // 分段发送请求，第一个请求发送完成后，再发送下一个
  //
  result.forEach((records) {
    print('分割后每段大小');
    print(records.toString().length);
  });
  print('数据超限分块数: ${result.length.toString()}');
  if (result.length > maxSectionNum) {
    // 收集超出分块上报上限数据
    records = [];
    result.sublist(maxSectionNum).forEach((item) {
      records.addAll(item);
    });
    _collectData(records);
    records = [];

    result = result.sublist(0, maxSectionNum);
  }
  sequenceRequest(result);
}

// 多个请求顺序上传
void sequenceRequest(List<List<Map<String, dynamic>>> data) {
  loop() {
    if (data.length == 0) {
      return;
    }
    sendReportRequest(data[0]).whenComplete(() {
      data.removeAt(0);
      if (data.length > 0) {
        Future.delayed(new Duration(milliseconds: 500), () {
          loop();
        });
      }
    });
  }

  loop();
}

// 收集失败数据
void _collectData(List<Map<String, dynamic>> xtLogData) async {
  print('________日志收集________');
  print('日志数：${xtLogData.length.toString()}');
  Collection.record(xtLogData);
}

// 获取基本上报数据信息
Map<String, dynamic> getBaseInfo() {
  Map<String, dynamic> baseInfo = {
    'flutter': true,
    'env': logEnv,
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
