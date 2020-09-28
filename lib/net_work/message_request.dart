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
      queryParameters: <String, String>{
        "memberType": "${AppConfig.user?.memberType ?? 0}",
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

  static Future<List<MessageListDetailModel>> getMessageDetailList(
      String group) {
    final path = "/msg/$group/l";
    Future<List> future = HttpRequest.request(
      path,
    );
    return future.then((value) {
      final list = List<MessageListDetailModel>();
      value.forEach((element) {
        list.add(MessageListDetailModel.fromJson(element));
      });
      return list;
    });
  }
}
