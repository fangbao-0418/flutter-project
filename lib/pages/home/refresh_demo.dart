import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:xtflutter/pages/normal/app_nav_bar.dart';
import 'package:xtflutter/router/router.dart';
import 'package:xtflutter/utils/appconfig.dart';

class RefreshDemoPage extends StatefulWidget {
  static String routerName = "refresh";

  @override
  _RefreshDemoPageState createState() => _RefreshDemoPageState();
}

class _RefreshDemoPageState extends State<RefreshDemoPage> {
  int _count = 20;
  EasyRefreshController _controller = EasyRefreshController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: xtBackBar(
          title: "刷新", back: () => XTRouter.closePage(context: context)),
      body: EasyRefresh(
        controller: _controller,
        header: ClassicalHeader(),
        footer: ClassicalFooter(),
        onLoad: () async {
          await Future.delayed(Duration(seconds: 2), () {
            setState(() {
              _count += 10;
            });
            _controller.finishLoad(noMore: _count >= 100);
          });
        },
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 2), () {
            setState(() {
              _count = 20;
            });
            _controller.resetLoadState();
          });
        },
        child: ListView.builder(
          itemExtent: 100,
          itemCount: _count,
          itemBuilder: (BuildContext ctx, int index) {
            return Container(
              child: Center(
                child: Text(index.toString(), style: TextStyle(backgroundColor: Colors.red)),
              ),
            );
          }
        )
      ),
    );
  }
}