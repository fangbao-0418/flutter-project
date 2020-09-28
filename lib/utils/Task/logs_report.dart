import 'task.dart';
import 'package:xtflutter/utils/error/error_report.dart';

class ReportLogsTask extends Task {
  // ReportLogsTask(): super();
  // @override
  exec() {
    super.exec();
    setIntival(Duration(seconds: 60), () {
      ///日志上传
      detectionUnSendLog();
    });
  }
}
