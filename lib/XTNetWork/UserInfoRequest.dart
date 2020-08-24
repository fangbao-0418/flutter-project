import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:xtflutter/XTConfig/AppConfig/AppConfig.dart';
import '../XTModel/UserInfoModel.dart';
import 'httpRequest.dart';

//用户资料请求
class XTUserInfoRequest {
  ///获取当前用户信息
  static Future<dynamic> getUserInfoData() async {
    // 1.发送网络请求
    final url = "/cweb/member/getMember";
    final result = await HttpRequest.request(url);

    final resl = result["data"];
    print("object -------------==== " + resl.toString());
    return resl;
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
    final result = HttpRequest.request(url,
        method: "post", queryParameters: {"mobile": phone, "code": code});
    return result;
  }

  // 获取地址列表
  static Future<List<AddressListModel>> obtainAddressList() async {
    const url = "/cweb/memberaddress/getList";
    List<AddressListModel> addressList = [];
    final result = await HttpRequest.request(url);
    List models = result['data'];
    models.forEach((element) {
      addressList.add(AddressListModel.fromJson(element));
    });
    print("addressListData:${models.toString()}");
    return addressList;
  }

  static Future<bool> setDefaultAddress(int addressId) async {
    const url = "/cweb/memberaddress/default/";
    bool resetSuccess = false;
    final result =
        await HttpRequest.request(url + addressId.toString(), method: "post");
    resetSuccess = result['data'];
    print(addressId.toString() + "设置默认地址状态:" + resetSuccess.toString());
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
  static Future<Map<String, dynamic>> addressInfoRequest(
      Map<String, String> para, bool isAdd) async {
    final url =
        isAdd ? "/cweb/memberaddress/v1/add" : "/cweb/memberaddress/update";
    final result = await HttpRequest.request(url, method: "post", params: para);
    return result;
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

    List<Map<String, dynamic>> allList = [];
    List<Map<String, dynamic>> allItemList = [];
    for (int i = 0; i < provinceResult.length; i++) {
      String provinceName = provinceResult[i]["name"];
      String provinceValue = provinceResult[i]["value"].toString();
      Map<String, List> provinceMap = {};
      List<Map<String, List>> cityNameList = [];

      Map<String, List> provinceItemMap = {};
      List<Map<String, List>> cityItemList = [];

      for (int j = 0; j < cityResult.length; j++) {
        String cityName = cityResult[j]["name"];
        String cityValue = cityResult[j]["value"];
        String cityParent = cityResult[j]["parent"].toString();
        Map<String, List> cityMap = {};
        List<String> areaNameList = [];

        Map<String, List> cityItemMap = {};
        List areaItemList = [];

        for (int k = 0; k < areaResult.length; k++) {
          String areaName = areaResult[k]["name"];
          String areaParent = areaResult[k]["parent"];

          String areaValue = areaResult[k]["value"];
          if (areaParent == cityValue) {
            areaNameList.add(areaName);

            areaItemList.add(areaValue);
          }
        }
        cityMap[cityName] = areaNameList;

        cityItemMap[cityValue] = areaItemList;
        if (cityParent == provinceValue) {
          cityNameList.add(cityMap);

          cityItemList.add(cityItemMap);
        }
      }
      provinceMap[provinceName] = cityNameList;
      allList.add(provinceMap);

      provinceItemMap[provinceValue] = cityItemList;
      allItemList.add(provinceItemMap);
    }

    print("allItemListallItemList == ${allItemList.toString()}");

    Map dataMap = {"cityName": allList, "cityValue": allItemList};

    return dataMap;
  }

  /// 获取省市区列表
  static Future<Map> getCityList() {
    return Future.wait(
            [getCityDataList(0), getCityDataList(1), getCityDataList(2)])
        .then((resluts) async {
      return await compute(cityDataSuccess, resluts);
    }).catchError((err) {
      print(err);
    });
  }

  /// 获取用户绑定支付宝账号信息
  static Future<AlipayAccountModel> getAlipayAccountReq() async {
    final url = "/cweb/wx/withdrawals/selectAccountNumber";
    final result = await HttpRequest.request(url);
    AlipayAccountModel model = AlipayAccountModel.fromJson(result["data"]);
    return model;
  }

  /// 保存用户支付宝账号信息
  static Future<bool> saveAlipayAccountReq(Map<String, String> params) async {
    final url = "/cweb/member/alipayAccount";
    final result =
        await HttpRequest.request(url, method: "put", params: params);
    bool isSuccess = result["data"];
    return isSuccess;
  }

  /// 获取用户微信信息
  static Future<WechatInfoModel> getWechatInfoReq() async {
    final url = "/ncweb/user/info/base/v1";
    final result = await HttpRequest.request(url);
    WechatInfoModel model = WechatInfoModel.fromJson(result["data"]);
    return model;
  }

  /// 获取用户微信信息
  static Future<bool> saveWechatInfoReq(Map<String, String> params) async {
    final url = "/ncweb/user/modify/wx/v1";
    final result =
        await HttpRequest.request(url, method: "post", params: params);
    bool isSuccess = result["data"];
    return isSuccess;
  }
}
