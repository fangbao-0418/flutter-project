import 'package:xtflutter/net_work/http_request.dart';

class PromotionRequest {
  static Future<dynamic> promotionMgic(String promotionId) async {
    final url = "/ncweb/yx/magic/getMagic";
    final data = HttpRequest.request(url,
        method: "post", params: {"magicPageId": promotionId, "source": "1"});
    return data;
  }
  static Future<dynamic> promotionMgicData(String componentId,int page) async {
    final url = "/ncweb/yx/magic/getMagicData";
    final data = HttpRequest.request(url,
        method: "post", params: {"componentId": componentId, "source": "1", "pageSize": 10, "currentPage": page});
    return data;

  
}
  }

  // ncweb/yx/magic/getMagicData
}
