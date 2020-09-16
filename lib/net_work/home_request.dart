import 'package:xtflutter/model/home_limit_seckill.dart';
import 'http_request.dart';

class HomeRequest {

  static Future<Map<String, dynamic>> getSeckillListReq(Map<String, dynamic> params) async {
    const url = "/ncweb/product/promotion/seckill/list/v4";
    List<LimitTimeSeckillModel> list = [];
    int defaultIndex = 0;
    final result = await HttpRequest.request(url, queryParameters: params, hideErrorToast: false);
    List models = result;
    for (var i = 0; i < models.length; i++) {
      LimitTimeSeckillModel model = LimitTimeSeckillModel.fromJson(models[i]);
      list.add(model);
      if (model.defaultSelected) {
        defaultIndex = i;
      }
    }
    return {"dataList": list, "defaultIndex": defaultIndex};
  }

  static Future<String> seckillMegSub(Map<String, dynamic> params) async {
    const url = "/ncweb/promotion/message/subscribe";
    final result = await HttpRequest.request(url, method: "post", params: params, hideErrorToast: false);
    return result as String;
  }

}