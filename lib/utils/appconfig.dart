import 'package:xtflutter/state/userinfo_vm.dart';
import 'package:xtflutter/model/userinfo_model.dart';
import 'package:xtflutter/net_work/local/proxy.dart';

///app配置的基本信息
class AppConfig {
  ///app配置的基本信息

  ///用户信息VM 当用户信息改变触发notifyListeners
  UserInfoVM userVM = UserInfoVM();

  ///app埋点基本信息
  AppSoftInfo softInfo = AppSoftInfo();

  ///http请求头信息
  String device = "";

  ///同盾black
  String black = "";

  ///当前用户token
  String token = localToken;

  ///app请求环境变量
  String baseURL = localBaseurl;

  ///平台
  String platform = "ios";

  ///添加测试
  ///App 电池栏高度
  double statusHeight = 25;

  ///App 导航栏高度（包含电池栏）56+25
  double navHeight = 81;

  ///App 底部安全区域 默认 0  iOS X系列手机 34
  double bottomMargin = 0;

  ///flutter 是不是以app模块运行
  bool isAppSubModule = false;

  ///App 版本
  String appVersion = "2.2.0";

  ///网络超时时常
  int timeout = 10000;

  ///省市区数据
  List<Map<String, dynamic>> cityName = [];
  List<Map<String, dynamic>> cityValue = [];

  //私有构造函数
  AppConfig._internal();

  //保存单例
  static AppConfig _instance = new AppConfig._internal();

  //工厂构造函数
  factory AppConfig() => _instance;

  static AppConfig getInstance() {
    return _instance;
  }

  ///更新http请求头
  static updateConfig(String baseURL, String device, String black, String token,
      String platform) {
    ///更新 baseURL device（手机信息） black（同盾）token platform （iOS or Android）

    ///防止未初始化
    AppConfig.getInstance();
    _instance.isAppSubModule = true;
    _instance.baseURL = baseURL;
    _instance.device = device;
    _instance.black = black;
    _instance.token = token;
    _instance.platform = platform;
  }

  ///更新埋点信息
  static updateSoftInfo(
      String av, String dv, String md, String gid, String os, String ov) {
    ///设置埋点  av dv md gid os ov
    ///
    ///防止未初始化
    AppConfig.getInstance();
    _instance.softInfo.av = av;
    _instance.softInfo.dv = dv;
    _instance.softInfo.md = md;
    _instance.softInfo.gid = gid;
    _instance.softInfo.os = os;
    _instance.softInfo.ov = ov;
    print(gid);
  }

  static updateBaseUrl(String baseURL) {
    ///更新网络
    _instance.baseURL = baseURL;
  }

  static updateDeviceInfo(String dict) {
    ///更新设备
    _instance.device = dict;
  }

  static updateBlack(String black) {
    ///更新黑盒
    _instance.black = black;
  }

  static updateToken(String token) {
    ///更新token
    _instance.token = token;
  }

  static updatePlatform(String platform) {
    ///更新平台
    _instance.platform = platform;
  }

  static updateStatusHeight(double height) {
    ///更新电池栏高度
    _instance.statusHeight = height;
  }

  static updateNavHeight(double height) {
    ///更新导航栏高度
    _instance.navHeight = height;
  }

  static updateBottomMargin(double height) {
    ///更新底部安全区域高度
    _instance.bottomMargin = height;
  }

  static updateVersion(String version) {
    ///更新app版本
    _instance.appVersion = version;
  }

  static updateCityNameList(List<Map<String, dynamic>> list) {
    ///更新省市区名称,picker滚动数据源
    _instance.cityName = list;
  }

  static updateCityValueList(List<Map<String, dynamic>> list) {
    ///更新省市区id列表
    _instance.cityValue = list;
  }

  static get statusH {
    ///状态栏高度
    return _instance.statusHeight;
  }

  static get navH {
    ///导航高度
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

  /// 是否登录
  static bool get isLogin {
    return (_instance.userVM.user != null && _instance.userVM.user.id != null && _instance.userVM.user.id > 0);
  }

  static AppSoftInfo get soft {
    return _instance.softInfo;
  }

  ///省市区城市名称
  static get cityNameList {
    return _instance.cityName;
  }

  ///省市区城市数据
  static get cityValueList {
    return _instance.cityValue;
  }

  /// 平台
  static get osPlatform {
    return _instance.platform;
  }
}

///埋点的信息
class AppSoftInfo {
  ///埋点的信息
  String av = "";
  String dv = "";
  String md = "";
  String gid = "";
  String os = "";
  String ov = "";
}
