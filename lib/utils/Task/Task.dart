import 'dart:async';
import 'package:flutter/material.dart';

import 'logs_report.dart';

class Task {
  Timer t;
  static List<dynamic> _tasks = [];
  Task() {
    print('constructor');
  }
  void cancel() {
    t?.cancel();
  }

  Function setIntival(Duration duration, cb) {
    t = new Timer.periodic(duration, (timer) {
      cb();
    });
    return () {
      t.cancel();
    };
  }

  static init() {
    Task.cancelAll();
    ReportLogsTask().exec();
  }

  static void cancelAll() {
    _tasks.forEach((task) {
      task.cancel();
    });
    _tasks = [];
  }

  @protected
  exec() {
    _tasks.add(this);
  }
}