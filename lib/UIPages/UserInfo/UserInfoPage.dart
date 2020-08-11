import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xtflutter/ProviderVM/UserInfoVM.dart';
import 'package:xtflutter/UIPages/NormalUI/XTAppBackBar.dart';
import 'package:xtflutter/XTConfig/AppConfig/XTMethodChannelConfig.dart';
import 'package:xtflutter/XTConfig/Extension/StringExtension.dart';
import 'package:xtflutter/XTNetWork/UserInfoRequest.dart';

import '../../XTConfig/AppConfig/XTColorConfig.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class UserInfoPage extends StatefulWidget {
  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

//更新用户头像
class _UserInfoPageState extends State<UserInfoPage>
    with SingleTickerProviderStateMixin {
  ///更新头像
  Future<dynamic> _updateAvAtar(UserInfoVM vm) async {
    try {
      final String result = await XTMTDChannel.invokeMethod('updateAvAtar');
      final rsl = await XTUserInfoRequest.updateUserInfo({"headImage": result});
      if (rsl == true) {
        vm.updateAvAtar(result.imgUrl);
      }
    } catch (e) {
      print(e.message);
    }
  }

  ///更新身份证
  Future<dynamic> _updateRealName(UserInfoVM vm) async {
    try {
      final Map<String, dynamic> result = new Map<String, dynamic>.from(
          await XTMTDChannel.invokeMethod('updateRealName'));
      vm.updateRealInfo(result["card"], result["name"]);
    } catch (e) {
      print(e);
    }
  }

  final userTextStyle = TextStyle(color: main66GrayColor, fontSize: 14);
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

//返回
  void _xtback(BuildContext context) {
    final BoostContainerSettings settings = BoostContainer.of(context).settings;
    FlutterBoost.singleton.close(settings.uniqueId,
        result: <String, dynamic>{'result': 'data from second'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: mainF5GrayColor,
        appBar: xtBackBar(title: "个人信息", back: () => _xtback(context)),
        body: Consumer<UserInfoVM>(builder: (ctx, userInfo, child) {
          print("Consumer Consumer -----------------------------------");
          return FutureBuilder(
              future: XTUserInfoRequest.getUserInfoData(),
              builder: (ctx, snapshot) {
                print("FutureBuilder --------start");
                if (!snapshot.hasData) {
                  return loadingpage();
                } else {
                  userInfo.updateUser(snapshot.data);
                }
                if (snapshot.error != null) {
                  return Center(
                    child: Text("网络错误，请重试"),
                  );
                }
                return Card(
                  margin: EdgeInsets.all(10),
                  child: userInfoView(userInfo),
                  shadowColor: mainF5GrayColor,
                );
              });
        }));
  }

  Widget loadingpage() {
    return Stack(
      children: <Widget>[
        SpinKitFadingCircle(
          itemBuilder: (BuildContext context, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                  color: main99GrayColor,
                  borderRadius: BorderRadius.circular(20)),
            );
          },
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0.0, 80.0, 0.0, 0.0),
          child: Center(
            child: Text(
              '加载中...',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: main99GrayColor),
            ),
          ),
        ),
      ],
    );
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
                      image: NetworkImage(userInfo.user.headImage.safeStr),
                    )),
              ),
              hasChild: true,
              height: 80,
              tapFunc: () => _updateAvAtar(userInfo),
            );
            break;
          case 1:
            return userInfoItem(
              context,
              userInfo,
              "昵称",
              tapFunc: () {
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
                print("object 88888");
                if (!userInfo.isRealName) {
                  _updateRealName(userInfo);
                }
              },
              style: userInfo.isRealName ? userTextStyle : userRedTextStyle,
              name: userInfo.resRealName,
              hasArrow: false,
            );

            break;
          case 4:
            return userInfoItem(context, userInfo, "身份证号", tapFunc: () {
              if (!userInfo.isRealName) {
                _updateRealName(userInfo);
              }
            },
                style: userInfo.isRealName ? userTextStyle : userRedTextStyle,
                name: userInfo.resIdentity,
                hasArrow: false,
                hasLine: false);
            break;
          default:
            return Container();
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
      bool hasLine = true,
      double height = 50,
      Widget child}) {
    return GestureDetector(
        onTap: tapFunc,
        child: Column(children: <Widget>[
          Container(
              height: height,
              padding: userEdage,
              child: basicContent(context, title,
                  hasChild ? child : Text(name, style: style), hasArrow)),
          Offstage(
              offstage: !hasLine,
              child: Container(
                height: 1.0,
                margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                color: mainF5GrayColor,
              )),
        ]));
  }

// Image.network(imageHeader),
  Widget basicContent(
      BuildContext context, String name, Widget childWidget, bool haveArrow) {
    return Row(
      verticalDirection: VerticalDirection.down,
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
              child: Text(name,
                  style: TextStyle(color: mainBlackColor, fontSize: 18))),
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
              Container(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Offstage(
                  offstage: !haveArrow,
                  child: Icon(Icons.keyboard_arrow_right,
                      color: main99GrayColor, size: 22.0),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
