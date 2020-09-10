import 'package:flutter/material.dart';
import 'package:xtflutter/pages/normal/app_nav_bar.dart';
import 'package:xtflutter/router/router.dart';

class LimitTimeSpikePage extends StatefulWidget {
  static String routerName = "limitTimeSpick";

  @override
  _LimitTimeSpikePageState createState() => _LimitTimeSpikePageState();
}

class _LimitTimeSpikePageState extends State<LimitTimeSpikePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: xtBackBar(
          title: "限时秒杀", back: () => XTRouter.closePage(context: context)),
      body: Container(

      ),
    );
  }
}