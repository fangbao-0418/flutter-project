import 'package:flutter/material.dart';
import 'package:xtflutter/UIPages/NormalUI/XTAppBackBar.dart';
import 'package:xtflutter/XTConfig/AppConfig/XTRouter.dart';
import 'package:xtflutter/Utils/Toast.dart';

class TestPage2 extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<TestPage2> {
  void _xtback(BuildContext context) {
    XTRouter.closePage(context: context);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: xtBackBar(title: "page2", back: () => _xtback(context)),
        body: RaisedButton(
            onPressed: () {
              XTRouter.pushToPage(routerName: 'page2', context: context);
            },
            child: Text('page2')));
  }
}
