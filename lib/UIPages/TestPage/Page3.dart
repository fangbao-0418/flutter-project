import 'package:flutter/material.dart';
import 'package:xtflutter/UIPages/NormalUI/XTAppBackBar.dart';
import 'package:xtflutter/XTConfig/AppConfig/XTRouter.dart';
import 'package:xtflutter/Utils/Toast.dart';
import 'package:xtflutter/Utils/Loading.dart';

class TestPage3 extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<TestPage3> {
  void _xtback(BuildContext context) {
    XTRouter.closePage(context: context);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: xtBackBar(title: "page2", back: () => _xtback(context)),
        body: Column(children: [
          RaisedButton(
              onPressed: () {
                Loading.show(context: context);
              },
              child: Text('loading show')),
          RaisedButton(
              onPressed: () {
                Loading.hide();
              },
              child: Text('loading hide'))
        ]));
  }
}
