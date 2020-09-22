/// String util
/// create by yuanl at 2020/09/22
class StringUtils {
  StringUtils._();

  static bool isEmpty(String source) {
    return !isNotEmpty(source);
  }

  static bool isNotEmpty(String source) {
    return source != null && source.length > 0;
  }
}
