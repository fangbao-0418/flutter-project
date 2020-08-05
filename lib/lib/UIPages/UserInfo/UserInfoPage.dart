import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:xtflutter/ProviderVM/UserInfoVM.dart';
import 'package:xtflutter/XTConfig/AppConfig/XTMethodChannelConfig.dart';
import 'package:xtflutter/XTModel/UserInfoModel.dart';
import 'package:xtflutter/XTNetWork/UserInfoRequest.dart';

import '../../XTConfig/AppConfig/XTColorConfig.dart';
import 'package:flutter_boost/flutter_boost.dart';
import '../../XTConfig/AppConfig/XTMethodConfig.dart';
import '../../XTConfig/Extension/IntExtension.dart';

class UserInfoPage extends StatefulWidget {
  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage>
    with SingleTickerProviderStateMixin {
  UserInfoModel _model;

  Future<dynamic> _updateHeader() async {
    try {
      final String result = await XTMTDChannel.invokeMethod('updateHeader');
      // UserInfoVM.

    } catch (e) {
      print(e.message);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: XTUserInfoRequest.getUserInfoData(),
        builder: (ctx, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          if (snapshot.error != null)
            return Center(
              child: Text("请求失败"),
            );
          _model = snapshot.data;
          print(snapshot.data);
          return Scaffold(
              appBar: AppBar(title: Text("个人信息")),
              body: Card(
                margin: EdgeInsets.all(10),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (ctx, index) {
                    switch (index) {
                      case 0:
                        return GestureDetector(
                          onTap: () => _updateHeader(),
                          child: Container(
                              color: Colors.yellow,
                              height: 80,
                              padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                              child: basicContent(
                                context,
                                "头像",
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      image: DecorationImage(
                                        image: NetworkImage(_model.headImage),
                                      )),
                                ),
                                false,
                              )),
                        );
                        break;
                      case 1:
                        return GestureDetector(
                            onTap: () {
                              FlutterBoost.singleton
                                  .open('editPage')
                                  .then((Map<dynamic, dynamic> value) {
                                print(
                                    'editName  finished. did recieve second route result $value');
                              });
                            },
                            child: Container(
                                color: Colors.brown,
                                height: 40,
                                padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                                child: basicContent(
                                    context,
                                    "昵称",
                                    Text(_model.nickName,
                                        style: TextStyle(
                                            color: mainGrayColor,
                                            fontSize: 14)),
                                    false)));
                        break;
                      case 2:
                        return GestureDetector(
                            onTap: () {},
                            child: Container(
                                color: Colors.purple,
                                height: 40,
                                padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                                child: basicContent(
                                    context,
                                    "手机号",
                                    Text(_model.phone,
                                        style: TextStyle(
                                            color: mainGrayColor,
                                            fontSize: 14)),
                                    false)));
                        break;
                      case 3:
                        return GestureDetector(
                            onTap: () {},
                            child: Container(
                                color: Colors.green,
                                height: 40,
                                padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                                child: basicContent(
                                    context,
                                    "真实姓名",
                                    Text(
                                        _model.userName == null
                                            ? "未认证"
                                            : _model.userName,
                                        style: TextStyle(
                                            color: mainGrayColor,
                                            fontSize: 14)),
                                    true)));
                        break;
                      case 4:
                        print("idCard ----" + _model.idCard + "idCard ----");
                        return GestureDetector(
                            onTap: () {},
                            child: Container(
                                color: Colors.yellowAccent,
                                height: 40,
                                padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                                child: basicContent(
                                    context,
                                    "身份证号",
                                    Text(
                                        (_model.idCard == null ||
                                                _model.idCard == "")
                                            ? "未认证"
                                            : _model.idCard,
                                        style: TextStyle(
                                            color: mainGrayColor,
                                            fontSize: 14)),
                                    true)));
                        break;
                      default:
                    }
                  },
                ),
              ));
        });
  }

// Image.network(imageHeader),
  Widget basicContent(
      BuildContext context, String name, Widget childWidget, bool haveArrow) {
    return Row(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child:
              Text(name, style: TextStyle(color: mainBlackColor, fontSize: 18)),
        ),
        Expanded(
          flex: 1,
          child: Container(color: Colors.red, height: 60),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Row(
            children: <Widget>[
              childWidget,
              new Offstage(
                offstage: haveArrow,
                child: new Icon(Icons.arrow_right,
                    color: mainGrayColor, size: 20.0),
              ),
            ],
          ),
        ),
      ],
    );

    // onPressed: () {
    //   FlutterBoost.singleton
    //       .open(makeRouter(false, {"name": 123, "age": 10}, "6666"))
    //       .then((Map<dynamic, dynamic> value) {
    //     print(
    //         'call me when page is finished. did recieve native route result $value');
    //   });
    // },
  }
}
