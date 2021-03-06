import 'package:flutter/material.dart';
import 'package:xtflutter/XTModel/UserInfoModel.dart';
import '../XTConfig/Extension/StringExtension.dart';

class UserInfoVM extends ChangeNotifier {
  UserInfoModel _user = UserInfoModel();

  ///更新用户信息
  void updateUser(UserInfoModel info) {
    _user = info;

    notifyListeners();
  }

  void updateNiceName(String info) {
    _user.nickName = info;
    notifyListeners();
  }

  void updatephone(String info) {
    _user.phone = info;
    notifyListeners();
  }

  void updateRealInfo(String idcard, String name) {
    _user.idCard = idcard;
    _user.userName = name;
    notifyListeners();
  }

  void updateAvAtar(String info) {
    _user.headImage = info;
    notifyListeners();
  }

  ///获取当前用户
  UserInfoModel get user {
    if (_user.headImage == null) {
      _user.headImage = "";
    }
    return _user;
  }

  bool get isRealName {
    return _user.idCard.xtEmpty;
  }

  String get resRealName {
    return isRealName
        ? (_user.userName == null ? "未认证" : _user.userName)
        : "未认证";
  }

  String get resIdentity {
    return isRealName ? (_user.idCard == null ? "未认证" : _user.idCard) : "未认证";
  }
}
