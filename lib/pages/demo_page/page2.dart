import 'package:flutter/material.dart';
import 'package:xtflutter/pages/normal/app_nav_bar.dart';
import 'package:xtflutter/router/router.dart';

class Testpage2 extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Testpage2> {
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
