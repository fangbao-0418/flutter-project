import 'package:xtflutter/net_work/http_request.dart';

class PromotionRequest {
  static Future<Map<dynamic, dynamic>> promotionMgic(String promotionId) async {
    final url = "/ncweb/magic/getMagic";
    return HttpRequest.request(url,
        method: "post",
        params: {"magicPageId": promotionId, "source": 1, "bizSource": "0"});
  }

  static Future<Map> promotionMgicData(String componentId, int page,
      {int pageSize = 10, String bizSource = "0"}) async {
    final url = "/ncweb/magic/getMagicData";
    return HttpRequest.request(url, method: "post", params: {
      "componentId": componentId,
      "source": "1",
      "pageSize": pageSize,
      "currentPage": page,
      "bizSource": bizSource
    });
  }

  // ncweb/yx/magic/getMagicData
}
