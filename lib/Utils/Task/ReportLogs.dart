import 'Task.dart';
import 'package:xtflutter/Utils/Error/ReportError.dart';

class ReportLogsTask extends Task {
  // ReportLogsTask(): super();
  // @override
  exec() {
    super.exec();
    setIntival(Duration(seconds: 60), () {
      ///日志上传
      // detectionUnSendLog();
    });
  }
}
