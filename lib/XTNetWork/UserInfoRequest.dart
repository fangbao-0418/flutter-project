import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../XTModel/UserInfoModel.dart';
import 'httpRequest.dart';

/// 用户资料请求
class XTUserInfoRequest {
  /// 获取当前用户信息
  static Future<dynamic> getUserInfoData() async {
    final url = "/cweb/member/getMember";
    return HttpRequest.request(url);
  }

  /// 更新用户信息
  static Future<bool> updateUserInfo(Map<String, String> para) async {
    // 1.发送网络请求
    final url = "/cweb/member";
    return HttpRequest.request(url, method: "put", params: para);
  }

  // 发送验证码
  static Future<dynamic> sendCode({@required String phone, num flag = 3}) {
    const url = "/bweb/member/getVerifyCode";
    return HttpRequest.request(url,
        method: "post", queryParameters: {"phone": phone, "flag": flag});
  }

  // 更换手机号
  static Future<dynamic> changeUserPhone(String phone, String code) {
    const url = "/bweb/member/update/mobile";
    return HttpRequest.request(url,
        method: "post", queryParameters: {"mobile": phone, "code": code});
  }

  // 获取地址列表
  static Future<List<AddressListModel>> obtainAddressList() async {
    const url = "/cweb/memberaddress/getList";
    List<AddressListModel> addressList = [];
    final result = await HttpRequest.request(url);
    List models = result;
    models.forEach((element) {
      addressList.add(AddressListModel.fromJson(element));
    });
    return addressList;
  }

  static Future<bool> setDefaultAddress(int addressId) async {
    const url = "/cweb/memberaddress/default/";
    bool resetSuccess = false;
    final result =
        await HttpRequest.request(url + addressId.toString(), method: "post");
    resetSuccess = result;
    print(addressId.toString() + "设置默认地址状态:" + resetSuccess.toString());
    return resetSuccess;
  }

  static Future<bool> deleteAddress(int addressId) async {
    const url = "/cweb/memberaddress/delete/";
    bool resetSuccess = false;
    final result =
        await HttpRequest.request(url + addressId.toString(), method: "post");
    resetSuccess = result;
    print(addressId.toString() + "删除地址状态:" + resetSuccess.toString());
    return resetSuccess;
  }

  // 获取实名列表
  static Future<dynamic> memberAuthList() async {
    const url = "/cweb/memberAuthentication/getList";
    final result = await HttpRequest.request(url);
    List model = result["data"];

    var list = [];
    if (model.length > 0) {
      for (var item in model) {
        RealNameModel m = RealNameModel.fromJson(Map.of(item));
        list.add(m);
      }
    }

    return list;
  }

  // 添加实名认证
  static Future<dynamic> addmemberAdd(
      String name, String idNo, int isDefault) async {
    const url = "/cweb/memberAuthentication/add";
    final result = await HttpRequest.request(url,
        method: "post",
        params: {"name": name, "idNo": idNo, "isDefault": isDefault});
    print("object2222221" + result.toString());
    return result;
  }

// 删除实名信息
  static Future<dynamic> addmemberDelete(int id) async {
    String url = "/cweb/memberAuthentication/delete/" + id.toString();
    final result = await HttpRequest.request(
      url,
      method: "delete",
    );
    return result;
  }

// 设置默认实名信息
  static Future<dynamic> addmemberDefault(int id) async {
    String url = "/cweb/memberAuthentication/setDefault/" + id.toString();
    final result = await HttpRequest.request(
      url,
      method: "put",
    );
    return result;
  }

  // https://testing-myouxuan.hzxituan.com/cweb/memberAuthentication/setDefault/1006

  /// 地址信息（新增/修改）
  static Future<bool> addressInfoRequest(
      Map<String, String> para, bool isAdd) async {
    final url =
        isAdd ? "/cweb/memberaddress/v1/add" : "/cweb/memberaddress/update";
    return HttpRequest.request(url,
        method: "post", hideToast: true, params: para);
  }

