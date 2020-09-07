import 'package:flutter/material.dart';
import 'package:xtflutter/pages/normal/app_nav_bar.dart';
import 'package:xtflutter/pages/normal/loading.dart';
import 'package:xtflutter/pages/normal/toast.dart';
import 'package:xtflutter/config/app_config/color_config.dart';
import 'package:xtflutter/config/app_config/method_config.dart';
import 'package:xtflutter/router/router.dart';
import 'package:xtflutter/model/userinfo_model.dart';
import 'package:xtflutter/net_work/userinfo_request.dart';

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
  bool isOnFocus1 = false;
  bool isOnFocus2 = false;
  FocusNode focusNode1 = new FocusNode();
  FocusNode focusNode2 = new FocusNode();
  String _name = "";
  String _idNo = "";
  int _selectNormal = 0;

  PageState pState = PageState.none;

  List listP = [];

  void _xtback(BuildContext context) {
    if (pState == PageState.none) {
      XTRouter.closePage(context: context);
    } else if (pState == PageState.showAdd) {
      if (listP.length > 0) {
        setState(() {
          pState = PageState.showlist;
        });
      } else {
        setState(() {
          pState = PageState.none;
        });
      }
    } else if (pState == PageState.showlist) {
      XTRouter.closePage(context: context);
    }
  }

  ///保存实名
  void _saveInfo(BuildContext context) async {
    Loading.show(context: context);
    XTUserInfoRequest.addmemberAdd(_name, _idNo, _selectNormal).then((res) {
      nameC.clear();
      idC.clear();

      RealNameModel mm = RealNameModel();
      mm.isDefault = _selectNormal;
      mm.name = _name;
      mm.idNo = _idNo;
      _name = "";
      _idNo = "";
      _selectNormal = 0;
      listP.add(mm);
      setState(() {
        pState = PageState.showlist;
      });
      memberAuthList();
    }).whenComplete(() {
      Loading.hide();
    });
  }

  /// 删除实名
  void addmemberDelete(int id) async {
    Loading.show(context: context);
    XTUserInfoRequest.addmemberDelete(id).then((result) {
      for (RealNameModel item in listP) {
        if (item.id == id) {
          listP.remove(item);
          break;
        }
      }
      setState(() {
        if (listP.length == 0) {
          pState = PageState.none;
        }
      });
    }).catchError((err) {
      Toast.showToast(msg: err.message);
    }).whenComplete(() {
      Loading.hide();
    });
  }

  void addRealName(RealNameModel model) {
    setState(() {
      listP.add(model);
    });
  }

  void showRealname() {
    setState(() {
      pState = PageState.showAdd;
    });
  }

  @override
  void initState() {
    super.initState();
    memberAuthList();
  }

  /// 实名列表
  void memberAuthList() async {
    List result = await XTUserInfoRequest.memberAuthList();
    if (result.length > 0) {
      listP = [];
      for (var item in result) {
        listP.add(item);
      }
      if (listP.length > 0) {
        setState(() {
          pState = PageState.showlist;
        });
      }
    } else {
      pState = PageState.none;
    }
  }

  /// 设置默认实名信息
  void setDefeat(int id) async {
    final result = await XTUserInfoRequest.addmemberDefault(id);
    if (result["success"] == true) {
      for (RealNameModel item in listP) {
        if (item.isDefault == 1 && item.id != id) {
          item.isDefault = 0;
        } else if (item.isDefault == 0 && item.id == id) {
          item.isDefault = 1;
        }
      }

      setState(() {
        print(123);
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
            rightFun: () => showRealname());
        break;
      case PageState.showAdd:
        return xtbackAndRightBar(
            back: () => _xtback(context),
            title: "全球淘付款人实名信息",
            rightTitle: "保存",
            rightFun: () => _saveInfo(context));
        break;
      case PageState.none:
        return xtBackBar(back: () => _xtback(context), title: "全球淘付款人实名信息");
        break;
      default:
        return xtBackBar(back: () => _xtback(context), title: "全球淘付款人实名信息");
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
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          focusNode1.unfocus();
          focusNode2.unfocus();
          setState(() {
            isOnFocus1 = false;
            isOnFocus2 = false;
          });
        },
        child: Scaffold(
          appBar: showBar(pState, context),
          body: showBody(pState, context),
        ));
  }

  Widget listName(List list) {
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
                  child: xtText(model.name, 14, mainBlackColor,
                      alignment: TextAlign.left),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 10, top: 5, bottom: 10),
                  child: xtText(model.idNo, 14, mainBlackColor,
                      alignment: TextAlign.left),
                ),
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
                      model.isDefault == 1
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color:
                          model.isDefault == 1 ? mainRedColor : main99GrayColor,
                      size: 20,
                    ),
                    onPressed: () {
                      setDefeat(model.id);
                    }),
                xtText("默认", 14, main66GrayColor),
                Expanded(child: Container()),
                FlatButton(
                    onPressed: () {
                      addmemberDelete(model.id);
                    },
                    child: xtText("删除", 16, mainBlackColor))
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget noRealNamePage() {
    return Center(
      child: Column(
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(top: 60, bottom: 20),
              child: Image.asset("images/empty_name.png")),
          Container(
            padding: EdgeInsets.only(bottom: 10),
            child: xtText("您还没有实名认证信息哦～", 14, main99GrayColor,
                alignment: TextAlign.center),
          ),
          RaisedButton(
            elevation: 0,
            padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
            color: Colors.white,
            shape: xtRoundLineCorners(
                radius: 8.0, lineWidth: 0.5, lineColor: mainRedColor),
            onPressed: () {
              showRealname();
            },
            child: xtText("马上认证", 14, mainRedColor),
          )
        ],
      ),
    );
  }

  Widget addRealNamePage() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Column(
            children: <Widget>[
              Card(
                  shape: xtRoundCorners(15.0), //设置圆角
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Stack(
                        alignment: Alignment.center,
                        // fit: StackFit.expand,
                        children: <Widget>[
                          Image.asset(
                            "images/header_realname.png",
                            fit: BoxFit.fill,
                            // alignment: Alignment.center,
                            width: double.maxFinite,
                          ),
                          Center(
                            child: xtText("身份信息", 18, whiteColor,
                                fontWeight: FontWeight.bold),
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
                            xtText("姓名        ", 16, mainBlackColor),
                            Expanded(
                              child: TextField(
                                controller: nameC,
                                focusNode: focusNode1,
                                onTap: () {
                                  setState(() {
                                    isOnFocus1 = true;
                                    isOnFocus2 = false;
                                  });
                                },
                                onChanged: (value) {
                                  _name = value;
                                },
                                decoration: InputDecoration(
                                  suffixIcon: isOnFocus1
                                      ? Container(
                                          width: 10,
                                          height: 10,
                                          margin: EdgeInsets.all(16),
                                          // color: main99GrayColor,
                                          decoration: BoxDecoration(
                                            color: main99GrayColor,
                                            border:
                                                Border.all(color: Colors.white),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)),
                                          ),
                                          child: IconButton(
                                              padding: EdgeInsets.zero,
                                              icon: Icon(
                                                Icons.close,
                                                size: 10,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                nameC.clear();
                                                _name = "";
                                              }),
                                        )
                                      : Text(""),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText: '请输入付款账户的真实姓名',
                                  counterText: '',
                                  hintStyle: TextStyle(
                                      color: main99GrayColor, fontSize: 14),
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
                            xtText("证件号码 ", 16, mainBlackColor),
                            Expanded(
                              child: TextField(
                                controller: idC,
                                focusNode: focusNode2,
                                onTap: () {
                                  setState(() {
                                    isOnFocus1 = false;
                                    isOnFocus2 = true;
                                  });
                                },
                                onChanged: (value) {
                                  _idNo = value;
                                },
                                decoration: InputDecoration(
                                  suffixIcon: isOnFocus2
                                      ? Container(
                                          width: 10,
                                          height: 10,
                                          margin: EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: main99GrayColor,
                                            border:
                                                Border.all(color: Colors.white),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)),
                                          ),
                                          child: IconButton(
                                              padding: EdgeInsets.zero,
                                              icon: Icon(
                                                Icons.close,
                                                size: 10,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                idC.clear();
                                                _idNo = "";
                                              }),
                                        )
                                      : Text(""),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText: '请输入付款账户的身份证号',
                                  counterText: '',
                                  hintStyle: TextStyle(
                                      color: main99GrayColor, fontSize: 14),
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
                                _selectNormal == 0
                                    ? Icons.check_circle_outline
                                    : Icons.check_circle,
                                color: _selectNormal == 0
                                    ? main99GrayColor
                                    : mainRedColor,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectNormal = _selectNormal == 0 ? 1 : 0;
                                });
                              }),
                          xtText("默认实名人", 14, main66GrayColor),
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
                        xtText("添加实名认证", 14, main66GrayColor,
                            alignment: TextAlign.left),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: xtText("1.根据海关规定，购买跨境商品需要办理清关手续，请您配合进行实名认证。", 12,
                        main99GrayColor,
                        maxLines: 3, softWrap: true),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: xtText(
                        "2.购买跨境商品需要填写收货人的真实姓名，身份证号码，请如实填写，否则订单将无法正常发货。",
                        12,
                        main99GrayColor,
                        maxLines: 3,
                        softWrap: true),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
