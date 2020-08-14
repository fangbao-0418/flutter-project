import 'package:flutter/material.dart';
import 'package:xtflutter/UIPages/NormalUI/XTAppBackBar.dart';
import 'package:xtflutter/XTConfig/AppConfig/XTRouter.dart';
import 'package:xtflutter/Utils/Toast.dart';

class TestPage1 extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<TestPage1> {
  void _xtback(BuildContext context) {
    XTRouter.closePage(context: context);
  }

  Toast toast;
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: xtBackBar(title: "page1", back: () => _xtback(context)),
        body: Column(children: <Widget>[
          RaisedButton(
              onPressed: () {
                toast = Toast.showToast(msg: 'page1').then((res) {
                  print('xxxx');
                });
              },
              child: Text('show toast')),
          RaisedButton(
              onPressed: () {
                toast.cancel();
              },
              child: Text('ins hide toast')),
          RaisedButton(
              onPressed: () {
                toast.cancelAll();
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
        ]));
  }
}
