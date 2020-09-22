import 'dart:io';

import 'package:flutter/material.dart';

/// 去除Android上ScrollView的两边滚动水波纹效果
/// create by yuanl at 2020/09/22
class DefaultBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    if (Platform.isAndroid || Platform.isFuchsia) {
      return child;
    }
    return super.buildViewportChrome(context, child, axisDirection);
  }
}