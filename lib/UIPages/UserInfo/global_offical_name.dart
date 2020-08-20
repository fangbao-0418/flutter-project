import 'package:flutter/material.dart';
import 'package:xtflutter/UIPages/NormalUI/XTAppBackBar.dart';
import 'package:xtflutter/XTConfig/AppConfig/XTColorConfig.dart';
import 'package:xtflutter/XTConfig/AppConfig/XTMethodConfig.dart';
import 'package:xtflutter/XTConfig/AppConfig/XTRouter.dart';
import 'package:xtflutter/XTModel/UserInfoModel.dart';
import 'package:xtflutter/XTNetWork/UserInfoRequest.dart';

class GlobalOfficalName extends StatefulWidget {
  @override
  _GlobalOfficalNameState createState() => _GlobalOfficalNameState();
}

class _GlobalOfficalNameState extends State<GlobalOfficalName> {
  /// 姓名
  final TextEditingController nameC = TextEditingController();

  ///身份证
  final TextEditingController idC = TextEditingController();

  bool showSave = false;
  void _xtback(BuildContext context) {
    XTRouter.closePage(context: context);
  }

  void _saveInfo(BuildContext context) {
    XTRouter.closePage(context: context);
  }

  void showRealname() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: (showSave
            ? xtBackBar(back: () => _xtback, title: "全球淘付款人实名信息")
            : xtbackAndRightBar(
                back: () => _xtback(context),
                title: "全球淘付款人实名信息",
                rightTitle: "保存",
                rightFun: () => _saveInfo(context))),
        body: addRealNamePage()

        // FutureBuilder(
        //   future: XTUserInfoRequest.getUserInfoData(),
        //   builder: (ctx, content) {
        //     if (!content.hasData) {
        //       return noRealNamePage();
        //     }
        //     if (content.error != null) {
        //       return Center(
        //         child: Text("网络错误，请重试"),
        //       );
        //     }
        //     return Container();
        //   },
        // ),
        );
  }

  Widget listName(List list) {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (ctx, index) {
          return itemCard(list[index]);
        });
  }

  Widget itemCard(RealNameModel name) {
    return Card(
      child: Text("7777"),
    );
  }

  Widget noRealNamePage() {
    return Center(
      child: Column(
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(top: 80, bottom: 40),
              child: Image.asset("images/empty_name.png")),
          Container(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              "您还没有实名认证信息哦～",
              style: TextStyle(fontSize: 14, color: main99GrayColor),
              textAlign: TextAlign.center,
            ),
          ),
          RaisedButton(
            elevation: 0,
            padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: BorderSide(
                    width: 0.5, color: mainRedColor, style: BorderStyle.solid)),
            onPressed: () {
              showRealname();
            },
            child: Text("马上认证",
                style: TextStyle(color: mainRedColor, fontSize: 14)),
          )
        ],
      ),
    );
  }

  Widget addRealNamePage() {
    return Column(
      children: <Widget>[
        Card(
            margin: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Image.asset(
                      "images/header_realname.png",
                      fit: BoxFit.fitHeight,
                    ),
                    Center(
                      child: Text("身份信息",
                          style: TextStyle(
                              color: whiteColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                Container(
                  height: 55,
                  color: Colors.white,
                  padding: EdgeInsets.only(left: 15),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("姓名",
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                      Expanded(
                        child: TextField(
                          controller: nameC,
                          decoration: InputDecoration(
                            hintText: "请输入付款账户的真实姓名",
                            hintStyle: TextStyle(
                                color: Color(0xffb9b5b5), fontSize: 16),
                            contentPadding:
                                EdgeInsets.only(left: 30, right: 15),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 55,
                  color: Colors.white,
                  padding: EdgeInsets.only(left: 15),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("证件号码",
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                      Expanded(
                        child: TextField(
                          controller: idC,
                          decoration: InputDecoration(
                            hintText: "请输入付款账户的身份证号",
                            hintStyle: TextStyle(
                                color: Color(0xffb9b5b5), fontSize: 16),
                            contentPadding:
                                EdgeInsets.only(left: 30, right: 15),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.radio_button_unchecked,
                          color: main99GrayColor,
                          size: 20,
                        ),
                        onPressed: () {}),
                    Text(
                      "默认实名人",
                      style: xtstyle(14, "666666"),
                    )
                  ],
                )
              ],
            )),
        Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 10, top: 10),
              child: Row(
                children: <Widget>[
                  Text(
                    "添加实名认证",
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Text(
                "1.根据海关规定，购买跨境商品需要办理清关手续，请您配合进行实名认证。",
                textAlign: TextAlign.left,
                softWrap: true,
                maxLines: 3,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Text(
                "2.购买跨境商品需要填写收货人的真实姓名，身份证号码，请如实填写，否则订单将无法正常发货。",
                textAlign: TextAlign.left,
                softWrap: true,
                maxLines: 3,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
