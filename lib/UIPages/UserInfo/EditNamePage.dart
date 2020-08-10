import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:xtflutter/ProviderVM/UserInfoVM.dart';
import 'package:xtflutter/UIPages/NormalUI/XTAppBackBar.dart';
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

  void _xtback(BuildContext context) {
    final BoostContainerSettings settings = BoostContainer.of(context).settings;
    FlutterBoost.singleton.close(settings.uniqueId,
        result: <String, dynamic>{'result': 'data from second'});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserInfoVM>(builder: (ctx, userInfo, child) {
      return Scaffold(
        body: Container(
          padding: EdgeInsets.all(10),
          child: TextField(
            controller: TextEditingController(
              text: userInfo.user.nickName,
            ),
            textAlign: TextAlign.left,
            decoration: InputDecoration(
              labelStyle: TextStyle(color: main66GrayColor, fontSize: 14),
            ),
            onChanged: (String change) {
              _name = change;
            },
            onEditingComplete: () {
              print("结束编辑");
            },
          ),
        ),
        appBar: xtbackAndRightBar(
            back: () => _xtback(context),
            title: "修改信息",
            rightTitle: "完成",
            rightFun: () => _updateName(userInfo)),
      );
    });
  }
}
