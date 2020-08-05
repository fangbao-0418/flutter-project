import '../XTModel/UserInfoModel.dart';
import 'httpRequest.dart';

//用户资料请求
class XTUserInfoRequest {
  static Future<UserInfoModel> getUserInfoData() async {
    // 1.发送网络请求
    final url = "/cweb/member/getMember";
    final result = await HttpRequest.request(url);
    // 2.json转modal
    final userModel = result["data"];
    UserInfoModel model = UserInfoModel.fromJson(userModel);
    print("object ----" + model.headImage);
    return model;
  }
}
