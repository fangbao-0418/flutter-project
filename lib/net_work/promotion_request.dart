import 'package:xtflutter/net_work/http_request.dart';

class PromotionRequest {
  static Future<Map<dynamic, dynamic>> promotionMgic(String promotionId) async {
    final url = "/ncweb/magic/getMagic";
    return HttpRequest.request(url,
        method: "post",
        params: {"magicPageId": promotionId, "source": 1, "bizSource": "0"});
  }

  static Future<Map> promotionMgicData(String componentId, int page,
      {int pageSize = 10, String bizSource = "0", String source = "1"}) async {
    final url = "/ncweb/magic/getMagicData";
    return HttpRequest.request(url, method: "post", params: {
      "componentId": componentId,
      "source": source,
      "pageSize": pageSize,
      "currentPage": page,
      "bizSource": bizSource
    });
  }

  /// 领取优惠券
  static Future<Map<String, dynamic>> couponReceiveReq(
      Map<String, dynamic> params) async {
    const url = "/cweb/coupon/receiveByCode";
    final result = await HttpRequest.request(url,
        method: "post", params: params, hideErrorToast: false);
    bool isReceive = result["nc"] == null ? false : result["nc"];
    String msg = result["msg"] == null ? "" : result["msg"];
    return {"isReceive": isReceive, "msg": msg};
  }
}
