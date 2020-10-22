import 'package:flutter/services.dart';

const MethodChannel XTMTDChannel = MethodChannel('flutter_native_channel');

///展示活动分享弹框
void showPromotion(Map<String, dynamic> params) {
  XTMTDChannel.invokeMethod("showPromotion", params);
}
