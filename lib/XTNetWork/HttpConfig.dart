class HttpConfig {

  String device;
  String black;
  String token;
  String baseURL;
  String platform;
  int timeout = 10000;
  HttpConfig._();
  static HttpConfig _instance;
  static HttpConfig getInstance() {
    if (_instance == null) {
      _instance = HttpConfig._();
    }
    return _instance;
  }
  void updateConfig(String baseURL, String dict, String black,
      String token, String platform) {
    _instance.baseURL = baseURL;
    _instance.device = dict;
    _instance.black = black;
    _instance.token = token;
    _instance.platform = platform;
  }

  void updateBaseUrl(String baseURL) {
    _instance.baseURL = baseURL;
  }

  void updateDeviceInfo(String dict) {
    _instance.device = dict;
  }

  void updateBlack(String black) {
    _instance.black = black;
  }

  void updateToken(String token) {
    _instance.token = token;
  }

  void updatePlatform(String platform) {
    _instance.platform = platform;
  }
}
