import 'package:xtflutter/ProviderVM/UserInfoVM.dart';
import 'package:xtflutter/XTModel/UserInfoModel.dart';
import 'package:xtflutter/local/proxy.dart';

class AppConfig {
  UserInfoVM userVM = UserInfoVM();

  AppSoftInfo softInfo = AppSoftInfo();

  ///是不是app的subModule
  bool isAppSubModule = false;
  String device = "";
  String black = "";
  String token = localToken;
  String baseURL = localBaseurl;
  String platform = "ios";

  ///添加测试
  ///App 电池栏高度
  double statusHeight = 20;

  ///App 导航栏高度（包含电池栏）
  double navHeight = 64;

  ///App 底部安全区域 默认 0  iOS X系列手机 34
  double bottomMargin = 0;

  ///App 版本
  String appVersion = "2.2.0";

  ///网络超时时常
  int timeout = 10000;

  //私有构造函数
  AppConfig._internal();

  //保存单例
  static AppConfig _instance = new AppConfig._internal();

  //工厂构造函数
  factory AppConfig() => _instance;

  static AppConfig getInstance() {
    return _instance;
  }

  ///更新 baseURL device（手机信息） black（同盾）token platform （iOS or Android）
  static updateConfig(String baseURL, String device, String black, String token,
      String platform) {
    AppConfig.getInstance();
    _instance.isAppSubModule = true;
    _instance.baseURL = baseURL;
    _instance.device = device;
    _instance.black = black;
    _instance.token = token;
    _instance.platform = platform;
    print(" token ==2=" + token);
  }

  static updateSoftInfo(
      String av, String dv, String md, String gid, String os, String ov) {
    AppConfig.getInstance();
    _instance.softInfo.av = av;
    _instance.softInfo.dv = dv;
    _instance.softInfo.md = md;
    _instance.softInfo.gid = gid;
    _instance.softInfo.os = os;
    _instance.softInfo.ov = ov;
  }

  static updateBaseUrl(String baseURL) {
    _instance.baseURL = baseURL;
  }

  static updateDeviceInfo(String dict) {
    _instance.device = dict;
  }

  static updateBlack(String black) {
    _instance.black = black;
  }

  static updateToken(String token) {
    _instance.token = token;
  }

  static updatePlatform(String platform) {
    _instance.platform = platform;
  }

  static updateStatusHeight(double height) {
    _instance.statusHeight = height;
  }

  static updateNavHeight(double height) {
    _instance.navHeight = height;
  }

  static updateBottomMargin(double height) {
    _instance.bottomMargin = height;
  }

  static updateVersion(String version) {
    _instance.appVersion = version;
  }

  ///状态栏高度
  static get statusH {
    return _instance.statusHeight;
  }

  ///导航高度
  static get navH {
    return _instance.navHeight;
  }

  ///安全区域
  static get bottomH {
    return _instance.bottomMargin;
  }

  ///App版本
  static get version {
    return _instance.appVersion;
  }

  static UserInfoModel get user {
    return _instance.userVM.user;
  }

  static get soft {
    return _instance.softInfo;
  }
}

class AppSoftInfo {
  String av = "";
  String dv = "";
  String md = "";
  String mid = "";
  String gid = "";
  String os = "";
  String ov = "";
}
