import 'package:flutter/material.dart';
import 'package:xtflutter/config/app_config/app_listener.dart';
import 'package:xtflutter/config/app_config/color_config.dart';
import 'package:xtflutter/config/app_config/method_config.dart';
import 'package:xtflutter/net_work/home_request.dart';
import 'package:xtflutter/r.dart';

enum CardType{
  live,//直播海报
}
///弹出底部分享弹框----带分享好友和生成海报
void showBottomShareDialog(BuildContext context, String page, String scene,{String title,String shareImg,String desc,CardType cardType = CardType.live,String anchorId}) {
  showModalBottomSheet(
      context: context,
      backgroundColor: whiteColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12))),
      builder: (ctx) {
        return Container(
          child: Container(
            height: 160,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      ///分享好友
                      Expanded(
                          child: GestureDetector(
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              R.imagesShareWechat,
                              height: 45,
                              width: 45,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            xtText("发给好友", 15, xtColor_4C4C4C),
                          ],
                        )),
                        onTap: () {
                          shareToMiNi(context, page, scene,title: title,shareImg: shareImg,desc: desc);
                        },
                      )),
                      ///生成海报
                      Expanded(
                          child: GestureDetector(
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              R.imagesShareGenImg,
                              height: 45,
                              width: 45,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            xtText("生成海报", 15, xtColor_4C4C4C),
                          ],
                        )),
                        onTap: () {
                          Navigator.of(context).pop();
                          //生成直播的海报
                          if(cardType == CardType.live){
                            //调用原生
                            var params = Map<String, dynamic>();
                            params["liveId"] = anchorId;
                            params["status"] = "4";
                            params["coverUrl"] = "https://assets.hzxituan.com/assets/2020_0104/live_header.png";
                            params["title"] = desc;
                            params["page"] = page;
                            AppListener.showLiveDialog(params);
                          }
                        },
                      )),
                    ],
                  ),
                ),
                Container(
                  height: 1,
                  color: xtColor_F5F5F5,
                ),
                GestureDetector(
                  child: Container(
                    color: whiteColor,
                    height: 50,
                    alignment: Alignment.center,
                    child: xtText("取消", 16, xtColor_4C4C4C),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
        );
      });
}

void shareToMiNi(BuildContext context, String page, String scene,{String title,String shareImg,String desc}){
  HomeRequest.getCardInfo({"page": page, "scene": scene})
      .whenComplete((){  Navigator.of(context).pop();})
      .then((value) {
    var shareModel = value.toJson();
    shareModel["appId"] = value.appid;
    shareModel["miniId"] = value.miniId;
    shareModel["page"] = page;
    shareModel["scene"] = scene;
    shareModel["title"] = title??"喜团,喜欢你就团!";
    shareModel["desc"] = desc??"";
    shareModel["imgUrl"] = shareImg??"https://assets.hzxituan.com/assets/2020_0104/live_header.png";
    shareModel["link"] = value.linkUrl??value.host;
    shareModel["host"] = value.host;
    shareModel["shareType"] = value.shareType;
    AppListener.shareWechat(shareModel);
  });
}
