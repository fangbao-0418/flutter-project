import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xtflutter/config/app_config/method_config.dart';
import 'package:xtflutter/pages/setting/user_info/edit_name.dart';
import 'package:xtflutter/pages/setting/user_info/edit_phone.dart';
import 'package:xtflutter/state/userinfo_vm.dart';
import 'package:xtflutter/pages/normal/app_nav_bar.dart';
import 'package:xtflutter/config/app_config/color_config.dart';
import 'package:xtflutter/config/app_config/method_channel.dart';
import 'package:xtflutter/router/router.dart';
import 'package:xtflutter/config/extension/string_extension.dart';
import 'package:xtflutter/model/userinfo_model.dart';
import 'package:xtflutter/net_work/userinfo_request.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class UserInfoPage extends StatefulWidget {
  static String routerName = "userInfo";

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
      final rsl =
          await XTUserInfoRequest.updateUserInfo({"headImage": result.safeStr});
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
      final result = Map<String, dynamic>.from(
          await XTMTDChannel.invokeMethod('updateRealName'));
      vm.updateRealInfo(result["card"], result["name"]);
    } catch (e) {
      print(e);
    }
  }

  final userTextStyle = TextStyle(color: main66GrayColor, fontSize: 14);
  final userRedTextStyle = TextStyle(color: mainRedColor, fontSize: 14);
  final userEdage = EdgeInsets.fromLTRB(10, 0, 10, 0);

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
    XTRouter.closePage(context: context, result: {"1": "111"});
  }

  Future getUserInfoData() {
    print('getUserInfoData');
    return XTUserInfoRequest.getUserInfoData().then((value) {
      final usermodel = Provider.of<UserInfoVM>(context);
      UserInfoModel mode = UserInfoModel.fromJson(Map.from(value.data));
      usermodel.updateUser(mode);
      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final usermodel = Provider.of<UserInfoVM>(context);

    return Scaffold(
        backgroundColor: mainF5GrayColor,
        appBar: xtBackBar(title: "个人信息", back: () => _xtback(context)),
        body: FutureBuilder(
            future: getUserInfoData(),
            builder: (context, result) {
              if (!result.hasData) {
                return Card(
                  shape: xtRoundCorners(10.0),
                  margin: EdgeInsets.all(10),
                  child: userInfoView(usermodel),
                  shadowColor: mainF5GrayColor,
                );
              }
              if (result.error != null) {
                return Center(
                  child: Text("网络错误，请重试"),
                );
              }
              return Card(
                shape: xtRoundCorners(10.0),
                margin: EdgeInsets.all(10),
                child: userInfoView(usermodel),
                shadowColor: mainF5GrayColor,
              );
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
              child:
                  xtRoundAvatarImage(60, 30, userInfo.user.headImage.safeStr),
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
                XTRouter.pushToPage(
                    routerName: EditNamePage.routerName,
                    params: {
                      'nickName': userInfo.user.nickName,
                    },
                    context: context);
              },
              name: userInfo.user.nickName,
              style: userTextStyle,
            );

            break;
          case 2:
            return userInfoItem(
              context,
              userInfo,
              "手机号",
              tapFunc: () {
                XTRouter.pushToPage(
                    routerName: EditPhonePage.routerName,
                    params: {
                      'nickName': userInfo.user.nickName,
                    },
                    context: context);
              },
              style: userTextStyle,
              name: userInfo.user.phone,
              hasArrow: true,
            );
            break;
          case 3:
            return userInfoItem(
              context,
              userInfo,
              "真实姓名",
              tapFunc: () {
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
      double height = 45,
      Widget child}) {
    return GestureDetector(
        onTap: tapFunc,
        child: Column(children: <Widget>[
          Container(
              height: height,
              padding: userEdage,
              child: basicContent(context, title,
                  hasChild ? child : xtTextWithStyle(name, style), hasArrow)),
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
            child: xtText(name, 16, mainBlackColor),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(color: Colors.white, height: 45),
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
