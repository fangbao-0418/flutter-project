import 'package:flutter/material.dart';
import 'package:xtflutter/model/userinfo_model.dart';
import '../config/extension/string_extension.dart';

class UserInfoVM extends ChangeNotifier {
  UserInfoModel _user = UserInfoModel();

  ///更新用户信息
  void updateUser(UserInfoModel info) {
    if (info.idCard != null && info.idCard.length == 18) {
      var str = info.idCard;
      info.idCard = str.replaceRange(6, 14, "******");
    }
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
    idcard = idcard.replaceRange(6, 14, "******");
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
    return _user.idCard != "null" &&
        _user.userName != "null" &&
        !_user.idCard.xtEmpty &&
        !_user.userName.xtEmpty;
  }

  String get resRealName {
    return isRealName
        ? (_user.userName == null ? "未认证" : _user.userName)
        : "未认证";
  }

  String get resIdentity {
    return isRealName ? _user.idCard : "未认证";
  }
}
