import 'package:flutter/material.dart';
import 'package:xtflutter/ProviderVM/UserInfoVM.dart';
import 'package:xtflutter/UIPages/NormalUI/XTAppBackBar.dart';
import 'package:xtflutter/XTConfig/AppConfig/AppConfig.dart';
import 'package:xtflutter/XTConfig/AppConfig/XTColorConfig.dart';
import 'package:xtflutter/XTConfig/AppConfig/XTMethodChannelConfig.dart';
import 'package:xtflutter/XTConfig/AppConfig/XTMethodConfig.dart';
import 'package:xtflutter/XTConfig/AppConfig/XTRouter.dart';
import 'package:xtflutter/Utils/Global.dart';
import 'package:xtflutter/XTModel/UserInfoModel.dart';
import 'package:provider/provider.dart';

import '../Utils/Toast.dart';
import '../XTModel/UserInfoModel.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isReal = AppConfig.getInstance().userVM.isRealName;

  final leftStyle = TextStyle(color: mainBlackColor, fontSize: 16);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainF5GrayColor,
      appBar: xtBackBar(
          back: () {
            XTRouter.closePage(context: context);
          },
          title: "设置"),
      body: Column(
        children: <Widget>[
          Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              margin: EdgeInsets.all(10),
              shadowColor: whiteColor,
              child: listTab(context)),
          Expanded(
            flex: 3,
            child: Container(color: mainF5GrayColor, height: 60),
          ),
          Positioned(
              child: Container(
            width: double.infinity,
            color: mainF5GrayColor,
            alignment: Alignment.center,
            child: RaisedButton(
              elevation: 0,
              padding: EdgeInsets.fromLTRB(45, 10, 45, 10),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: BorderSide(
                      width: 0.5,
                      color: main99GrayColor,
                      style: BorderStyle.solid)),
              onPressed: () {
                loginOut(context);
              },
              child: Text("退出登录",
                  style: TextStyle(color: main99GrayColor, fontSize: 14)),
            ),
          )),
          Expanded(
            flex: 1,
            child: Container(color: mainF5GrayColor, height: 60),
          ),
        ],
      ),
    );
  }

  void loginOut(BuildContext context) {
    AppConfig.getInstance().userVM.updateUser(UserInfoModel());
    XTMTDChannel.invokeMethod("loginOut");
    XTRouter.closePage(context: context);
  }

  List<Widget> childItem(BuildContext context) {
    List<Widget> tp = [
      basicContent("个人信息", tapFunc: () {
        // Global.context = context;
        XTRouter.pushToPage(context: context, routerName: "fl-user-info")
            .then((value) {
          if (isReal != AppConfig.getInstance().userVM.isRealName) {
            setState(() {
              isReal = AppConfig.getInstance().userVM.isRealName;
            });
          }
        });
      }),
      basicContent("全球淘付款人实名信息", tapFunc: () {
        XTRouter.pushToPage(routerName: "officalname", context: context);
        // XTRouter.pushToPage(context: context, routerName: "page1");
      }),
      basicContent("收货地址", tapFunc: () {
        XTRouter.pushToPage(
          routerName: "addressList",
          context: context,
        );
      })
    ];

    if (isReal) {
      tp.add(basicContent("支付宝账号", tapFunc: () {
        XTRouter.pushToPage(routerName: "alipayAccount", context: context);
      }));
    }
    tp.add(basicContent("消息通知", tapFunc: () {
      XTRouter.pushToPage(
          context: context, routerName: makeRouter(true, null, "gotoNotice"));
    }));
    if (isReal) {
      tp.add(basicContent("微信信息", tapFunc: () {
        XTRouter.pushToPage(routerName: "wechatInfo", context: context);
      }));
    }

    tp.add(basicContent("关于喜团", haveLine: false, tapFunc: () {
      // XTRouter.pushToPage(
      //   routerName: makeRouter(true, null, "aboutXiTuan"),
      //   context: context,
      // );
      XTRouter.pushToPage(
        routerName: makeRouter(true, null, "aboutXituan"),
        context: context,
      );
    }));

    return tp;
  }

  Widget listTab(context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: childItem(context),
    );
  }

  Widget line(bool hascolor) {
    return Container(
      height: 1.0,
      margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
      color: hascolor ? mainF5GrayColor : Colors.white,
    );
  }

  Widget basicContent(
    String name, {
    GestureTapCallback tapFunc,
    bool haveLine = true,
    String childStr = "",
  }) {
    return GestureDetector(
        onTap: tapFunc,
        child: Column(
          children: <Widget>[
            Row(
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
                    child: (name != "个人信息")
                        ? Text(name, style: leftStyle)
                        : ((isReal)
                            ? Text(name, style: leftStyle)
                            : RichText(
                                text: TextSpan(
                                text: name,
                                style: leftStyle,
                                children: [
                                  TextSpan(
                                    text: "（未实名认证）",
                                    style: TextStyle(
                                      color: mainRedColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ))),
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
                      Text(childStr),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Icon(Icons.keyboard_arrow_right,
                            color: main99GrayColor, size: 22.0),
                      )
                    ],
                  ),
                ),
              ],
            ),
            line(haveLine),
          ],
        ));
  }
}
