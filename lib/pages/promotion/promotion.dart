import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:xtflutter/config/app_config/color_config.dart';
import 'package:xtflutter/config/app_config/method_config.dart';
import 'package:xtflutter/model/coupon_model.dart';
import 'package:xtflutter/model/promotion_model.dart';
import 'package:xtflutter/net_work/http_request.dart';
import 'package:xtflutter/net_work/promotion_request.dart';
import 'package:xtflutter/pages/normal/app_nav_bar.dart';
import 'package:xtflutter/pages/promotion/promotionItem/banner.dart';
import 'package:xtflutter/pages/promotion/promotionItem/player.dart';
import 'package:xtflutter/pages/promotion/promotionItem/title_sepment.dart';
import 'package:xtflutter/pages/promotion/promotionItem/tab_bottom.dart';
import 'package:xtflutter/router/router.dart';
import 'package:xtflutter/utils/appconfig.dart';

class Promotion extends StatefulWidget {
  static const routerName = "promotion";

  Promotion({this.name, this.params});

  /// 路由名称
  final String name;

  /// 传过来的参数
  final Map<String, dynamic> params;

  @override
  _PromotionState createState() => _PromotionState();
}

class _PromotionState extends State<Promotion> {
  Map<String, List<CouponModel>> coupons = {};
  List<String> couponIds = [];
  int couponCount = 0;
  List images = [
    "https://sh-tximg.hzxituan.com/tximg/crm/e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b8551600150139328.jpg",
    "https://sh-tximg.hzxituan.com/tximg/crm/e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b8551600150139328.jpg"
  ];
  List<String> imagesPadding = ["10", "10"];
  PromotionData dataInfo = PromotionData();

  String title = "最新推进啊";

  @override
  void initState() {
    super.initState();
    promotionInfo();
  }

  void promotionInfo() {
    print("--------------------va");

    PromotionRequest.promotionMgic(widget.params["id"]).then((value) {
      print("--------------------va" + value.toString());
      Map<String, dynamic> map = Map.from(value);
      PromotionData tt = PromotionData.fromJson(map);
      // print(tt.componentVoList.length);
      var list = tt.componentVoList;
      List<ComponentVoList> temp = [];

      var memberType = AppConfig.user.memberType != null
          ? AppConfig.user.memberType.toString()
          : "0";

      for (var item in list) {
        if (item.platform.contains("wx-h5") &&
            item.userLevel.contains(memberType)) {
          temp.add(item);
        }

        if (item.type == "coupon") {
          coupons[item.id.toString()] = [];
          couponIds.add(item.id.toString());
        }
      }
      tt.componentVoList = temp;
      setState(() {
        dataInfo = tt;
      });
      getCouponsData();
      print("object1" + dataInfo.componentVoList.length.toString());
    }).whenComplete(() {
      print("object");
    });
  }

  void getCouponsData() {
    for (var ids in couponIds) {
      PromotionRequest.promotionMgicData(ids, 1).then((value) {
        List<CouponModel> list = [];
        for (var item in value["list"]) {
          CouponModel temp = CouponModel.fromJson(Map.from(item));
          // print(item.toString());
          list.add(temp);
        }
        print("list.length--------------");
        coupons[ids] = list;
      }).whenComplete(() {
        couponCount++;
        if (couponCount == couponIds.length) {
          print("--------------couponCountfinish--------------");
          print("--------------刷新优惠券--------------");
        }
      });
    }
  }

  void getGoodsData() {
    for (var ids in couponIds) {
      PromotionRequest.promotionMgicData(ids, 1).then((value) {
        List<CouponModel> list = [];
        for (var item in value["list"]) {
          CouponModel temp = CouponModel.fromJson(Map.from(item));
          // print(item.toString());
          list.add(temp);
        }
        print("list.length--------------");
        coupons[ids] = list;
      }).whenComplete(() {
        couponCount++;
        if (couponCount == couponIds.length) {
          print("--------------couponCountfinish--------------");
          print("--------------刷新优惠券--------------");
        }
      });
    }
  }

  void xtback() {
    XTRouter.closePage(context: context);
  }

  @override
  Widget build(BuildContext context) {
    // print(" ======= " + dataInfo.componentVoList.last.toString());
    return Scaffold(
      bottomNavigationBar: dataInfo.componentVoList == null
          ? null
          : tabbar(dataInfo.componentVoList.last),
      appBar: xtBackBar(
          title: "活动", back: () => XTRouter.closePage(context: context)),
      body: ListView.builder(
          itemCount: 30,
          itemBuilder: (con, index) {
            if (index == 0) {
              // return palyer();
              return bannerUtil();
            } else if (index == 1) {
              return titleNav();
            } else if (index == 2) {
              return bannerUtil();
            } else {
              return bannerUtil();

              // return dataInfo.componentVoList == null
              //     ? Container()
              //     : tabbar(dataInfo.componentVoList.last);
            }
          }),

      // xtText("活动页呀" + widget.params["id"], 20, mainRedColor),
    );
  }

  Widget tabbar(ComponentVoList data) {
    print("tabbar ---------Adddddd");
    return XTTabbar(data);
  }

  XTPlayer palyer() {
    return XTPlayer(
      0,
      0,
      "http://gslb.miaopai.com/stream/-prCt75jIQAtbqtjq0pAF0CQuGTajRxnoFp9Iw__.mp4?vend=miaopai&ssig=2df1cb6fde76adb535f2d0ef92a45cb8&time_stamp=1600400767516&mpflag=32&unique_id=1599787717756561",
    );
  }

  TitleNav titleNav() {
    return TitleNav(
      0,
      0,
      title,
      mainRedColor,
      titleColor: Colors.yellow,
    );
  }

  Widget bannerUtil() {
    print("bannerUtil ---------Adddddd");

    if (this.images.length == 2) {
      return BannerOnlyUtil(images.first, 10, 10);
    } else {
      return BannerUtil(
        300,
        double.parse(imagesPadding.first),
        double.parse(imagesPadding.first),
        images,
        layout: SwiperLayout.DEFAULT,
      );
    }
  }

  // FutureBuilder hello() {
  //   return FutureBuilder(
  //     future: ,
  //     builder: (context, shot) {

  //   });
  // }
}
