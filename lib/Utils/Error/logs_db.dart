import 'package:sqflite/sqflite.dart';
import 'dart:convert';

class LogsDB {
  static Database _db;
  static const _table = 'report_failed_logs';
  // 失败上限
  static num maxFailTime = 10;
  // 日志最多存储10000条
  static const maxLength = 10000;
  static Future<Database> getDB() async {
    if (_db == null || !_db.isOpen) {
      _db = await openDatabase('flutter_logs.db');
    }
    try {
      String _sql = 'select * from $_table limit 0';
      await _db.rawQuery(_sql);
    } catch (e) {
      await _db.execute('''
            CREATE TABLE $_table (
              content TEXT,
              create_time INT(13)
            )
          ''');
    }

    return _db;
  }

  static dropTable([String table = _table]) async {
    _db = await getDB();
    String sql = 'DROP TABLE $table';
    try {
      await _db.execute(sql);
      print('drop table success');
    } catch (e) {
      print(e);
    }
    _db.close();
  }

  // 记录错误日志
  static Future record(List<Map<String, dynamic>> records) async {
    _db = await getDB();

    await _db.transaction((txn) async {
      var batch = txn.batch();

      batch.query(_table, columns: ['count(*) as count']);
      dynamic result = await batch.commit();

      num count = (result[0][0]['count'] ?? 0);
      print('错误日志数: $count');
      // 超过10000条不存储
      if (count < maxLength) {
        if (count + records.length > maxLength) {
          records = records.sublist(0, maxLength - count);
        }
        records.forEach((record) {
          record['upload_time'] = (record['upload_time'] ?? 0);
          // print('日志上报次数：${record['upload_time'].toString()}');
          if (record['upload_time'] < maxFailTime) {
            String content = jsonEncode(record);
            batch.insert(_table, {
              'content': content,
              'create_time': DateTime.now().millisecondsSinceEpoch
            });
          }
        });
      } else {
        print('超出最大数$maxLength');
        print(count);
      }
      await batch.commit(continueOnError: true, noResult: true);
    });

    _db.close();
  }

  // 取前n条数据
  static Future<List<Map<String, dynamic>>> takeData([num limit = 5]) async {
    _db = await getDB();
    List<Map<String, dynamic>> res = await _db.transaction((txn) async {
      var batch = txn.batch();

      batch.query(_table, columns: ['content'], limit: limit, offset: 0);
      dynamic results = await batch.commit();
      // String ids = (results[0] ?? []).map((record) => record['id']).join(',');
      // print('取出上报数据ids:');
      // print(ids);
      batch.rawDelete('DELETE FROM $_table limit 0, $limit');
      await batch.commit();

      return results[0] ?? [];
    });
    _db.close();
    return res;
  }
}
