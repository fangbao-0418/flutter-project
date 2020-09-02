import 'dart:async';
import 'package:flutter/material.dart';
import 'package:xtflutter/ui_pages/ui_normal/app_nav_bar.dart';
import 'package:xtflutter/xt_config/app_config/xt_color_config.dart';
import 'package:xtflutter/xt_config/app_config/xt_router.dart';
import 'package:xtflutter/xt_net_work/userinfo_request.dart';
import 'package:xtflutter/utils/toast.dart';

Widget label(String data) {
  return Align(
      alignment: Alignment.centerLeft,
      child: Text(data,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: mainBlackColor)));
}

class EditPhonePage extends StatefulWidget {
  @override
  _EditPhonePageState createState() => _EditPhonePageState();
}

class _EditPhonePageState extends State<EditPhonePage>
    with WidgetsBindingObserver {
  bool showButton = false;
  String counterText;
  Timer _countdownTimer;
  bool isOnFocus1 = false;
  bool isOnFocus2 = false;
  final phoneController = TextEditingController();
  final codeController = TextEditingController();
  FocusNode focusNode1 = new FocusNode();
  FocusNode focusNode2 = new FocusNode();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    phoneController.dispose();
    codeController.dispose();
    super.dispose();
  }

  bool verifyPhone() {
    bool res = false;
    var phone = phoneController.text;
    var partten = RegExp("^1\\d{10}\$");
    if (phone.isEmpty) {
      Toast.showToast(msg: '手机号不能为空');
    } else if (!partten.hasMatch(phone)) {
      print(partten.hasMatch(phone));
      Toast.showToast(msg: '手机号格式错误');
    } else {
      res = true;
    }
    return res;
  }

  // 倒计时
  void countDown() {
    if (!verifyPhone()) {
      return;
    }
    var phone = phoneController.text;
    var counter = 59;
    if (_countdownTimer != null) {
      return;
    }
    XTUserInfoRequest.sendCode(phone: phone).then((data) {
      setState(() {
        counterText = '发送验证码(60)';
      });
      _countdownTimer = new Timer.periodic(new Duration(seconds: 1), (timer) {
        if (counter == 0) {
          setState(() {
            counterText = null;
          });
          _countdownTimer.cancel();
          _countdownTimer = null;
        } else {
          setState(() {
            counterText = '发送验证码(${counter--})';
          });
        }
      });
    });
  }

  void onSubmit() async {
    var phone = phoneController.text;
    var code = codeController.text;
    if (!verifyPhone()) {
      return;
    }
    if (code.isEmpty) {
      Toast.showToast(context: context, msg: '手机验证码不能为空');
      return;
    } else if (!RegExp('^\\d{6}\$').hasMatch(code)) {
      Toast.showToast(msg: '手机验证码格式错误');
      return;
    }
    XTUserInfoRequest.changeUserPhone(phone, code).then((result) {
      phoneController.text = '';
      codeController.text = '';
      Toast.showToast(msg: '修改成功', context: context).then(() {
        XTRouter.closePage(context: context);
      });
    });
  }

  void _xtback(BuildContext context) {
    XTRouter.closePage(context: context);
  }

  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          focusNode1.unfocus();
          focusNode2.unfocus();
          isOnFocus1 = false;
          isOnFocus2 = false;
          showSubmitBtn();
        },
        child: Scaffold(
            appBar: xtBackBar(title: "修改手机号", back: () => _xtback(context)),
            body: Container(
              color: Colors.white,
              child: Stack(
                  alignment: Alignment.center,
                  fit: StackFit.expand,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 20, left: 30, right: 30),
                      child: Wrap(children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 40),
                          child: label('手机号码'),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 0, right: 10),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  width: 1.0, color: Color(0xFFDDDDDD)),
                            ),
                          ),
                          child: TextField(
                            controller: phoneController,
                            focusNode: focusNode1,
                            onTap: () {
                              setState(() {
                                isOnFocus1 = true;
                                isOnFocus2 = false;
                              });
                            },
                            onChanged: (change) {
                              showSubmitBtn();
                            },
                            maxLength: 11,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              suffixIcon: isOnFocus1
                                  ? Container(
                                      width: 10,
                                      height: 10,
                                      margin: EdgeInsets.all(16),
                                      // color: main99GrayColor,
                                      decoration: BoxDecoration(
                                        color: main99GrayColor,
                                        border: Border.all(color: Colors.white),
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
                                            clearClick(phoneController);
                                          }),
                                    )
                                  : Text(""),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              hintText: '请输入手机号',
                              counterText: '',
                              hintStyle: TextStyle(
                                  color: main99GrayColor, fontSize: 16),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: label('验证码'),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 0, right: 10),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  width: 1.0, color: Color(0xFFDDDDDD)),
                            ),
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: TextField(
                                  focusNode: focusNode2,
                                  controller: codeController,
                                  onTap: () {
                                    setState(() {
                                      isOnFocus2 = true;
                                      isOnFocus1 = false;
                                    });
                                  },
                                  onChanged: (change) {
                                    showSubmitBtn();
                                  },
                                  maxLength: 6,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      suffixIcon: isOnFocus2
                                          ? Container(
                                              width: 10,
                                              height: 10,
                                              margin: EdgeInsets.all(16),
                                              // color: main99GrayColor,
                                              decoration: BoxDecoration(
                                                color: main99GrayColor,
                                                border: Border.all(
                                                    color: Colors.white),
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
                                                    print(" clear -- clear ");
                                                    clearClick(codeController);
                                                  }),
                                            )
                                          : Text(""),
                                      counterText: '',
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                      hintText: '请输入验证码',
                                      hintStyle: TextStyle(
                                          color: main99GrayColor,
                                          fontSize: 16)),
                                ),
                              ),
                              Container(
                                  width: 1,
                                  height: 12,
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  color: Color(0xFFDDDDDD)),
                              GestureDetector(
                                onTap: () {
                                  countDown();
                                },
                                child: Text(
                                    counterText != null ? counterText : '发送验证码',
                                    style: TextStyle(
                                        color: counterText == null
                                            ? Color.fromRGBO(141, 141, 141, 1)
                                            : Color.fromRGBO(216, 216, 216, 1),
                                        fontSize: 16)),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 40),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child:
                                    Container(color: Colors.white, height: 60),
                              ),
                              Offstage(
                                  offstage: !showButton,
                                  child: FlatButton(
                                    splashColor: mainRedColor,
                                    highlightColor: mainRedColor,
                                    padding: EdgeInsets.only(
                                        left: 50,
                                        right: 50,
                                        top: 10,
                                        bottom: 10),
                                    color: mainRedColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                    onPressed: () {
                                      onSubmit();
                                    },
                                    child: Text("确认修改",
                                        style: TextStyle(
                                            color: Color(0xFFFFFFFF),
                                            fontSize: 13)),
                                  )),
                              Expanded(
                                flex: 1,
                                child:
                                    Container(color: Colors.white, height: 60),
                              ),
                            ],
                          ),
                        )
                      ]),
                    ),
                  ]),
            )));
  }

  void showSubmitBtn() {
    print(codeController.text);
    print(phoneController.text);
    if (codeController.text.length == 6 && phoneController.text.length == 11) {
      setState(() {
        showButton = true;
      });
    } else {
      setState(() {
        showButton = false;
      });
    }
  }

  void clearClick(TextEditingController edit) {
    edit.clear();
    showSubmitBtn();
  }
}
