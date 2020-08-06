import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:xtflutter/XTConfig/AppConfig/XTColorConfig.dart';
import 'package:xtflutter/XTNetWork/UserInfoRequest.dart';

class EditNamePage extends StatelessWidget {
  void _updateName() async {
    try {
      final result =
          await XTUserInfoRequest.updateUserInfo({"nickName": "hello"});
      print(result);
      //  final resu =  XTUserInfoRequest.getUserInfoData();
      // final editSucc = await XTUserInfoRequest.upda
    } catch (err) {
            print(err);

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            onPressed: () => _updateName(),
          ),
        ],
      ),
    );
  }
}
