import 'dart:convert';
import 'dart:async';
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
import 'package:xtflutter/XTConfig/AppConfig/AppConfig.dart';

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
    final url = "/cweb/member/getMember33";
    final result = await HttpRequest.request(url);
    return result;
    // // print(result);
    // final userModel = result["data"];
    // print(userModel);
    // UserInfoModel model = UserInfoModel.fromJson(userModel);
    // print(model);
    // print('xxxxxxxxxxxxxxxxxxx');
    // return model;
    // // return Future.value('ssss');
  }

  String title = 'page1';
  // Future<dynamic> future = XTUserInfoRequest.getUserInfoData();
  // setK() {}
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: xtBackBar(title: title, back: () => _xtback(context)),
        body: FutureBuilder(
            future: Future.value('ssss').then((res) {
              // print('-------------------');
              // setState(() {
              //   title = 'page2';
              // });
              return res;
            }),
            builder: (ctx, snapshot) {
              print('builder');
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RaisedButton(
                        onPressed: () {
                          Map<String, String> o1 = {
                            'a': 'a',
                            'b': 'b'
                          };
                           Map<String, String> o2 = {
                             ...o1,
                             'c': 'c'
                           };
                          // getUserInfoData();
                          // setState(() {
                          //   title = 'xxx';
                          // });
                          // toast = Toast.showToast(msg: jsonEncode(o2)).then(() {
                          //   print('xxxx');
                          // });
                          Future.delayed(new Duration(milliseconds: 1000), () {
                            print('delay');
                          });
                          print('show');
                          // Prefs.getStringList('xt-logdata').then((value){
                          //   print('get xt-logdata');
                          //   print(value.length);
                          // });
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
                        //   writeCounter(2);
                        //  readCounter().then((value) {
                        //    print(value);
                        //  });
                        //   print('write');
                          // dynamic o;
                          // print(o.a.b);
                          throw ('error test');
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
                    RaisedButton(
                        onPressed: () {
                          // Toast.showToast(msg: 'getSoftInfoData');
                          // getUserInfoData();
                          print(AppConfig.soft.dv);
                        },
                        child: Text('getSoftInfoData')),
                    Row(
                      children: <Widget>[
                        RaisedButton(
                            onPressed: () {
                              List<String> data = [];
                              data.addAll([
                                jsonEncode({'a': 'b'}),
                                jsonEncode({'a1': 'b1'}),
                                jsonEncode({'a2': 'b2'})
                              ]);
                               print(data.sublist(0, 1));
                              print(data.sublist(1));
                              print(data.map((e) => jsonEncode(e)).toList());
                              // Prefs.setStringList('logs', data);
                              // print('set ok');
                            },
                            child: Text('storage set')),
                        RaisedButton(
                            onPressed: () {

                              // getUserInfoData();
                              // print('xxxxx');
                              // Future fetchData () {
                              //   return Future.error((err) {
                              //     return 'err';
                              //   });
                              // }

                              // fetchData().then((value) {
                              //   print('value1');
                              // }, onError: (e) {
                              //   print('error');
                              //   // return Future.error(e);
                              //   // throw 'sss';
                              // }).then((value) {
                              //   print('value2');
                              // });
                              // List<String> row = ['1', '2' , '3', '4'];
                              // print(row.sublist(2, 2));
                              // loop () {
                              //   Future.delayed(Duration(milliseconds: 500), () {
                              //     if (row.length > 0) {
                              //       row.removeAt(0);
                              //       print(row);
                              //       loop();
                              //     }
                              //   });
                              // }

                              // loop();
                              // Prefs.getStringList('xt-logdata')
                              //     .then((value) => {print(value)});
                            },
                            child: Text('storage get')),
                      ],
                    )
                  ]);
            }));
  }
}
