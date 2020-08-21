import 'package:flutter/material.dart';
import 'package:xtflutter/UIPages/NormalUI/XTAppBackBar.dart';
import 'package:xtflutter/XTConfig/AppConfig/XTRouter.dart';
import 'package:xtflutter/Utils/Toast.dart';
import 'package:xtflutter/Utils/Error/ReportError.dart';
import 'package:xtflutter/XTNetWork/httpRequest.dart';
import 'package:xtflutter/XTNetWork/UserInfoRequest.dart';
import 'package:xtflutter/XTModel/UserInfoModel.dart';
import 'package:xtflutter/Utils/Storage/PathProvider.dart';
import 'package:xtflutter/Utils/Storage/SharedPreferences.dart';

class TestPage1 extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<TestPage1> {
  void _xtback(BuildContext context) {
    XTRouter.closePage(context: context);
  }

  Toast toast;
  dynamic s;
  Future<UserInfoModel> getUserInfoData() async {
    // 1.发送网络请求
    final url = "/cweb/member/getMember/222";
    final result = await HttpRequest.request(url);
    final userModel = result["data"];
    UserInfoModel model = UserInfoModel.fromJson(userModel);
    return model;
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: xtBackBar(title: "page1", back: () => _xtback(context)),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
          RaisedButton(
              onPressed: () {
                toast = Toast.showToast(msg: 'page1').then(() {
                  print('xxxx');
                });
                // print('show');
              },
              child: Text('show toast')),
          RaisedButton(
              onPressed: () {
                // print('hide');
                // print(toast);
                toast?.cancel();
              },
              child: Text('ins hide toast')),
          RaisedButton(
              onPressed: () {
                toast?.cancelAll();
              },
              child: Text('ins hide all toast')),
          RaisedButton(
              onPressed: () {
                Toast.cancel();
              },
              child: Text('global hide toast')),
          RaisedButton(
              onPressed: () {
                Toast.cancelAll();
              },
              child: Text('global hide all toast')),
          RaisedButton(
              onPressed: () {
                writeCounter(2);
                // dynamic o;
                // print(o.a.b);
                // throw ('error test');
                // throwError('title', )
                // throwError('title', 'XXXX');
                // XTUserInfoRequest.sendCode(phone: '');
                // XTUserInfoRequest.getUserInfoData().then((res) {
                //   print('res ok');
                //   print(res);
                //   // throwError('title', res.toJson().toString());
                //   // throw 'xxxxx';
                // });
              },
              child: Text('throw error')),
          RaisedButton(
              onPressed: () {
                Toast.showToast(msg: 'getUserInfoData');
                getUserInfoData();
              },
              child: Text('throw network error')),
          Row(
            children: <Widget>[
              RaisedButton(
                  onPressed: () {
                    Prefs.setStringList('logs', ['a', 'b']);
                    print('set ok');
                  },
                  child: Text('storage set')),
              RaisedButton(
                  onPressed: () {
                    Prefs.getStringList('logs').then((value) => {
                      print(value)
                    });
                  },
                  child: Text('storage get')),
            ],
          )
        ]));
  }
}
