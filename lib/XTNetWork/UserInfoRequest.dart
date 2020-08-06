import '../XTModel/UserInfoModel.dart';
import 'httpRequest.dart';

//用户资料请求
class XTUserInfoRequest {
  static Future<UserInfoModel> getUserInfoData() async {
    // 1.发送网络请求
    final url = "/cweb/member/getMember";
    final result = await HttpRequest.request(url, "get", null, null);
    // 2.json转modal
    final userModel = result["data"];
    UserInfoModel model = UserInfoModel.fromJson(userModel);
    print("object ----" + model.headImage);
    return model;
  }

  static Future<bool> updateUserInfo(Map<String, String> para) async {
    // 1.发送网络请求
    final url = "/cweb/member";
    final result = await HttpRequest.request(url, "put", para, null);
    // 2.json转modal
    final resl = result["data"];
    print("object ----" + resl.toString());
    return resl;
  }
}
