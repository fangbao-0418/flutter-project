import 'dart:async';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:xtflutter/ProviderVM/UserInfoVM.dart';
import 'package:xtflutter/XTConfig/AppConfig/XTColorConfig.dart';
import 'package:xtflutter/XTNetWork/UserInfoRequest.dart';

class EditNamePage extends StatelessWidget {
  String _name = "";

  void _updateName(UserInfoVM vm) async {
    try {
      final _ = await XTUserInfoRequest.updateUserInfo({"nickName": _name});
      FlutterBoost.singleton.close("editPage");
      vm.updateNiceName(_name);
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserInfoVM>(builder: (ctx, userInfo, child) {
      return Scaffold(
        body: TextField(
          controller: TextEditingController(
            text: userInfo.user.nickName,
          ),
          textAlign: TextAlign.left,
          decoration: InputDecoration(
            labelStyle: TextStyle(color: mainGrayColor, fontSize: 14),
          ),
          onChanged: (String change) {
            _name = change;
          },
          onEditingComplete: () {
            print("结束编辑");
          },
        ),
        appBar: AppBar(
          leading: IconButton(
            color: mainBlackColor,
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              FlutterBoost.singleton.close("editPage");
            },
          ),
          title: Text('导航'),
          actions: <Widget>[
            FlatButton(
              color: Colors.pink,
              textColor: Colors.white,
              child: Text('完成'),
              onPressed: () => _updateName(userInfo),
            ),
          ],
        ),
      );
    });
  }
}
