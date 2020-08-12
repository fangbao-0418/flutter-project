class AppConfig {
  String device = "";
  String black = "";
  String token = "";
  String baseURL = "";
  String platform = "ios";

  ///App 电池栏高度
  double statusHeight = 20;

  ///App 导航栏高度（包含电池栏）
  double navHeight = 64;

  ///App 底部安全区域 默认 0  iOS X系列手机 34
  double bottomMargin = 0;

  ///App 版本
  String appVersion = "2.2.0";
  
  ///抓包代理 请查看自己本机IP地址 并替换
  String proxy = "PROXY 192.168.14.201:8888";

  ///网络超时时常
  int timeout = 10000;
  AppConfig._();
  static AppConfig _instance;
  static AppConfig getInstance() {
    if (_instance == null) {
      _instance = AppConfig._();
    }
    return _instance;
  }

  ///更新 baseURL device（手机信息） black（同盾）token platform （iOS or Android）
  static updateConfig(String baseURL, String device, String black, String token,
      String platform) {
    print(" updateConfig ==1=  " + baseURL);
    print(" updateConfig ==1=  " + device);
    print(" updateConfig ==1=  " + black);
    print(" updateConfig ==1=  " + token);
    print(" updateConfig ==1=  " + platform);
    AppConfig.getInstance();
    _instance.baseURL = baseURL;
    _instance.device = device;
    _instance.black = black;
    _instance.token = token;
    _instance.platform = platform;
    print(" token ==2=" + token);
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
}