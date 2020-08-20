import 'dart:html';

import 'package:flutter/material.dart';
import 'package:xtflutter/UIPages/NormalUI/XTAppBackBar.dart';
import 'package:xtflutter/XTConfig/AppConfig/XTColorConfig.dart';
import 'package:xtflutter/XTConfig/AppConfig/XTRouter.dart';
import 'package:xtflutter/XTModel/UserInfoModel.dart';
import 'package:xtflutter/XTNetWork/UserInfoRequest.dart';

class GlobalOfficalName extends StatefulWidget {
  @override
  _GlobalOfficalNameState createState() => _GlobalOfficalNameState();
}

class _GlobalOfficalNameState extends State<GlobalOfficalName> {
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
      body: noRealNamePage()
      
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
    return Container(
      child: Column(
        children: <Widget>[
          Image.asset("empty_name.png"),
          Text(
            "您还没有实名认证信息哦～",
            style: TextStyle(fontSize: 14, color: main99GrayColor),
            textAlign: TextAlign.center,
          ),
          RaisedButton(
            elevation: 0,
            padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: BorderSide(
                    width: 0.5, color: mainRedColor, style: BorderStyle.solid)),
            onPressed: () {
              showRealname();
            },
            child: Text("马上认证",
                style: TextStyle(color: mainRedColor, fontSize: 12)),
          )
        ],
      ),
    );
  }

  Widget addRealNamePage() {
    return Container(
      child: Text("添加实名认证"),
    );
  }
}
