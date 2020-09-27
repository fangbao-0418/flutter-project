import 'dart:math';

import 'package:flutter/material.dart';
import 'package:xtflutter/config/app_config/color_config.dart';
import 'package:xtflutter/config/app_config/method_config.dart';
import 'package:xtflutter/pages/normal/app_nav_bar.dart';
import 'package:xtflutter/pages/promotion/coupon_model.dart';
import 'package:xtflutter/router/router.dart';

class CouponPage extends StatefulWidget {
  static String routerName = "coupon";

  @override
  _CouponPageState createState() => _CouponPageState();
}

class _CouponPageState extends State<CouponPage> {

  CouponModel _model = CouponModel.getData();

  List<CouponItemDataModel> couponDataList = CouponModel.getDataLis();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: xtBackBar(
          title: "优惠券", back: () => XTRouter.closePage(context: context)),
      body: Container(
        child: ListView.builder(
          itemCount: _model.dataList.length,
          itemBuilder: (BuildContext ctx, int index) {
            return CouponItemsPage(itemModel: _model.dataList[index], dataList: couponDataList);
          }
        ),
      ),
    );
  }
}

class CouponItemsPage extends StatefulWidget {

  CouponItemsPage({this.itemModel, this.dataList});

  final CouponItemModel itemModel;

  final List<CouponItemDataModel> dataList;

  @override
  _CouponItemsPageState createState() => _CouponItemsPageState();
}

class _CouponItemsPageState extends State<CouponItemsPage> {
  CouponItemModel _itemModel;
  List<CouponItemDataModel> _dataList;

  @override
  void initState() {
    super.initState();
    _itemModel = widget.itemModel;
    _dataList = widget.dataList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _itemModel.config.gridHeight(widget.dataList.length, context),
      color: _itemModel.config.bgColor,
      child: GridView.builder(
        padding: EdgeInsets.only(left: 12, top: 12, right: 12),
        itemCount: widget.dataList.length,
        controller: ScrollController(
          keepScrollOffset: false
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _itemModel.config.styleType,
          crossAxisSpacing: _itemModel.config.crossAxisSpacing,
          mainAxisSpacing: 8,
          childAspectRatio: _itemModel.config.childRatio
        ), 
        itemBuilder: (BuildContext ctx, int index) {
          return CouponItem(itemConfigModel: _itemModel.config, itemDataModel: _dataList[index]);
        }
      )
    );
  }
}


class CouponItem extends StatefulWidget {

  CouponItem({this.itemConfigModel, this.itemDataModel});

  final CouponItemConfigModel itemConfigModel;

  final CouponItemDataModel itemDataModel;

  @override
  _CouponItemState createState() => _CouponItemState();
}

class _CouponItemState extends State<CouponItem> {
  CouponItemConfigModel _itemConfigModel;
  CouponItemDataModel _itemDataModel;

  @override
  void initState() {
    super.initState();
    _itemConfigModel = widget.itemConfigModel;
    _itemDataModel = widget.itemDataModel;
    _itemConfigModel.setStatusType(_itemDataModel.statusType);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Image.asset(_itemConfigModel.getBgImgName),
          Container(
            child: _itemConfigModel.style == CouponItemStyleType.rowOne ? 
            (_itemConfigModel.couponStyle == 1 ? getCouponOneWidget() : getCouponNoneThreeWidget()) : 
            (_itemConfigModel.style == CouponItemStyleType.rowTwo ? getCouponTwoWidget() : getCouponThreeWidget()),
          )
        ],
      ),
    );
  }

  /// 有样式一排一个
  Widget getCouponOneWidget() {
    return Row(
      children: <Widget>[
        Container(
          width: _itemConfigModel.itemWidth(context) * 154 / 351,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  xtText("￥", 28, _itemConfigModel.couponFaceColor, fontWeight: FontWeight.w500),
                  xtText(_itemDataModel.couponFaceValue, 42, _itemConfigModel.couponFaceColor, fontWeight: FontWeight.bold),
                ],
              ),
              xtText(_itemDataModel.couponAllValue, 14, _itemConfigModel.couponFaceColor, fontWeight: FontWeight.w500),
            ],
          ),
        ),
        Expanded(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 25, top: 20, right: 25),
                  child: xtText(_itemDataModel.name, 15, _itemConfigModel.couponFaceColor, maxLines: 2, overflow: TextOverflow.ellipsis)),
                Visibility(
                  visible: _itemConfigModel.statusType == CouponStatusType.normal,
                  child: Positioned(
                    bottom: 18,
                    child: FlatButton(
                      color: Colors.red,
                      onPressed: null, 
                      child: xtText("点击领取", 12, Colors.white)
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  /// 有样式一排二个
  Widget getCouponTwoWidget() {
    
  }

  /// 有样式一排三个
  Widget getCouponThreeWidget() {
    
  }

  /// 无样式一排一个
  Widget getCouponNoneThreeWidget() {
    
  }
}

