import 'dart:async';
import 'package:flutter/material.dart';
import 'package:xtflutter/UIPages/NormalUI/XTAppBackBar.dart';
import 'package:xtflutter/XTConfig/AppConfig/XTRouter.dart';
import 'package:xtflutter/XTNetWork/UserInfoRequest.dart';
import 'package:xtflutter/Utils/Toast.dart';

Widget Label(String data) {
  return Align(
      alignment: Alignment.centerLeft,
      child: Text(data,
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(0, 0, 0, 1))));
}

FocusNode focusNode1 = new FocusNode();
FocusNode focusNode2 = new FocusNode();

final phoneController = TextEditingController();
final codeController = TextEditingController();

class EditPhonePage extends StatefulWidget {
  @override
  _EditPhonePageState createState() => _EditPhonePageState();
}

class _EditPhonePageState extends State<EditPhonePage>
    with WidgetsBindingObserver {
  bool showButton = true;
  String counterText;
  Timer _countdownTimer;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    print('didChangeMetrics');
    WidgetsBinding.instance.addPostFrameCallback((cb) {
      setState(() {
        showButton = MediaQuery.of(context).viewInsets.bottom == 0;
      });
    });
  }

  bool verifyPhone() {
    bool res = false;
    var phone = phoneController.text;
    var partten = RegExp("^1\\d{10}\$");
    if (phone.isEmpty) {
      Toast.showToast(msg: '手机号不能为空', context: context);
    } else if (!partten.hasMatch(phone)) {
      print(partten.hasMatch(phone));
      Toast.showToast(msg: '手机号格式错误', context: context);
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

  void onSubmit() {
    var phone = phoneController.text;
    var code = codeController.text;
    if (!verifyPhone()) {
      return;
    }
    print(code.isEmpty);
    if (code.isEmpty) {
      Toast.showToast(context: context, msg: '手机验证码不能为空');
      return;
    } else if (!RegExp('^\\d{6}\$').hasMatch(code)) {
      Toast.showToast(context: context, msg: '手机验证码格式错误');
      return;
    }
    XTUserInfoRequest.changeUserPhone(phone, code).then((res) {
      phoneController.text = '';
      codeController.text = '';
      Toast.showToast(msg: '修改成功', context: context).then(() {
        XTRouter.closePage(context: context);
      });
    }, onError: (e) {
      Toast.showToast(msg: e['message'], context: context);
    });
  }

  void _xtback(BuildContext context) {
    XTRouter.closePage(context: context);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: xtBackBar(title: "修改手机号", back: () => _xtback(context)),
        body: Container(
          color: Colors.white,
          child: Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 80, left: 40, right: 40),
                  child: Wrap(children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(right: 16),
                            child: Image(
                              image: AssetImage("images/edit-phone-icon.png"),
                              width: 60.0,
                            )),
                        Text(
                          '手机信息',
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 102),
                      child: Label('手机号码'),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(width: 1.0, color: Color(0xFFDDDDDD)),
                        ),
                      ),
                      child: TextField(
                        controller: phoneController,
                        onTap: () {
                          setState(() {
                            showButton = false;
                          });
                        },
                        maxLength: 11,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          hintText: '请输入手机号',
                          counterText: '',
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Label('验证码'),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(width: 1.0, color: Color(0xFFDDDDDD)),
                        ),
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: codeController,
                              onTap: () {
                                setState(() {
                                  showButton = false;
                                });
                              },
                              maxLength: 6,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  counterText: '',
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText: '请输入手机验证码',
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 16)),
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
                    )
                  ]),
                ),
                Positioned(
                    bottom: 35,
                    child: AnimatedOpacity(
                        duration: Duration(milliseconds: 0),
                        opacity: showButton ? 1 : 0,
                        child: RaisedButton(
                          padding: EdgeInsets.only(left: 50, right: 50),
                          color: Color(0xFFE60113),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          onPressed: () {
                            onSubmit();
                          },
                          child: Text("确认修改",
                              style: TextStyle(
                                  color: Color(0xFFFFFFFF), fontSize: 13)),
                        )))
              ]),
        ));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
