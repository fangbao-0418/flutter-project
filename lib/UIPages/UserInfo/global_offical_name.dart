import 'dart:async';

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

enum PageState { none, showlist, showAdd }

class _GlobalOfficalNameState extends State<GlobalOfficalName> {
  /// 姓名
  final TextEditingController nameC = TextEditingController();

  ///身份证
  final TextEditingController idC = TextEditingController();

  PageState pState = PageState.none;

  List listP = [];

  void _xtback(BuildContext context) {
    XTRouter.closePage(context: context);
  }

  void _saveInfo(BuildContext context) {
    setState(() {
      pState = PageState.showlist;
    });
  }

  void _addInfo(BuildContext context) {
    // XTRouter.closePage(context: context);
    setState(() {
      pState = PageState.showAdd;
    });
  }

  void showRealname() {}

  @override
  void initState() {
    super.initState();
    memberAuthList();
  }

  /// 地址信息（新增/修改）
  void memberAuthList() async {
    final result = await XTUserInfoRequest.memberAuthList();
    for (var item in result) {
      listP.add(item);
    }
    if (listP.length > 0) {
      setState(() {
        pState = PageState.showlist;
      });
    }
  }

  AppBar showBar(PageState state, BuildContext context) {
    switch (pState) {
      case PageState.showlist:
        return xtbackAndRightBar(
            back: () => _xtback(context),
            title: "全球淘付款人实名信息",
            rightTitle: "添加",
            rightFun: () => _addInfo(context));
        break;
      case PageState.showAdd:
        return xtbackAndRightBar(
            back: () => _xtback(context),
            title: "全球淘付款人实名信息",
            rightTitle: "保存",
            rightFun: () => _saveInfo(context));
        break;
      case PageState.none:
        return xtBackBar(back: () => _xtback, title: "全球淘付款人实名信息");
        break;
      default:
        return xtBackBar(back: () => _xtback, title: "全球淘付款人实名信息");
    }
  }

  Widget showBody(PageState state, BuildContext context) {
    switch (pState) {
      case PageState.showlist:
        return listName(listP);
        break;
      case PageState.showAdd:
        return addRealNamePage();
        break;
      case PageState.none:
        return noRealNamePage();
        break;
      default:
        return noRealNamePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: showBar(pState, context), body: showBody(pState, context));
  }

  Widget listName(List list) {
    setState(() {});
    return Container(
      padding: EdgeInsets.only(top: 5, left: 5, right: 5),
      child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (ctx, index) {
            return itemCard(list[index]);
          }),
    );
  }

  Widget itemCard(RealNameModel model) {
    return Card(
      child: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(left: 10, top: 10, bottom: 5),
                    child: Text(
                      model.name,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.left,
                    )),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(left: 10, top: 5, bottom: 10),
                    child: Text(
                      model.idNo,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.left,
                    )),
              ],
            ),
            Container(
              height: 1,
              color: mainF5GrayColor,
            ),
            Row(
              children: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.radio_button_unchecked,
                      color: mainRedColor,
                      size: 20,
                    ),
                    onPressed: () {}),
                Text(
                  "默认",
                  style: xtstyle(14, "666666"),
                ),
                Expanded(child: Container()),
                FlatButton(
                    onPressed: () {
                      print("shanchule");
                      deleteList(model);
                    },
                    child: Text(
                      "删除",
                      style: TextStyle(color: mainBlackColor),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }

  void deleteList(RealNameModel model) {
    setState(() {
      listP.remove(model);
    });
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
