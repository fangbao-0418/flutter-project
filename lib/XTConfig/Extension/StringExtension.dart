const appNameStr = "喜团";

extension XtString on String {
  /// 拼接腾讯云图片前缀
  String get imgUrl {
    return "https://sh-tximg.hzxituan.com/" + this;
  }

  String get safeStr {
    return this == null ? "" : this;
  }

  bool get xtEmpty {
    if (null == this) {
      return true;
    } else {
      var tp = this.trim();
      if ("" == tp) {
        return true;
      } else {
        return false;
      }
    }
  }
}
