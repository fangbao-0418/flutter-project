import 'package:flutter/material.dart';
import 'package:xtflutter/UIPages/NormalUI/XTAppBackBar.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:xtflutter/XTConfig/AppConfig/XTMethodConfig.dart';
import '../../XTConfig/AppConfig/XTColorConfig.dart';

class AboutXituanPage extends StatefulWidget {
  @override
  _AboutXituanPageState createState() => _AboutXituanPageState();
}

class _AboutXituanPageState extends State<AboutXituanPage> {
  void _xtback(BuildContext context) {
    final BoostContainerSettings settings = BoostContainer.of(context).settings;
    FlutterBoost.singleton.close(settings.uniqueId,
        result: <String, dynamic>{'result': 'data from second'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: mainF5GrayColor,
        appBar: xtBackBar(title: "关于喜团", back: () => _xtback(context)),
        body: FutureBuilder(
            builder: (BuildContext context, AsyncSnapshot snapShot) {
          return view();
        }));
  }

  Widget view() {
    return Center(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 40),
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/xituan_logo.png"),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              "版本号：V2.1.4",
              style: TextStyle(fontSize: 14, color: main99GrayColor),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
              margin: EdgeInsets.all(20),
              decoration: new BoxDecoration(
                // border: new Border.all(color: main99GrayColor, width: 0.5),
                //设置四周圆角 角度
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: Colors.white,
              ),
              child: Column(children: <Widget>[
                Container(
                    child: basicContent("服务条款", tapFunc: () {
                  // Global.context = context;
                  FlutterBoost.singleton.open(makeRouter(true, {},
                      "https://myouxuan.hzxituan.com/h5/notify/user-agreement.html"));
                })),
                line(true),
                Container(
                    child: basicContent("隐私条款", tapFunc: () {
                  // Global.context = context;
                  FlutterBoost.singleton.open(makeRouter(true, {},
                      "https://myouxuan.hzxituan.com/h5/notify/user-privacy.html"));
                }))
              ])),
          Expanded(
            flex: 3,
            child: Container(color: mainF5GrayColor, height: 60),
          ),
          Positioned(
              child: Container(
            width: double.infinity,
            color: mainF5GrayColor,
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Text(
                  "浙B2-20190758",
                  style: TextStyle(
                      fontSize: 14, height: 2, color: main99GrayColor),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '杭州喜团科技版权所有',
                  style: TextStyle(
                      fontSize: 14, height: 2, color: main99GrayColor),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Copyright@2019 XiTuan All Rights Reserved",
                  style: TextStyle(
                      fontSize: 14, height: 2, color: main99GrayColor),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )),
          Expanded(
            flex: 1,
            child: Container(color: mainF5GrayColor, height: 60),
          ),
          // bottomView(),
        ],
      ),
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