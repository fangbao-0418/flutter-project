import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xtflutter/ProviderVM/UserInfoVM.dart';
import 'package:xtflutter/XTConfig/AppConfig/XTMethodChannelConfig.dart';
import 'package:xtflutter/XTConfig/Extension/StringExtension.dart';
import 'package:xtflutter/XTNetWork/UserInfoRequest.dart';

import '../../XTConfig/AppConfig/XTColorConfig.dart';
import 'package:flutter_boost/flutter_boost.dart';
import '../../XTConfig/Extension/DoubleExtension.dart';
import '../../XTConfig/Extension/IntExtension.dart';

class UserInfoPage extends StatefulWidget {
  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage>
    with SingleTickerProviderStateMixin {
  Future<dynamic> _updateHeader(UserInfoVM vm) async {
    try {
      final String result = await XTMTDChannel.invokeMethod('updateHeader');
      final rsl = await XTUserInfoRequest.updateUserInfo({"headImage": result});
      if (rsl == true) {
        vm.updateHeader(result.imgUrl);
      }
    } catch (e) {
      print(e.message);
    }
  }

  Future<dynamic> _updateRealName() async {
    try {
      final bool result = await XTMTDChannel.invokeMethod('updateRealName');
    } catch (e) {
      print(e.message);
    }
  }

  final userTextStyle = TextStyle(color: mainGrayColor, fontSize: 14);
  final userRedTextStyle = TextStyle(color: mainRedColor, fontSize: 14);
  final userEdage = EdgeInsets.fromLTRB(10, 5, 10, 5);
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
    return Consumer<UserInfoVM>(builder: (ctx, userInfo, child) {
      return FutureBuilder(
          future: XTUserInfoRequest.getUserInfoData(),
          builder: (ctx, snapshot) {
            print("FutureBuilder --------start");
            if (!snapshot.hasData) {
              return Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.yellow,
              ));
            }
            if (snapshot.error != null) {
              return Center(
                child: Text("请求失败"),
              );
            }
            print(snapshot.data);
            userInfo.updateUser(snapshot.data);
            return Scaffold(
                appBar: AppBar(
                    leading: IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          FlutterBoost.singleton.close("info");
                        }),
                    title: Text("个人信息")),
                body: Card(
                  margin: EdgeInsets.all(10),
                  child: userInfoView(userInfo),
                ));
          });
    });
  }

  Widget userInfoView(UserInfoVM userInfo) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (ctx, index) {
        switch (index) {
          case 0:
            return userInfoItem(
              context,
              userInfo,
              "头像",
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    image: DecorationImage(
                      image: NetworkImage(userInfo.user.headImage),
                    )),
              ),
              hasChild: true,
              height: 80,
              tapFunc: () => _updateHeader(userInfo),
            );
            break;
          case 1:
            return userInfoItem(context, userInfo, "昵称", tapFunc: () {
              FlutterBoost.singleton
                  .open('editPage', urlParams: <String, dynamic>{
                'nickName': userInfo.user.nickName,
              }).then((Map<dynamic, dynamic> value) {
                print(
                    'editName  finished. did recieve second route result $value');
              });
            },
                name: userInfo.user.nickName,
                style: userTextStyle,
                );

            break;
          case 2:
            return GestureDetector(
                onTap: () {},
                child: Container(
                    height: 40,
                    padding: userEdage,
                    child: basicContent(
                        context,
                        "手机号",
                        Text(userInfo.user.phone, style: userTextStyle),
                        true)));
            break;
          case 3:
            return userInfoItem(
              context,
              userInfo,
              "真实姓名",
              tapFunc: () {
                if (userInfo.isRealName) {
                  _updateRealName();
                }
              },
              style: userInfo.isRealName ? userTextStyle : userRedTextStyle,
              name: userInfo.resRealName,
              hasArrow: false,
            );

            break;
          case 4:
            return userInfoItem(
              context,
              userInfo,
              "身份证号",
              tapFunc: () {
                if (userInfo.isRealName) {
                  _updateRealName();
                }
              },
              style: userInfo.isRealName ? userTextStyle : userRedTextStyle,
              name: userInfo.resIdentity,
              hasArrow: false,
            );
            break;
          default:
        }
      },
    );
  }

  Widget userInfoItem(BuildContext context, UserInfoVM userInfo, String title,
      {String name,
      GestureTapCallback tapFunc,
      TextStyle style,
      bool hasChild = false,
      bool hasArrow = true,
      double height = 40,
      Widget child}) {
    return GestureDetector(
        onTap: tapFunc,
        child: Container(
            height: height,
            padding: userEdage,
            child: basicContent(context, title,
                hasChild ? child : Text(name, style: style), hasArrow)));
    ;
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
          child: Container(color: Colors.white, height: 60),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Row(
            children: <Widget>[
              childWidget,
              new Offstage(
                offstage: !haveArrow,
                child: new Icon(Icons.arrow_right,
                    color: mainGrayColor, size: 20.0),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
