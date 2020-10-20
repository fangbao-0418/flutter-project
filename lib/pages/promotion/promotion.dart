import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:xtflutter/config/app_config/color_config.dart';
import 'package:xtflutter/config/app_config/method_config.dart';
import 'package:xtflutter/model/coupon_model.dart';
import 'package:xtflutter/model/goods_model.dart';
import 'package:xtflutter/model/promotion_model.dart';
import 'package:xtflutter/net_work/http_request.dart';
import 'package:xtflutter/net_work/promotion_request.dart';
import 'package:xtflutter/pages/demo_page/scroller.dart';
import 'package:xtflutter/pages/normal/app_nav_bar.dart';
import 'package:xtflutter/pages/promotion/promotionItem/area.dart';
import 'package:xtflutter/pages/promotion/promotionItem/banner.dart';
import 'package:xtflutter/pages/promotion/promotionItem/coupon_item.dart';
import 'package:xtflutter/pages/promotion/promotionItem/flow_bar_titles.dart';
import 'package:xtflutter/pages/promotion/promotionItem/goods.dart';
import 'package:xtflutter/pages/promotion/promotionItem/nav_bar_titles.dart';
import 'package:xtflutter/pages/promotion/promotionItem/player.dart';
import 'package:xtflutter/pages/promotion/promotionItem/time.dart';
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

  ///优惠券信息 id -> 优惠券列表数据
  Map<String, List<CouponItemDataModel>> coupons = {};

  ///商品信息 id -> 商品数据
  Map<String, List<GoodsItemDataModel>> goods = {};

  ///每个商品ID 对应的商品个数
  Map<String, int> goodsCountDict = {};

  ///每个商品ID 对应商品的页码
  Map<String, int> goodsPage = {};

  ///每个商品ID 对应商品的页码
  Map<String, bool> goodsIDLoading = {};

  ///每个商品ID 对应商品的页码
  Map<String, bool> goodsIDGetAll = {};

  ///优惠券ID
  List<String> couponIds = [];

  ///商品ID
  List<String> goodsIds = [];

  int couponCount = 0;

  PromotionData dataInfo = PromotionData();
  ComponentVoList bodyConfig;
  ComponentVoList tabBottom;
  ComponentVoList tabNav;
  String title = "最新推进啊";
  String endTime = "";

  List<String> auchorNames = [];
  List<int> auchorids = [];

  ///当前模块位置对应的导航位置
  Map<int, int> realToNav = {};

  ///当前的导航位置对应模块位置
  Map<int, int> navToReal = {};

  List<int> itemIndex = [];
  TitlesNavBar navBar;

  ///导航选中位置
  int barSelectIndex = 0;

  ///导航选中位置
  int barSelectRealIndex = 0;

  ///导航条所在position位置
  int barPositionIndex = 0;
  bool flowNavBarShow = false;
  bool jumpIng = false;
  bool initIng = true;

  @override
  void initState() {
    super.initState();

    promotionInfo();
    itemPositionsListener.itemPositions.addListener(() {
      //导航悬浮
      checkNavTitleBar();
      //滚动检测
      scrollListener();
    });
  }

  void promotionInfo() {
    PromotionRequest.promotionMgic(widget.params["id"]).then((value) {
      Map<String, dynamic> map = Map.from(value);
      PromotionData tt = PromotionData.fromJson(map);
      endTime = tt.endTime;
      var list = tt.componentVoList;
      List<ComponentVoList> temp = [];

      var memberType = AppConfig.user.memberType != null
          ? AppConfig.user.memberType.toString()
          : "0";
      for (var item in list) {
        //是H5并且符合用户身份
        if (item.platform.contains("wx-h5") &&
            item.userLevel.contains(memberType)) {
          //整体页面配置
          if (item.type == "body") {
            bodyConfig = item;
            //底部导航配置
          } else if (item.type == "bottomTab") {
            tabBottom = item;
            //吸顶 顶部导航栏
          } else if (item.type == "tab") {
            tabNav = item;
            temp.add(item);
          } else if (item.type == "goods") {
            goodsIds.add(item.id.toString());
            goods[item.id.toString()] = [];
            goodsCountDict[item.id.toString()] = item.dataTotal;
            itemIndex.add(item.id);
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
        //优惠券
        if (item.type == "coupon") {
          coupons[item.id.toString()] = [];
          couponIds.add(item.id.toString());
        }
      }

      /// 记录导航的对应的实际位置
      for (var i = 0; i < temp.length; i++) {
        ComponentVoList tm = temp[i];
        if (tm.isAuchor && tm.auchorName != null && tm.auchorName.length > 0) {
          ///导航所在的整体内容的位置
          int index = i;

          ///当前模块在导航的位置
          int navIndex = auchorids.indexOf(tm.id);

          ///记录下来当前模块对应导航的位置，在整体滚动的时候可以当前模块的位置对应到导航位置，进而做出相应的滚动
          realToNav[index] = navIndex;

          navToReal[navIndex] = index;
        }
      }
      print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
      print(realToNav);
      print(navToReal);
      print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");

      tt.componentVoList = temp;
      dataInfo = tt;
      getCouponsData();
      if (goodsIds.length > 0) {
        var ids = goodsIds.first;
        getIDGoodsData(ids);
      }

      print("object1" + dataInfo.componentVoList.length.toString());
      dataInfo = tt;

      setState(() {
        initIng = false;
      });
    }).whenComplete(() {
      print("object");
    });
  }

  void getIDGoodsData(String ids) {
    print("getIDGoodsData ---" + ids + "-" + goodsCountDict[ids].toString());

    ///当前ID 总个数
    int totalCount = goodsCountDict[ids];
    List<GoodsItemDataModel> clist = goods[ids];
    if (goodsIDGetAll[ids] == true) {
      print("product LoadFinsish --- " + ids);
      //已经加载全部商品
      return;
    }

    bool isLoading = goodsIDLoading[ids];
    if (isLoading == true) {
      return;
    }
    int page = goodsPage[ids];
    print("page");
    print(page);
    print("page");
    if (page == null) {
      goods[ids] = [];
      page = 1;
    } else {
      page += 1;
    }

    goodsIDLoading[ids] = true;
    goodsPage[ids] = page;
    PromotionRequest.promotionMgicData(ids, page,
            pageSize: totalCount <= 20 ? totalCount : 10, source: "0")
        .then((value) {
      print("value---" + value.toString());
      List<GoodsItemDataModel> list = [];
      for (var item in value["list"]) {
        GoodsItemDataModel temp = GoodsItemDataModel.fromJson(Map.from(item));
        list.add(temp);
      }
      if (list.length == 0) {
        goodsIDGetAll[ids] = true;
      }
      if (totalCount <= 20 && list.length > 0) {
        goodsIDGetAll[ids] = true;
      }
      clist.addAll(list);
      print("goods----" + ids + " ------ " + clist.length.toString());
      goods[ids] = clist;
    }).whenComplete(() {
      goodsIDLoading[ids] = false;
      if (!goodsIDLoading.values.contains(true)) {
        setState(() {});
      }
    });
  }

  void getCouponsData() {
    if (couponIds.length == 0) {
      return;
    }
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
    barSelectIndex = index;
    jumpIng = true;
    Future.delayed(Duration(milliseconds: 500), () {
      itemScrollController.jumpTo(index: index, alignment: 0.04);
      Future.delayed(Duration(milliseconds: 500), () {
        jumpIng = false;
      });
    });
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
          barPositionIndex = index;
          TitlesNavBar bar = TitlesNavBar(auchorNames, auchorids, "item",
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
          });
          // navBar = bar;
          return bar;
        } else if (model.type == "title") {
          return titleNav(model);
        } else if (model.type == "banner") {
          return bannerUtil(model);
        } else if (model.type == "goods") {
          // print("--goods-- " + model.id.toString() + "-" + index.toString());
          List<GoodsItemDataModel> list = goods[model.id.toString()];
          return goodsView(list);
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
        } else if (model.type == "time") {
          return PromotionTime(
            endTime,
            Color.fromRGBO(255, 255, 255, 0.3),
            styleType: model.config.styleType,
          );
        } else {
          return GestureDetector(
            child: Container(
              width: 100,
              height: 50,
              color: Colors.brown,
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
        return Stack(alignment: Alignment.topCenter, children: <Widget>[
          list(),
          Positioned(
              child: FlowBarTitles(
            auchorNames,
            auchorids,
            tabNav.config,
            onTap: (value) {
              var index = itemIndex.indexOf(value);

              jumpTo(index);
              // scrollTo(index);
              print(" ===value==== ");
              print(value);
              print(" ===value==== ");
            },
          ))
        ]);
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

  Widget goodsView(List<GoodsItemDataModel> goods) {
    return Container(
        color: Colors.lightGreenAccent,
        height: 500,
        child: Goods(9, 10, goods));
  }

  Widget bannerUtil(ComponentVoList model) {
    if (model.data.length == 1) {
      return BannerOnlyUtil(model);
    } else {
      return BannerUtil(300, model);
    }
  }

  ///滚动检测
  void scrollListener() {
    ///滚动检测
    //跳转时候防止再次调用滚动代理
    if (jumpIng) {
      return;
    }
    if (!initIng) {}
    List li = List.from(itemPositionsListener.itemPositions.value);

    ///当前显示模块列表
    List<int> showItems = [];

    for (var i = 0; i < li.length; i++) {
      ItemPosition posi = li[i];
      showItems.add(posi.index);

      ///加载商品模块数据
      // for (var i = showItems.length; i >= 0; i--) {
      ComponentVoList model = dataInfo.componentVoList[posi.index];
      // print(model.type);
      String goodId = model.id.toString();
      // // print("loading - goods" + " ------ " + goodId);

      if (goodsIds.contains(goodId)) {
        // print("loading - goods" + " ------ " + goodId);

        // print("loading " + " ------ " + goodsIds.toString());

        getIDGoodsData(goodId);
      }
    }
    // print("-------------------------------------------------------");
    // print(li.toString());
    // print(showItems.toString());
    // print("-------------------------------------------------------");

    //排序
    showItems.sort((a, b) => b.compareTo(a));

    //获取当前选中的导航所在的模块位置
    int itemIndex = navToReal[barSelectIndex];
    if (showItems.contains(itemIndex)) {
      return;
    } else {
      for (var i = 0; i < showItems.length; i++) {
        int posi = showItems[i];
        if (realToNav.containsKey(posi)) {
          int scrollIndex = realToNav[posi];
          bus.emit(TitlesNavBar.busName, [scrollIndex]);
          return;
        }
      }
    }
  }

  ///控制悬浮是否展示
  void checkNavTitleBar() {
    ///控制悬浮是否展示

    List arr = List.from(itemPositionsListener.itemPositions.value);
    bool containNav = false;
    ItemPosition positionT;
    for (var i = 0; i < arr.length; i++) {
      ItemPosition position = arr[i];
      if (position.index == barPositionIndex) {
        containNav = true;
        positionT = position;
        break;
      }
    }
    if (containNav == true) {
      if (positionT.itemLeadingEdge <= 0) {
        if (flowNavBarShow != true) {
          print("导航要消失了-------------------------- 展示顶部导航");
          flowNavBarShow = true;
          bus.emit(FlowBarTitles.busName, [flowNavBarShow]);
        }
      } else {
        if (flowNavBarShow != false) {
          print("导航出来了-------------------------- 隐藏顶部导航");
          flowNavBarShow = false;
          bus.emit(FlowBarTitles.busName, [flowNavBarShow]);
        }
      }
    } else {
      if (auchorNames.length > 0) {
        if (flowNavBarShow != true) {
          print("导航要已经消失了-------------------------- 继续展示顶部导航");
          flowNavBarShow = true;
          bus.emit(FlowBarTitles.busName, [flowNavBarShow]);
        }
      }
    }
  }
}
