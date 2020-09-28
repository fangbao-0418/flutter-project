import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:xtflutter/config/app_config/color_config.dart';
import 'package:xtflutter/config/app_config/method_config.dart';
import 'package:xtflutter/model/coupon_model.dart';
import 'package:xtflutter/model/promotion_model.dart';
import 'package:xtflutter/net_work/http_request.dart';
import 'package:xtflutter/net_work/promotion_request.dart';
import 'package:xtflutter/pages/demo_page/scroller.dart';
import 'package:xtflutter/pages/normal/app_nav_bar.dart';
import 'package:xtflutter/pages/promotion/promotionItem/area.dart';
import 'package:xtflutter/pages/promotion/promotionItem/banner.dart';
import 'package:xtflutter/pages/promotion/promotionItem/coupon_item.dart';
import 'package:xtflutter/pages/promotion/promotionItem/goods.dart';
import 'package:xtflutter/pages/promotion/promotionItem/nav_bar_titles.dart';
import 'package:xtflutter/pages/promotion/promotionItem/player.dart';
import 'package:xtflutter/pages/promotion/promotionItem/title_sepment.dart';
import 'package:xtflutter/pages/promotion/promotionItem/tab_bottom.dart';
import 'package:xtflutter/router/router.dart';
import 'package:xtflutter/utils/appconfig.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:xtflutter/utils/event_bus.dart';

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
  /// Controller to scroll or jump to a particular item.
  final ItemScrollController itemScrollController = ItemScrollController();

  /// Listener that reports the position of items when the list is scrolled.
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  Map<String, List<CouponItemDataModel>> coupons = {};
  List<String> couponIds = [];
  int couponCount = 0;

  PromotionData dataInfo = PromotionData();
  ComponentVoList bodyConfig;
  ComponentVoList tabBottom;
  ComponentVoList tabNav;
  String title = "最新推进啊";

  List<String> auchorNames = [];
  List<int> auchorids = [];

  List<int> itemIndex = [];
  int currentIndex = 0;
  TitlesNavBar navBar;

  int navBarIndex = 0;
  bool flowNavBarShow = false;
  Visibility flowStage;

  @override
  void initState() {
    super.initState();

    promotionInfo();
    itemPositionsListener.itemPositions.addListener(() {
      print("--------addListeneraddListener-----------");

      // bool contain = checkNavTitleBar();
      // var max = itemPositionsListener.itemPositions.value
      //     .where((ItemPosition position) => position.itemLeadingEdge < 1)
      //     .reduce((ItemPosition max, ItemPosition position) =>
      //         position.itemLeadingEdge > max.itemLeadingEdge ? position : max)
      //     .index;
      // print("-------------------" + max.toString());
      // print("-------------------" + currentIndex.toString());

      // itemPositionsListener.itemPositions.value.forEach((element) {
      //   element.index == currentIndex;
      // });

      // if (currentIndex != max) {
      //   currentIndex = max;
      //   print("-----------111111--------" + currentIndex.toString());
      //   if (!contain) {
      //     Future.delayed(Duration(milliseconds: 300), () {
      //       bus.emit(TitlesNavBar.busName, [currentIndex]);
      //       print('延时1s执行');
      //     });
      //   }
      // }
    });
  }

  bool checkNavTitleBar() {
    List arr = List.from(itemPositionsListener.itemPositions.value);

    bool containNav = false;
    ItemPosition positionT;
    for (var i = 0; i < arr.length; i++) {
      // print(arr[i].toString());
      ItemPosition position = arr[i];
      if (position.index == navBarIndex) {
        containNav = true;
        positionT = position;
        break;
      }
    }
    if (containNav == true) {
      if (positionT.itemLeadingEdge <= 0) {
        if (flowNavBarShow != true) {
          flowNavBarShow = true;
          setState(() {});
        }

        print("导航要消失了-------------------------- 展示顶部导航");
      } else {
        if (flowNavBarShow != false) {
          flowNavBarShow = false;
          setState(() {});
        }

        print("导航出来了-------------------------- 隐藏顶部导航");
      }
    } else {
      if (auchorNames.length > 0) {
        if (flowNavBarShow != true) {
          flowNavBarShow = true;
          setState(() {});
        }
        print("导航要已经消失了-------------------------- 继续展示顶部导航");
      }
    }

    return containNav;
  }

  void promotionInfo() {
    PromotionRequest.promotionMgic(widget.params["id"]).then((value) {
      print("--------------------va" + value.toString());
      Map<String, dynamic> map = Map.from(value);
      PromotionData tt = PromotionData.fromJson(map);

      var list = tt.componentVoList;
      List<ComponentVoList> temp = [];

      var memberType = AppConfig.user.memberType != null
          ? AppConfig.user.memberType.toString()
          : "0";

      for (var item in list) {
        if (item.platform.contains("wx-h5") &&
            item.userLevel.contains(memberType)) {
          if (item.type == "body") {
            bodyConfig = item;
          } else if (item.type == "bottomTab") {
            tabBottom = item;
          } else if (item.type == "tab") {
            tabNav = item;
            temp.add(item);
          } else {
            itemIndex.add(item.id);
            temp.add(item);
          }

          if (item.isAuchor) {
            if (item.auchorName != null && item.auchorName.length > 0) {
              auchorNames.add(item.auchorName);
              auchorids.add(item.id);
            }
          }
        }

        if (item.type == "coupon") {
          coupons[item.id.toString()] = [];
          couponIds.add(item.id.toString());
        }
      }
      tt.componentVoList = temp;
      dataInfo = tt;
      getCouponsData();
      print("object1" + dataInfo.componentVoList.length.toString());
      dataInfo = tt;

      setState(() {});
    }).whenComplete(() {
      print("object");
    });
  }

  void getCouponsData() {
    for (var ids in couponIds) {
      PromotionRequest.promotionMgicData(ids, 1).then((value) {
        List<CouponItemDataModel> list = [];
        for (var item in value["list"]) {
          CouponItemDataModel temp =
              CouponItemDataModel.fromJson(Map.from(item));
          list.add(temp);
        }
        coupons[ids] = list;
      }).whenComplete(() {
        couponCount++;
        if (couponCount == couponIds.length) {
          setState(() {});
        }
      });
    }
  }

  void xtback() {
    XTRouter.closePage(context: context);
  }

  void scrollTo(int index) => itemScrollController.scrollTo(
      index: index,
      duration: scrollDuration,
      curve: Curves.easeInOutCubic,
      alignment: 0);

  void jumpTo(int index) {
    currentIndex = index;
    itemScrollController.jumpTo(index: index, alignment: 0);
    // checkNavTitleBar();
  }

  Widget list() {
    return ScrollablePositionedList.builder(
      itemScrollController: itemScrollController,
      itemPositionsListener: itemPositionsListener,
      reverse: false,
      itemCount: dataInfo.componentVoList.length,
      itemBuilder: (context, index) {
        ComponentVoList model = dataInfo.componentVoList[index];
        if (model.type == "tab") {
          navBarIndex = index;
          TitlesNavBar bar = TitlesNavBar(auchorNames, auchorids,
              barbackColor: model.config.bgColor != null
                  ? HexColor(model.config.bgColor)
                  : mainF5GrayColor,
              barTitleNormalColor: model.config.fontColor != null
                  ? HexColor(model.config.fontColor)
                  : mainBlackColor,
              barTitleSelectColor: model.config.fontColorSelect != null
                  ? HexColor(model.config.fontColorSelect)
                  : mainRedColor, onTap: (value) {
            var index = itemIndex.indexOf(value);

            jumpTo(index);
            // scrollTo(index);
            print(" ===value==== ");
            print(value);
            print(" ===value==== ");
          });
          // navBar = bar;
          return bar;
        } else

        // {
        //   return GestureDetector(
        //     child: Container(
        //       child: xtText(index.toString(), 14, main66GrayColor),
        //       width: 100,
        //       height: 50,
        //       color: mainF5GrayColor,
        //     ),
        //   );
        // }

        if (model.type == "title") {
          return titleNav(model);
        } else if (model.type == "banner") {
          return bannerUtil(model);
        } else if (model.type == "goods") {
          return goodsView();
        } else if (model.type == "video") {
          return GestureDetector(
            child: Container(
              width: 100,
              height: 20,
              color: Colors.yellow,
              child: xtText("这是个视频", 12, mainBlackColor),
            ),
          );
          // return palyer(model);
        } else if (model.type == "area") {
          return AreaAttach(model);
        } else if (model.type == "coupon") {
          return Container(
            height: model.couponConfig
                .gridHeight(coupons[model.id.toString()].length, context),
            color: Colors.yellow,
            child: CouponItems(
                itemConfigModel: model.couponConfig,
                dataList: coupons[model.id.toString()]),
          );
        } else {
          return GestureDetector(
            child: Container(
              width: 100,
              height: 20,
              color: Colors.yellow,
            ),
          );
        }
      },
    );
  }

  Widget showWidgetFilter() {
    if (dataInfo.componentVoList == null) {
      return Container(
        width: 100,
        height: 1,
        color: mainF5GrayColor,
      );
    } else {
      if (auchorids.length > 0) {
        Visibility offstage = Visibility(
          maintainSize: false,
          maintainState: true, // 隐藏后是否维持组件状态
          maintainAnimation: true, // 隐藏后是否维持子组件中的动画
          visible: flowNavBarShow,
          child: TitlesNavBar(auchorNames, auchorids,
              barbackColor: tabNav.config.bgColor != null
                  ? HexColor(tabNav.config.bgColor)
                  : mainF5GrayColor,
              barTitleNormalColor: tabNav.config.fontColor != null
                  ? HexColor(tabNav.config.fontColor)
                  : mainBlackColor,
              barTitleSelectColor: tabNav.config.fontColorSelect != null
                  ? HexColor(tabNav.config.fontColorSelect)
                  : mainRedColor, onTap: (value) {
            var index = itemIndex.indexOf(value);

            jumpTo(index);
            // scrollTo(index);
            print(" ===nav flow value==== ");
            print(value);
            print(" ===nav flow value==== ");
          }),
        );
        flowStage = offstage;
        return Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[list(), Positioned(child: offstage)]);
      } else {
        return list();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(" ======= " + dataInfo.componentVoList.last.toString());
    return Scaffold(
      bottomNavigationBar: tabBottom == null ? null : tabbar(tabBottom),
      appBar: xtBackBar(
          title: "活动", back: () => XTRouter.closePage(context: context)),
      body: Container(
          color: bodyConfig == null
              ? whiteColor
              : HexColor(bodyConfig.config.bgColor),
          child: showWidgetFilter()
          //showWidgetFilter() //list(),// ScrollablePositionedListPage()
          ),

      // xtText("活动页呀" + widget.params["id"], 20, mainRedColor),
    );
  }

  Widget tabbar(ComponentVoList data) {
    print("tabbar ---------Adddddd");
    return XTTabbar(data);
  }

  XTPlayer palyer(ComponentVoList model) {
    var top = 0.0;
    var bottom = 0.0;
    var videoUrl = "";

    if (model.config.padding != null && model.config.padding.length == 2) {
      top = double.parse(model.config.padding.first);
      bottom = double.parse(model.config.padding.last);
      videoUrl = model.config.videoUrl;
    }
    return XTPlayer(
      top,
      bottom,
      videoUrl,
    );
  }

  TitleNav titleNav(ComponentVoList model) {
    var top = 0.0;
    var bottom = 0.0;
    var titleStr = "";

    if (model.config.padding != null && model.config.padding.length == 2) {
      top = double.parse(model.config.padding.first);
      bottom = double.parse(model.config.padding.last);
      titleStr = model.config.title;
    }
    return TitleNav(
      top,
      bottom,
      titleStr,
      HexColor("4DFFFFFF"),
      titleColor: whiteColor,
    );
  }

  Widget goodsView() {
    return Container(
        color: Colors.lightGreenAccent, height: 500, child: Goods(9, 10, 10));
  }

  Widget bannerUtil(ComponentVoList model) {
    if (model.data.length == 1) {
      return BannerOnlyUtil(model);
    } else {
      return BannerUtil(300, model);
    }
  }
}
// Widget oldList() {
//   return ListView.builder(
//       itemCount: dataInfo.componentVoList == null
//           ? 0
//           : dataInfo.componentVoList.length,
//       itemBuilder: (con, index) {
//         ComponentVoList model = dataInfo.componentVoList[index];
//         if (model.type == "tab") {
//           return TitlesNavBar(auchorNames, auchorids,
//               barbackColor: model.config.bgColor != null
//                   ? HexColor(model.config.bgColor)
//                   : mainF5GrayColor,
//               barTitleNormalColor: model.config.fontColor != null
//                   ? HexColor(model.config.fontColor)
//                   : mainBlackColor,
//               barTitleSelectColor: model.config.fontColorSelect != null
//                   ? HexColor(model.config.fontColorSelect)
//                   : mainRedColor, onTap: (value) {
//             print(" ===value==== ");
//             print(value);
//             print(" ===value==== ");
//           });
//         } else if (model.type == "title") {
//           return titleNav(model);
//         } else if (model.type == "banner") {
//           return bannerUtil(model);
//         } else if (model.type == "goods") {
//           return goodsView();
//         } else if (model.type == "video") {
//           return GestureDetector(
//             child: Container(
//               width: 100,
//               height: 20,
//               color: Colors.yellow,
//               child: xtText("这是个视频", 12, mainBlackColor),
//             ),
//           );
//           // return palyer(model);
//         } else if (model.type == "area") {
//           return AreaAttach(model);
//         } else {
//           return GestureDetector(
//             child: Container(
//               width: 100,
//               height: 20,
//               color: Colors.yellow,
//             ),
//           );
//         }
//       });
// }
