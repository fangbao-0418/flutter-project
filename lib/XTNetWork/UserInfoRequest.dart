import 'package:flutter/material.dart';

import '../XTModel/UserInfoModel.dart';
import 'httpRequest.dart';

//用户资料请求
class XTUserInfoRequest {
  ///获取当前用户信息
  static Future<UserInfoModel> getUserInfoData() async {
    // 1.发送网络请求
    final url = "/cweb/member/getMember";
    final result = await HttpRequest.request(url);
    final userModel = result["data"];
    UserInfoModel model = UserInfoModel.fromJson(userModel);
    print("getMember ----" + model.toJson().toString());
    return model;
  }

  /// 更新用户信息
  static Future<bool> updateUserInfo(Map<String, String> para) async {
    // 1.发送网络请求
    final url = "/cweb/member";
    final result = await HttpRequest.request(url, method: "put", params: para);
    // 2.json转modal
    final resl = result["data"];
    print("/cweb/member ----" + resl.toString());
    return resl;
  }

  // 发送验证码
  static Future<dynamic> sendCode({@required String phone, num flag = 3}) {
    const url = "/bweb/member/getVerifyCode";
    return HttpRequest.request(url,
        method: "post",
        queryParameters: {"phone": phone, "flag": flag}).then((res) {
      if (res['code'] == '00000' && res['success']) {
        return res['data'];
      } else {
        throw res;
      }
    });
  }

  // 更换手机号
  static Future<dynamic> changeUserPhone(String phone, String code) {
    const url = "/bweb/member/update/mobile";
    return HttpRequest.request(url,
        method: "post",
        queryParameters: {"mobile": phone, "code": code}).then((res) {
      if (res['code'] == '00000' && res['success']) {
        return res['data'];
      } else {
        throw res;
      }
    });
  }
}
