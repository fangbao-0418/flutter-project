import 'package:flutter/material.dart';
import 'package:xtflutter/config/app_config/method_config.dart';
import 'package:xtflutter/pages/normal/app_nav_bar.dart';
import 'package:xtflutter/router/router.dart';
import 'package:xtflutter/utils/appconfig.dart';
import 'package:xtflutter/config/app_config/color_config.dart';

class AboutXituanPage extends StatefulWidget {
  static String routerName = "aboutXituan";

  @override
  _AboutXituanPageState createState() => _AboutXituanPageState();
}

class _AboutXituanPageState extends State<AboutXituanPage> {
  void _xtback(BuildContext context) {
    XTRouter.closePage(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: mainF5GrayColor,
        appBar: xtBackBar(title: "关于喜团", back: () => _xtback(context)),
        body: view());
  }

  Widget view() {
    // Map<String, dynamic> a = {"12": "23"};
    // var b = a["123"].c;
    var arr = ["123", "123"];

    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 40),
          width: 80.0,
          height: 80.0,
          decoration: xtRoundDecoration(10,
              image: DecorationImage(
                image: AssetImage("images/xituan_logo.png"),
                fit: BoxFit.cover,
              )),
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          child: xtText(
              "版本号：v" + AppConfig.getInstance().appVersion, 14, main99GrayColor,
              alignment: TextAlign.center),
        ),
        Card(
            margin: EdgeInsets.all(20),
            shape: xtShapeRound(10.0),
            child: Column(children: <Widget>[
              Container(
                  child: basicContent("服务条款" + arr[3], tapFunc: () {
                XTRouter.pushToPage(
                    routerName:
                        "https://myouxuan.hzxituan.com/h5/notify/user-agreement.html",
                    context: context,
                    isNativePage: true);
              })),
              line(true),
              Container(
                  child: basicContent("隐私条款", tapFunc: () {
                XTRouter.pushToPage(
                    routerName:
                        "https://myouxuan.hzxituan.com/h5/notify/user-privacy.html",
                    context: context,
                    isNativePage: true);
              }))
            ])),
        Expanded(
          flex: 3,
          child: Container(color: mainF5GrayColor, height: 60),
        ),
        Stack(children: [
          Positioned(
              child: Container(
            width: double.infinity,
            color: mainF5GrayColor,
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                xtText("浙B2-20190758", 14, main99GrayColor,
                    alignment: TextAlign.center, bgcolor: Colors.transparent),
                xtText('杭州喜团科技版权所有', 14, main99GrayColor,
                    alignment: TextAlign.center, bgcolor: Colors.transparent),
                xtText('Copyright@2019 XiTuan All Rights Reserved', 14,
                    main99GrayColor,
                    alignment: TextAlign.center, bgcolor: Colors.transparent),
              ],
            ),
          ))
        ]),
        Expanded(
          flex: 1,
          child: Container(color: mainF5GrayColor, height: 60),
        ),
      ],
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
                      color: Colors.white,
                      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: Text(name,
                          style:
                              TextStyle(color: mainBlackColor, fontSize: 16))),
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
                        color: Colors.white,
                        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: Icon(Icons.keyboard_arrow_right,
                            color: main99GrayColor, size: 22.0),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
