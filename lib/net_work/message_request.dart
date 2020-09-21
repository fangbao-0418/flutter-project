import 'package:xtflutter/Utils/appconfig.dart';
import 'package:xtflutter/model/message_model.dart';
import 'package:xtflutter/net_work/http_request.dart';

// message request class
// create by yuanl at 2020/09/18
class MessageRequest {
  static Future<List<MessageBriefModel>> getMesageList() {
    final path = "/msg/groups/briefly";
    Future<List> future = HttpRequest.request<List>(
      path,
      queryParameters: <String, dynamic>{
        "memberType": AppConfig.user.memberType,
      },
    );
    return future.then((value) {
      final list = List<MessageBriefModel>();
      value.forEach((element) {
        list.add(MessageBriefModel.fromJson(element));
      });
      return list;
    });
  }
}
