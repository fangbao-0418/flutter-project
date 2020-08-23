// import 'dart:async';
import 'Task.dart';
// import 'dart:async';
import 'package:xtflutter/Utils/Error/ReportError.dart';

class ReportLogsTask extends Task {
  // ReportLogsTask(): super();
  // @override
  exec () {
    super.exec();
    setIntival(Duration(seconds: 5), () {
      detectionUnSendLog();
      // num nowTime = DateTime.now().millisecondsSinceEpoch;
      // num endTime = DateTime(2020, 8, 23, 9, 23, 30).millisecondsSinceEpoch;
      // if (nowTime > endTime) {
      //   cancel();
      //   print('cancel');
      // }
    });
  }
}
