import 'package:flutter/material.dart';
import 'package:xtflutter/pages/normal/app_nav_bar.dart';
import 'package:xtflutter/pages/normal/loading.dart';
import 'package:xtflutter/pages/normal/toast.dart';
import 'package:xtflutter/model/userinfo_model.dart';
import 'package:xtflutter/net_work/userinfo_request.dart';
import 'package:xtflutter/router/router.dart';

class AlipayAccountPage extends StatefulWidget {
  static String routerName = "alipayAccount";

  @override
  _AlipayAccountPageState createState() => _AlipayAccountPageState();
}

class _AlipayAccountPageState extends State<AlipayAccountPage> {
  /// 收货人
  final TextEditingController accountTextCon = TextEditingController();

  /// 手机号
  final TextEditingController nameTextCon = TextEditingController();

  /// 支付宝账户信息
  AlipayAccountModel _account;
  String _accountNum = "";

  /// 是否显示已有账户信息页面
  bool _isShowHaveAccount = false;

  /// 是否显示没有账户信息页面
  bool _isShowNoAccount = false;

  @override
  void initState() {
    super.initState();
    getAlipayAccountInfo();
  }

  /// 获取支付宝账号信息
  void getAlipayAccountInfo() async {
    Loading.show(context: context);
    try {
      _account = await XTUserInfoRequest.getAlipayAccountReq();
      if (_account != null && _account.accountNumber.isNotEmpty) {
        setState(() {
          _isShowHaveAccount = true;
          _isShowNoAccount = false;
          _accountNum = _account.accountNumber;
        });
      } else {
        setState(() {
          _isShowHaveAccount = false;
          _isShowNoAccount = true;
        });
      }
    } catch (err) {
      print(err);
    }
    Loading.hide();
  }

  /// 保存支付宝账户信息
  void saveAlipayAccountInfo() async {
    Loading.show(context: context);
    bool isSuccess = await XTUserInfoRequest.saveAlipayAccountReq({
      "accountNumber": accountTextCon.text,
      "accountUserName": nameTextCon.text
    });
    Loading.hide();
    if (isSuccess) {
      Toast.showToast(msg: "保存成功", context: context);
      setState(() {
        _account = AlipayAccountModel(
            accountUserName: nameTextCon.text,
            accountNumber: accountTextCon.text);
        _accountNum = accountTextCon.text;
        _isShowHaveAccount = true;
        _isShowNoAccount = false;
      });
    } else {
      Toast.showToast(msg: "保存失败，请重试", context: context);
    }
  }

  /// 修改支付宝账号
  void changeAlipayAccount() {
    setState(() {
      _isShowHaveAccount = false;
      _isShowNoAccount = true;
      accountTextCon.text = _account.accountNumber;
      nameTextCon.text = _account.accountUserName;
    });
  }

  /// 保存支付宝账号
  void saveAlipayAccount() {
    if (accountTextCon.text.isEmpty) {
      Toast.showToast(msg: "支付宝账号不能为空", context: context);
      return;
    }
    if (nameTextCon.text.isEmpty) {
      Toast.showToast(msg: "姓名不能为空", context: context);
      return;
    }
    saveAlipayAccountInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: xtBackBar(
          title: "支付宝", back: () => XTRouter.closePage(context: context)),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: <Widget>[
            Visibility(
                visible: _isShowHaveAccount,
                child: Positioned.fill(child: haveAccountInfoView())),
            Visibility(
                visible: _isShowNoAccount,
                child: Positioned.fill(child: noAccountInfoView())),
          ],
        ),
      ),
    );
  }

  /// 有账号信息
  Widget haveAccountInfoView() {
    return Container(
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: <Widget>[
          CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Column(
                  children: <Widget>[
                    Container(
                        height: 1.5,
                        color: Color(0xFFF9F9F9),
                        margin: EdgeInsets.only(left: 15, right: 15)),
                    Container(
                      height: 55,
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("支付宝账号",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16)),
                          Text(_accountNum,
                              style: TextStyle(
                                  color: Color(0xff969696), fontSize: 16)),
                        ],
                      ),
                    ),
                    Container(
                        height: 1.5,
                        color: Color(0xFFF9F9F9),
                        margin: EdgeInsets.only(left: 15, right: 15)),
                  ],
                ),
              )
            ],
          ),
          Positioned(
              bottom: 80,
              child: FlatButton(
                padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(
                        width: 0.5,
                        color: Color(0xFFE60113),
                        style: BorderStyle.solid)),
                onPressed: () {
                  changeAlipayAccount();
                },
                child: Text("修改支付宝账号",
                    style: TextStyle(color: Color(0xFFE60113), fontSize: 15)),
              )),
        ],
      ),
    );
  }

  /// 无账号信息
  Widget noAccountInfoView() {
    return Container(
      color: Colors.white,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                Container(height: 10, color: Color(0xFFF9F9F9)),
                accountAndNameView(true),
                Container(
                    height: 1.5,
                    color: Color(0xFFF9F9F9),
                    margin: EdgeInsets.only(left: 15, right: 15)),
                accountAndNameView(false),
                Container(
                    height: 1.5,
                    color: Color(0xFFF9F9F9),
                    margin: EdgeInsets.only(left: 15, right: 15)),
                Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 15, top: 5),
                    child: Text("*如果支付宝账号和姓名不匹配，将无法到账",
                        textAlign: TextAlign.left,
                        style:
                            TextStyle(fontSize: 12, color: Color(0xffe60113)))),
                SizedBox(height: 150),
                saveButton(),
                SizedBox(height: 50),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget accountAndNameView(bool isAccount) {
    return Container(
      height: 55,
      padding: EdgeInsets.only(left: 15),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(isAccount ? "支付宝账号" : "姓名",
              style: TextStyle(color: Colors.black, fontSize: 16)),
          Expanded(
            child: TextField(
              controller: isAccount ? accountTextCon : nameTextCon,
              keyboardType:
                  isAccount ? TextInputType.emailAddress : TextInputType.text,
              decoration: InputDecoration(
                hintText: isAccount ? "请输入支付宝账号" : "请输入真实姓名",
                hintStyle: TextStyle(color: Color(0xffb9b5b5), fontSize: 16),
                contentPadding: EdgeInsets.only(left: 15, right: 15),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget saveButton() {
    return RaisedButton(
      color: Color(0xffe60113),
      child: Text("保存", style: TextStyle(color: Colors.white, fontSize: 16)),
      padding: EdgeInsets.fromLTRB(80, 10, 80, 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onPressed: () {
        saveAlipayAccount();
      },
    );
  }
}
