import 'dart:convert';

import 'package:flutter_boost/flutter_boost.dart';
import 'package:xtflutter/config/app_config/method_channel.dart';
import 'package:xtflutter/model/userinfo_model.dart';
import 'package:xtflutter/net_work/local/proxy.dart';
import 'package:xtflutter/utils/appconfig.dart';

/// App 事件监听类
class AppListener {
  /// App 事件监听类
  /// 切换网络环境
  /// 用户登录退出
  /// flutter 初始化 获取app基本信息

  ///客户端更新用户或者切换环境使用
  static void headerListener() {
    ///客户端更新用户或者切换环境使用
    FlutterBoost.singleton.channel.addEventListener('updateFlutterHeader',
        (name, arguments) {
      //todo
      print("updateFlutterHeader --- start");
      Map configMode = Map.from(arguments);
      print("updateFlutterHeader --- start" + configMode.toString());

      AppConfig.updateConfig(configMode["baseURL"], configMode["device"],
          configMode["black"], configMode["token"], configMode["platform"]);
      print("updateFlutterHeader --- end");
      return;
    });
  }

  ///客户端用户退出或者更换用户
  static void userinfoListener() {
    ///客户端用户退出或者更换用户
    FlutterBoost.singleton.channel.addEventListener('updateUserInfo',
        (name, arguments) {
      // UserInfoVM
      //todo
      print("updateUserInfo --- start");

      Map<String, dynamic> configMode = Map.from(arguments);
      print("updateFlutterHeader --- start" + configMode.toString());

      AppConfig.getInstance()
          .userVM
          .updateUser(UserInfoModel.fromJson(configMode));
      // print("updateFlutterHeader --- start" + configMode.toString());

      print(AppConfig.user.toJson().toString());
      print("updateUserInfo --- end");
      return;
    });
  }

  ///app启动初始化信息
  static void appInitInfo() {
    ///app启动初始化信息
    if (inApp) {
      getDeviceInfo();
      getUIInfo();
      getSoftInfo();
      getUserInfo();
    }
  }

  ///网络请求的基本信息
  static void getDeviceInfo() async {
    ///网络请求的基本信息
    var jsModel =
        new Map.from(await XTMTDChannel.invokeMethod("getNetWorkInfo"));
    print("-----get platform info-------" + jsModel.toString());
    AppConfig.updateConfig(jsModel["baseURL"], jsModel["device"],
        jsModel["black"], jsModel["token"], jsModel["platform"]);
    print("-----get platform info-------");
  }

  ///app的版本 状态栏 导航栏 底部间距
  static void getUIInfo() async {
    ///app的版本 状态栏 导航栏 底部间距
    /// baseURL 、device、black、token、platform
    var uiInfo = Map.from(await XTMTDChannel.invokeMethod("getUIInfo"));
    print("uiInfo" + uiInfo.toString());
    AppConfig.updateVersion(uiInfo["appVersion"]);
    AppConfig.updateStatusHeight(uiInfo["statusHeight"]);
    AppConfig.updateNavHeight(uiInfo["navHeight"]);
    AppConfig.updateBottomMargin(uiInfo["bottomMargin"]);
  }

  ///app登录用户信息
  static void getUserInfo() async {
    ///app登录用户信息
    String userInfo = await XTMTDChannel.invokeMethod("userInfo");

    Map<String, dynamic> tp =
        Map.from(json.decode(userInfo) as Map<String, dynamic>);

    AppConfig.getInstance().userVM.updateUser(UserInfoModel.fromJson(tp));
  }

  ///埋点统计用信息
  static void getSoftInfo() async {
    ///埋点统计用信息
    var map = await XTMTDChannel.invokeMethod("softInfo");
    print("softInfo ------- " + map.toString());
    AppConfig.updateSoftInfo(
        map["av"], map["dv"], map["md"], map["gid"], map["os"], map["ov"]);
  }

  /// 保存图片
  static void saveImage(Map<String, dynamic> params) async {
    var _ = await XTMTDChannel.invokeMethod("saveImg", params);
  }

  /// 分享微信小程序
  static void shareWechat(Map<String, dynamic> params) async {
    var _ = await XTMTDChannel.invokeMethod("shareWechat", params);
  }

  ///获取推送token
  static Future<String> getPushToken() async {
    return await XTMTDChannel.invokeMethod("getPushToken");
  }

  ///展示直播类分享弹框
  static void showLiveDialog(Map<String, dynamic> params) {
    XTMTDChannel.invokeMethod("showLiveDialog", params);
  }

 
}
