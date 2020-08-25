import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import './LogsDB.dart';

const logsDir = '/flutter/logs/';

// 找到正确的本地路径
Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

// 创建对日志目录位置的引用
Future<Directory> get _localLogDir async {
  final path = await _localPath;
  return Directory('$path/flutter/logs');
}

// 创建对文件位置的引用
Future<File> get _localFile async {
  final path = await _localPath;
  return new File('$path/flutter/logs.txt');
}

// 将数据写入文件
Future record(List<Map<String, dynamic>> xtLogData) async {
  LogsDB.record(xtLogData);
}

Future<List<String>> takeData([num logNum = 5]) async {
  List<Map<String, dynamic>> res = await LogsDB.takeData();
  return res.map<String>((item) {
    return item['content'];
  }).toList();
}