  /// 获取省市区数据
  static Future<List> getCityDataList(int type) async {
    final provinceUrl =
        "https://assets.hzxituan.com/data/v1.0.0/address/province.json";
    final cityUrl = "https://assets.hzxituan.com/data/v1.0.0/address/city.json";
    final areaUrl = "https://assets.hzxituan.com/data/v1.0.0/address/area.json";
    String realUrl = "";
    switch (type) {
      case 0:
        realUrl = provinceUrl;
        break;

      case 1:
        realUrl = cityUrl;
        break;

      case 2:
        realUrl = areaUrl;
        break;
    }
    return await HttpRequest.requestOnly(realUrl);
  }

  static Map cityDataSuccess(List resluts) {
    List provinceResult = resluts[0];
    List cityResult = resluts[1];
    List areaResult = resluts[2];

    /// 名称
    Map<String, List> areaM = {};
    Map<String, List> cityM = {};
    List<Map<String, dynamic>> provinceM = [];

    /// id
    Map<String, List> areaValueM = {};
    Map<String, List> cityValueM = {};
    List<Map<String, dynamic>> provinceValueM = [];

    for (int i = 0; i < areaResult.length; i++) {
      //区
      Map<String, dynamic> tm = areaResult[i];

      String key = tm["parent"];
      String name = tm["name"];
      String value = tm["value"];
      if (areaM[key] == null) {
        areaM[key] = [];
      }
      List ar = areaM[key];
      ar.add(name);

      if (areaValueM[key] == null) {
        areaValueM[key] = [];
      }
      List ar1 = areaValueM[key];
      ar1.add(value);
    }

    for (int i = 0; i < cityResult.length; i++) {
      //市
      Map<String, dynamic> tm = cityResult[i];
      String key = tm["parent"];
      String name = tm["name"];
      String value = tm["value"];
      if (cityM[key] == null) {
        cityM[key] = [];
      }
      List ar = cityM[key];
      ar.add({name: areaM[tm["value"]]});

      if (cityValueM[key] == null) {
        cityValueM[key] = [];
      }
      List ar1 = cityValueM[key];
      ar1.add({value: areaValueM[tm["value"]]});
    }

    for (int i = 0; i < provinceResult.length; i++) {
      //省
      var tm = provinceResult[i];
      provinceM.add({tm["name"]: cityM[tm["value"]]});

      provinceValueM.add({tm["value"]: cityValueM[tm["value"]]});
    }

    Map dataMap = {"cityName": provinceM, "cityValue": provinceValueM};

    return dataMap;
  }

  /// 获取省市区列表
  static Future<Map> getCityList() {
    return Future.wait(
            [getCityDataList(0), getCityDataList(1), getCityDataList(2)])
        .then((resluts) async {
      return await compute(cityDataSuccess, resluts);
    });
  }

  /// 获取用户绑定支付宝账号信息
  static Future<AlipayAccountModel> getAlipayAccountReq() async {
    final url = "/cweb/wx/withdrawals/selectAccountNumber";
    final result = await HttpRequest.request(url);
    AlipayAccountModel model = AlipayAccountModel.fromJson(result);
    return model;
  }

  /// 保存用户支付宝账号信息
  static Future<bool> saveAlipayAccountReq(Map<String, String> params) async {
    final url = "/cweb/member/alipayAccount";
    final result =
        await HttpRequest.request(url, method: "put", params: params);
    bool isSuccess = result;
    return isSuccess;
  }

  /// 获取用户微信信息
  static Future<WechatInfoModel> getWechatInfoReq() async {
    final url = "/ncweb/user/info/base/v1";
    final result = await HttpRequest.request(url);
    WechatInfoModel model = WechatInfoModel.fromJson(result);
    return model;
  }

  /// 获取用户微信信息
  static Future<bool> saveWechatInfoReq(Map<String, String> params) async {
    final url = "/ncweb/user/modify/wx/v1";
    return HttpRequest.request(url, method: "post", params: params);
  }
}
