import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

const logsDir = '/flutter/logs/';

// 找到正确的本地路径
Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

// 创建对日志目录位置的引用
Future<Directory> get _localLogDir async {
  final path = await _localPath;
  // print('$path/flutter/logs/');
  return Directory('$path/flutter/logs');
}

// 创建对文件位置的引用
Future<File> get _localFile async {
  final path = await _localPath;
  print(path);
  return new File('$path/flutter/logs.txt');
}

// 将数据写入文件
Future<File> record(List<String> data) async {
  final dir = await _localLogDir;
  print(dir);
  bool dirExists = await dir.exists();
  if (!dirExists) {
    await dir.create(recursive: true);
  }
  // print(dirExists);
  String text = data.join('\r\n');
  File file = new File('${dir.path}/logs.txt');
  // //, mode: FileMode.append
  print('record');
  print(text);
  return file.writeAsString('$text\r\n', mode: FileMode.append);
}

Future<List<String>> takeData() async {
  final dir = await _localLogDir;
  print(dir);
  File file = await dir.list().last;
  String contents = await file.readAsString();
  print('take data');
  print(contents);
  List<String> data = (contents.split('\r\n') ?? []).where((record) {
    try {
      jsonDecode(record);
      return true;
    } catch (e) {
      return false;
    }
  }).toList();
  return data;
}
