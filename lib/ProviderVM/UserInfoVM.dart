import 'package:flutter/material.dart';
import 'package:xtflutter/XTModel/UserInfoModel.dart';

class UserInfoVM extends ChangeNotifier {
  UserInfoModel _user;

  ///更新用户信息
  void updateUser(UserInfoModel info) {
    _user = info;
    notifyListeners();
  }

  void updateUserName(String info) {
    _user.userName = info;
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

  void updateCardnumber(String info) {
    _user.idCard = info;
    notifyListeners();
  }

  void updateHeader(String info) {
    _user.headImage = info;
    notifyListeners();
  }

  ///获取当前用户
  UserInfoModel get user {
    return _user;
  }

  bool get isRealName {
    return _user.idCard != "" ;
  }

  String get resRealName {
    return isRealName ?  _user.userName :"未认证" ;
  }

  String get resIdentity {
    return isRealName ?  _user.idCard :"未认证" ;
  }
}
