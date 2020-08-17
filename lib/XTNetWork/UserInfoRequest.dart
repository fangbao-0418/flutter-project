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

  /// 地址信息（新增/修改）
  static Future<Map<String, dynamic>> addressInfoRequest(Map<String, String> para, bool isAdd) async {
    final url = isAdd ? "/cweb/memberaddress/v1/add" : "/cweb/memberaddress/update";
    final result = await HttpRequest.request(url, method: "post", params: para);
    return result;
  }

  /// 获取省市区数据
  static Future<List> getCityDataList(int type) async {
    final provinceUrl = "https://assets.hzxituan.com/data/v1.0.0/address/province.json";
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

  static List cityDataSuccess(List provinceResult, List cityResult, List areaResult) {
    List<Map<String, dynamic>> allList = [];
    List<Map<String, dynamic>> allItemList = [];
    for (int i = 0; i < provinceResult.length; i ++) {
      String provinceName = provinceResult[i]["name"];
      String provinceValue = provinceResult[i]["value"].toString();
      Map<String, List> provinceMap = {};
      List<Map<String, List>> cityNameList = [];

      Map<String, List> provinceItemMap = {};
      List<Map<String, List>> cityItemList = [];

      for (int j = 0; j < cityResult.length; j ++) {
        String cityName = cityResult[j]["name"];
        String cityValue = cityResult[j]["value"];
        String cityParent = cityResult[j]["parent"].toString();
        Map<String, List> cityMap = {};
        List<String> areaNameList = [];

        Map<String, List> cityItemMap = {};
        List areaItemList = [];

        for (int k = 0; k < areaResult.length; k ++) {
          String areaName = areaResult[k]["name"];
          String areaParent = areaResult[k]["parent"];
          if (areaParent == cityValue) {
            areaNameList.add(areaName);
            
            areaItemList.add(areaResult[k]);
          }
        }
        cityMap[cityName] = areaNameList;

        cityItemMap[cityName] = areaItemList;
        if (cityParent == provinceValue) {
          cityNameList.add(cityMap);

          cityItemList.add(cityItemMap);
        }
      }
      provinceMap[provinceName] = cityNameList;
      allList.add(provinceMap);

      provinceItemMap[provinceName] = cityItemList;
      allItemList.add(provinceItemMap);
    }
    return allList;
  }

  /// 获取省市区列表
  static Future<List> getCityList() async {
    return await Future.wait([
      getCityDataList(0),
      getCityDataList(1),
      getCityDataList(2)
    ]).then((resluts) {
      return cityDataSuccess(resluts[0], resluts[1], resluts[2]);
    }).catchError((err) {
      print(err);
    });
  }
}
