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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: xtBackBar(title: "page1", back: () => _xtback(context)),
      body: RaisedButton(
        onPressed: () {
          Toast.showToast(msg: 'page1');
        },
        child: Text('page1')
      )
    );
  }
}
