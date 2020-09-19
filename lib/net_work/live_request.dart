import 'package:xtflutter/net_work/http_request.dart';

class LiveRequest {

  /// 获取直播信息
  static Future<dynamic> getLiveInfoData() async {
    final url = "/live/list/station";
    final result = await HttpRequest.request(url, queryParameters:{"type":1});
    print(result);
    return result;
  }

  /// 获取主播信息
  static Future<dynamic> getUserInfoData() async {
    final url = "/live/station/anchor/info";
    final result = await HttpRequest.request(url);
    print(result);
    return result;
  }
}
