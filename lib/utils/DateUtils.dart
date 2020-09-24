import 'package:intl/intl.dart';

// 时间工具类
// create by yuanl at 2020/09/21
class DateUtils {
  DateUtils._();

  static const DEFATUL_PATTERN = "yyyy-MM-dd hh:mm:ss";

  static int now() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  static String formatMs(int milliseconds) {
    var input = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    var formatter = DateFormat(DEFATUL_PATTERN);
    return formatter.format(input);
  }

  static String formatDate(DateTime dateTime) {
    var formatter = DateFormat(DEFATUL_PATTERN);
    return formatter.format(dateTime);
  }

  static String formatMsByPattern(int milliseconds, String pattern) {
    var input = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    var formatter = DateFormat(pattern);
    return formatter.format(input);
  }

  static String formatDateByPattern(DateTime dateTime, String pattern) {
    var formatter = DateFormat(DEFATUL_PATTERN);
    return formatter.format(dateTime);
  }
}
