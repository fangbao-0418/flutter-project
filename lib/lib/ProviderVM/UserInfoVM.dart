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
  }

  void updateNiceName(String info) {
    _user.nickName = info;
  }

  void updatephone(String info) {
    _user.phone = info;
  }

  void updateCardnumber(String info) {
    _user.idCard = info;
  }

  void updateHeader(String info) {
    _user.headImage = info;
  }
  ///获取当前用户
  UserInfoModel get user {
    return _user;
  }
}
