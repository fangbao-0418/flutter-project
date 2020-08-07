import '../XTModel/UserInfoModel.dart';
import 'httpRequest.dart';

//用户资料请求
class XTUserInfoRequest {
  ///获取当前用户信息
  static Future<UserInfoModel> getUserInfoData() async {
    // 1.发送网络请求
    final url = "/cweb/member/getMember";
    final result = await HttpRequest.request(url, method: "get");
    final userModel = result["data"];
    UserInfoModel model = UserInfoModel.fromJson(userModel);
    print("object ----111" + model.nickName);
    return model;
  }

  /// 更新用户信息
  static Future<bool> updateUserInfo(Map<String, String> para) async {
    // 1.发送网络请求
    final url = "/cweb/member";
    final result = await HttpRequest.request(url, method: "put", params: para);
    // 2.json转modal
    final resl = result["data"];
    print("object ----" + resl.toString());
    return resl;
  }
}
