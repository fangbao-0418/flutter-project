import 'package:flutter/material.dart';
import 'package:xtflutter/Utils/appconfig.dart';
import 'package:xtflutter/config/app_config/color_config.dart';
import 'package:xtflutter/config/app_config/method_config.dart';
import 'package:xtflutter/pages/normal/toast.dart';
import 'package:xtflutter/router/router.dart';

class LiveStreamerStationPage extends StatefulWidget {
  static String routerName = "LiveStreamerStationPage";

  @override
  _LiveStreamerStationPageState createState() =>
      _LiveStreamerStationPageState();
}

class _LiveStreamerStationPageState extends State<LiveStreamerStationPage> {
  String navTitle = "喜团优选直播";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("liveStationHeight:${AppConfig.navH}");
    return Scaffold(
      appBar: AppBar(),
      body: Stack(children: <Widget>[

        obtainLiveAppBar(),
        Container(
          padding: EdgeInsets.only(top: AppConfig.navH),
            child: ListView.builder(
                padding: EdgeInsets.only(top: 0),
                itemCount: 10,
                itemBuilder: (context, index) {
//            final model = models[index];
                  if (index == 0) {
                    return obtainProfileWidget();
                  } else {
                    return Container();
                  }
                })),
      ],)
    );
  }

  Widget obtainLiveAppBar() {
    return Container(
      height: AppConfig.navH,
      child: AppBar(
        backgroundColor: xtColor_E10264,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          color: whiteColor,
          icon: Icon(
            Icons.arrow_back,
            size: 22,
          ),
          onPressed: () {
            XTRouter.closePage(context: context);
          },
        ),
        title: GestureDetector(
          child: Row(
            children: <Widget>[
              Spacer(flex: 2),
              xtText(navTitle, 18, whiteColor),
              Container(
                child: Image.asset("images/live_station_arrow_down.png"),
                margin: EdgeInsets.only(left: 5),
              ),
              Spacer(flex: 2),
            ],
          ),
          onTap: () {
            Toast.showToast(msg: "切换直播类型", context: context);
          },
        ),
        actions: <Widget>[
          FlatButton(
            textColor: whiteColor,
            splashColor: xtColor_E10264,
            highlightColor: xtColor_E10264,
            child: Text("我的店铺", style: xtstyle(14, whiteColor)),
            onPressed: () {
              Toast.showToast(msg: "我的店铺", context: context);
            },
          ),
        ],
      ),
    );
  }

  //主播信息
  Widget obtainProfileWidget(){
    return Stack(
      children: <Widget>[
        Container(
            width: double.infinity,
            child: Image(
              image: AssetImage("images/live_station_top_bg.png"),
              fit: BoxFit.fitWidth,
            )),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 12),
              width: 48,
              height: 48,
              child: CircleAvatar(
                radius: 24,
                child: Image.network(
                  "",
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: xtText("全宇宙最酷的大猫崽", 16, whiteColor),
                  ),
                  Row(
                    children: <Widget>[
                      Image.asset("images/live_star.png"),
                      Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: xtText("星级主播", 12, whiteColor),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  // ignore: missing_return
  Widget obtainTopContainer() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/live_station_top_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Text(
          'Hello Wolrd',
          style: TextStyle(fontSize: 22.0, color: Colors.white),
        ),
      ),
    );
  }
}
