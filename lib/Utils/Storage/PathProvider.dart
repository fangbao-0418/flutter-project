import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

// 找到正确的本地路径
Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

// 创建对文件位置的引用
Future<File> get _localFile async {
  final path = await _localPath;
  return new File('$path/counter.txt');
}

// 将数据写入文件
Future<File> writeCounter(int counter) async {
  final file = await _localFile;
  // Write the file
  return file.writeAsString('$counter');
}

// 从文件中读取数据
Future<int> readCounter() async {
  try {
    final file = await _localFile;
    // Read the file
    String contents = await file.readAsString();

    return int.parse(contents);
  } catch (e) {
    // If we encounter an error, return 0
    return 0;
  }
}