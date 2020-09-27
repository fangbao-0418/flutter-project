import 'package:flutter/material.dart';
import 'package:xtflutter/config/app_config/method_config.dart';
import 'package:xtflutter/pages/normal/app_nav_bar.dart';
import 'package:xtflutter/pages/normal/toast.dart';
import 'package:xtflutter/pages/promotion/coupon_model.dart';
import 'package:xtflutter/router/router.dart';

/// 优惠券组件
class CouponItems extends StatefulWidget {
  /// 构造方法
  CouponItems({this.itemConfigModel, this.dataList});
  /// 优惠券样式
  final CouponItemConfigModel itemConfigModel;
  /// 优惠券数据列表
  final List<CouponItemDataModel> dataList;

  @override
  _CouponItemsState createState() => _CouponItemsState();
}

class _CouponItemsState extends State<CouponItems> {
  CouponItemConfigModel _itemConfigModel;
  List<CouponItemDataModel> _dataList;

  @override
  void initState() {
    super.initState();
    _itemConfigModel = widget.itemConfigModel;
    _dataList = widget.dataList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _itemConfigModel.gridHeight(widget.dataList.length, context),
      color: _itemConfigModel.bgColor,
      child: GridView.builder(
        padding: EdgeInsets.only(left: 12, top: 12, right: 12),
        itemCount: widget.dataList.length,
        controller: ScrollController(
          keepScrollOffset: false
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _itemConfigModel.styleType,
          crossAxisSpacing: _itemConfigModel.crossAxisSpacing,
          mainAxisSpacing: 8,
          childAspectRatio: _itemConfigModel.childRatio
        ), 
        itemBuilder: (BuildContext ctx, int index) {
          return CouponItem(itemConfigModel: _itemConfigModel, itemDataModel: _dataList[index]);
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

  /// 优惠券立即领取
  void _couponGetNow() {
    if (_itemDataModel.statusType == CouponStatusType.normal) {
      Toast.showToast(msg: "立即领取");
    }
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
                  child: xtText(_itemDataModel.name, 15, _itemConfigModel.couponNameColor, maxLines: 2, overflow: TextOverflow.ellipsis)),
                Visibility(
                  visible: _itemConfigModel.statusType == CouponStatusType.normal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                        onTap: _couponGetNow,
                        child: Container(
                          height: 22,
                          width: 60,
                          margin: EdgeInsets.only(right: 25, top: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _itemConfigModel.couponGetNowColors.first,
                            borderRadius: BorderRadius.all(Radius.circular(11))
                          ),
                          child: xtText("点击领取", 12, _itemConfigModel.couponGetNowColors.last, fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  /// 有样式一排二个
  Widget getCouponTwoWidget() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    xtText("￥", 16, _itemConfigModel.couponFaceColor, fontWeight: FontWeight.w500),
                    xtText(_itemDataModel.couponFaceValue, 30, _itemConfigModel.couponFaceColor, fontWeight: FontWeight.w500),
                  ],
                ),
                xtText(_itemDataModel.couponAllValue, 12, _itemConfigModel.couponFaceDescColor),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: _couponGetNow,
          child: Container(
            color: Colors.transparent,
            alignment: Alignment.center,
            width: _itemConfigModel.itemWidth(context) * 60 / 174,
            child: xtText(_itemConfigModel.rowTGetText, 14, _itemConfigModel.rowTGetTextColor),
          ),
        )
      ],
    );
  }

  /// 有样式一排三个
  Widget getCouponThreeWidget() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    xtText("￥", 16, _itemConfigModel.couponFaceColor, fontWeight: FontWeight.w500),
                    xtText(_itemDataModel.couponFaceValue, 30, _itemConfigModel.couponFaceColor, fontWeight: FontWeight.w500),
                  ],
                ),
                xtText(_itemDataModel.couponAllValue, 12, _itemConfigModel.couponFaceDescColor),
              ],
            ),
          )
        ),
        GestureDetector(
          onTap: _couponGetNow,
          child: Container(
            color: Colors.transparent,
            alignment: Alignment.center,
            height: (_itemConfigModel.itemWidth(context) / _itemConfigModel.childRatio) * 30 / 96,
            child: xtText(_itemConfigModel.rowTGetText, 14, _itemConfigModel.rowTGetTextColor),
          ),
        )
      ],
    );
  }

  /// 无样式一排一个
  Widget getCouponNoneThreeWidget() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    xtText("￥", 24, _itemConfigModel.couponFaceColor, fontWeight: FontWeight.w500),
                    xtText(_itemDataModel.couponFaceValue, 40, _itemConfigModel.couponFaceColor, fontWeight: FontWeight.w500),
                  ],
                ),
                xtText(_itemDataModel.couponAllValue, 12, _itemConfigModel.couponFaceDescColor),
                xtText(_itemDataModel.name, 14, _itemConfigModel.couponFaceDescColor, maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          )
        ),
        GestureDetector(
          onTap: _couponGetNow,
          child: Container(
            width: _itemConfigModel.itemWidth(context) * 94 / 351,
            color: Colors.transparent,
            alignment: Alignment.center,
            child: xtText(_itemConfigModel.rowTGetText, 22, _itemConfigModel.rowTGetTextColor),
          ),
        )
      ],
    );
  }
}




/// ----------------------------------------- 优惠券组件测试页面 -----------------------------------------
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
            return CouponItems(itemConfigModel: _model.dataList[index].config, dataList: couponDataList);
          }
        ),
      ),
    );
  }
}