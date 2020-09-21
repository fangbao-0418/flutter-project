
import 'package:flutter/material.dart';
import 'package:xtflutter/Utils/appconfig.dart';

class LiveStationPage extends StatefulWidget {
  static String routerName = "LiveStationPage";
  @override
  _LiveStationPageState createState() => _LiveStationPageState();
}

class _LiveStationPageState extends State<LiveStationPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("liveStationHeight:" + AppConfig.navH.toString());
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(AppConfig.navH.toString()),
      ),
    );
  }
}
