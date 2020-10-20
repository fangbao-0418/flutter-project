import 'package:flutter/material.dart';
import 'package:xtflutter/config/app_config/color_config.dart';
import 'package:xtflutter/config/app_config/method_config.dart';
import 'package:xtflutter/model/goods_model.dart';
import 'package:xtflutter/pages/normal/app_nav_bar.dart';
import 'package:xtflutter/router/router.dart';
import '../../../r.dart';

/// 商品组件
class GoodsItems extends StatefulWidget {
  GoodsItems({this.configModel, this.dataList});
  /// 样式模型
  final GoodsItemConfigModel configModel;
  /// 数据列表
  final List<GoodsItemDataModel> dataList;

  @override
  _GoodsItemsState createState() => _GoodsItemsState();
}

class _GoodsItemsState extends State<GoodsItems> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.configModel.gridHeight(widget.dataList.length, context),
      child: GridView.builder(
        padding: EdgeInsets.only(left: 12, top: 8, right: 12),
        itemCount: widget.dataList.length,
        controller: ScrollController(
          keepScrollOffset: false
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.configModel.styleType,
          crossAxisSpacing: widget.configModel.crossAxisSpacing,
          mainAxisSpacing: widget.configModel.style == GoodsItemRowStyleType.rowThree ? 3 : 8,
          childAspectRatio: widget.configModel.childRatio
        ), 
        itemBuilder: (BuildContext ctx, int index) {
          return GoodsItem(configModel: widget.configModel, dataModel: widget.dataList[index]);
        }
      )
    );
  }
} 

class GoodsItem extends StatefulWidget {

  GoodsItem({this.configModel, this.dataModel});

  final GoodsItemConfigModel configModel;
  final GoodsItemDataModel dataModel;

  @override
  _GoodsItemState createState() => _GoodsItemState();
}

class _GoodsItemState extends State<GoodsItem> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(widget.configModel.style == GoodsItemRowStyleType.rowThree ? 4 : 6)),
      child: GestureDetector(
        onTap: () {
          _gotoDetail();
        },
        child: Container(
          color: Colors.white,
          child: _getWidget(),
        ),
      ),
    );
  }

  /// 前往详情页面
  void _gotoDetail() {
    XTRouter.pushToPage(
      routerName: "goods-detail?id=${widget.dataModel.productId}", 
      context: context, 
      isNativePage: true
    );
  }

  Widget _getWidget() {
    if (widget.configModel.style == GoodsItemRowStyleType.rowOne && widget.configModel.goodsType == GoodsItemStyleType.styleOne) {
      return _getGoodsTypeOneAndRowOneWidget();
    } else if (widget.configModel.style == GoodsItemRowStyleType.rowTwo && widget.configModel.goodsType == GoodsItemStyleType.styleOne) {
      return _getGoodsTypeOneAndRowTwoWidget();
    } else if (widget.configModel.style == GoodsItemRowStyleType.rowThree && widget.configModel.goodsType == GoodsItemStyleType.styleOne) {
      return _getGoodsTypeOneAndRowThreeWidget();
    } else if (widget.configModel.style == GoodsItemRowStyleType.rowOne && widget.configModel.goodsType == GoodsItemStyleType.styleTwo) {
      return _getGoodsTypeTwoAndRowOneWidget();
    } else if (widget.configModel.style == GoodsItemRowStyleType.rowTwo && widget.configModel.goodsType == GoodsItemStyleType.styleTwo) {
      return _getGoodsTypeTwoAndRowTwoWidget();
    } else if (widget.configModel.style == GoodsItemRowStyleType.rowThree && widget.configModel.goodsType == GoodsItemStyleType.styleTwo) {
      return _getGoodsTypeTwoAndRowThreeWidget();
    } else if (widget.configModel.style == GoodsItemRowStyleType.rowOne && widget.configModel.goodsType == GoodsItemStyleType.styleThree) {
      return _getGoodsTypeThreeAndRowOneWidget();
    } else if (widget.configModel.style == GoodsItemRowStyleType.rowTwo && widget.configModel.goodsType == GoodsItemStyleType.styleThree) {
      return _getGoodsTypeThreeAndRowTwoWidget();
    } else if (widget.configModel.style == GoodsItemRowStyleType.rowThree && widget.configModel.goodsType == GoodsItemStyleType.styleThree) {
      return _getGoodsTypeThreeAndRowThreeWidget();
    }

    return Container(color: Colors.red);
  }

  /// 获取标签tag
  List<Widget> _productTags(GoodsItemDataModel model) {
    return List<Widget>.from(model.productTagImgNameList.map((e) => Image(image: AssetImage(e), height: 16)));
  }

  /// 获取图标及角标
  List<Widget> _getProductImgAndSubTag(GoodsItemDataModel model, double imgWH, {double tagW = 50, double tagH = 30, bool isShowWrap = false, double wrapPadding = 0}) {
    List<Widget> widgetList = [
      xtRoundAvatarImage(imgWH, 0, model.coverImage),
      /// 4个角落上的标签
      Visibility(
        visible: model.tagType == TagPositionType.leftTop,
        child: Positioned(left: 0, top: 0,
          child: Image(image: NetworkImage(model.tagUrl), width: tagW, height: tagH)
        )
      ),
      Visibility(
        visible: model.tagType == TagPositionType.leftBottom,
        child: Positioned(left: 0, bottom: 0,
          child: Image(image: NetworkImage(model.tagUrl), width: tagW, height: tagH)
        )
      ),
      Visibility(
        visible: model.tagType == TagPositionType.rightTop,
        child: Positioned(right: 0, top: 0,
          child: Image(image: NetworkImage(model.tagUrl), width: tagW, height: tagH)
        )
      ),
      Visibility(
        visible: model.tagType == TagPositionType.rightBottom,
        child: Positioned(right: 0, bottom: 0,
          child: Image(image: NetworkImage(model.tagUrl), width: tagW, height: tagH)
        )
      ),
    ];

    if (isShowWrap) {
      widgetList.add(
        Positioned(
          left: 6,
          right: 6,
          bottom: 0,
          child: Wrap(
            spacing: 2,
            runSpacing: 2,
            verticalDirection: VerticalDirection.up,
            children: _productTags(model), 
          )
        )
      );
    }

    widgetList.add(
      Visibility(
        visible: model.isSellOut,
        child: Container(
          alignment: Alignment.center,
          height: imgWH,
          width: imgWH,
          color: Color(0x7D000000),
          child: Image(
            width: 68,
            height: 68,
            fit: BoxFit.fitWidth,
            image: AssetImage(R.imagesProductSellOutSmall),
          ),
        )
      ),
    );

    return widgetList;
  }

  /// 商品样式1 && 排列样式1
  Widget _getGoodsTypeOneAndRowOneWidget() {
    GoodsItemDataModel _model = widget.dataModel;
    GoodsItemConfigModel _config = widget.configModel;
    return Row(
      children: <Widget>[
        Stack(
          children: _getProductImgAndSubTag(_model, _config.itemHeight(context)),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      child: xtText(_model.productName, 16, mainBlackColor, fontWeight: FontWeight.w500, maxLines: _model.productTagImgNameList.isEmpty ? 2 : 1, overflow: TextOverflow.ellipsis, alignment: TextAlign.left)),
                    Visibility(
                      visible: _model.productDescription != null && _model.productDescription.isNotEmpty,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: xtText(_model.productDescription, 12, main99GrayColor, maxLines: 1, overflow: TextOverflow.ellipsis, alignment: TextAlign.left)),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        spacing: 2,
                        runSpacing: 2,
                        children: _productTags(_model),
                      ),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: _model.mostEarnText.isNotEmpty ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
                      children: <Widget>[
                        Visibility(
                          visible: _model.mostEarnText.isNotEmpty,
                          child: Container(
                            padding: EdgeInsets.only(left: 2, right: 2),
                            alignment: Alignment.centerLeft,
                            child: xtText(_model.mostEarnText, 10, xtColor_FF6600, alignment: TextAlign.center),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(3)),
                              border: Border.all(
                                color: xtColor_FF6600,
                                width: 0.5
                              )
                            ),
                          ),
                        ),
                        xtText(_model.productSaleCountText, 12, mainBlackColor)
                      ],
                    ),
                    SizedBox(height: 8),
                    Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Image(
                          width: double.infinity,
                          fit: BoxFit.cover,
                          image: AssetImage(R.imagesGoodsItemGrab)
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(width: 6),
                            xtText(_model.buyingPriceText, 16, mainRedColor),
                            SizedBox(width: 2),
                            Text(
                              _model.marketPriceText,
                              style: TextStyle(
                                fontSize: 12,
                                color: main99GrayColor,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: main99GrayColor
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  /// 商品样式1 && 排列样式2
  Widget _getGoodsTypeOneAndRowTwoWidget() {
    GoodsItemDataModel _model = widget.dataModel;
    GoodsItemConfigModel _config = widget.configModel;
    return Column(
      children: <Widget>[
        Stack(
          children: _getProductImgAndSubTag(_model, _config.itemWidth(context), isShowWrap: true, wrapPadding: 6),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: xtText(_model.productName, 14, mainBlackColor, fontWeight: FontWeight.w500, maxLines: 1, overflow: TextOverflow.ellipsis, alignment: TextAlign.left)),
                Row(
                  mainAxisAlignment: _model.mostEarnText.isNotEmpty ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
                  children: <Widget>[
                    Visibility(
                      visible: _model.mostEarnText.isNotEmpty,
                      child: Container(
                        padding: EdgeInsets.only(left: 2, right: 2),
                        alignment: Alignment.centerLeft,
                        child: xtText(_model.mostEarnText, 10, xtColor_FF6600, alignment: TextAlign.center),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                          border: Border.all(
                            color: xtColor_FF6600,
                            width: 0.5
                          )
                        ),
                      ),
                    ),
                    xtText(_model.productSaleCountText, 12, mainBlackColor)
                  ],
                ),
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Image(
                      width: double.infinity,
                      fit: BoxFit.cover,
                      image: AssetImage(R.imagesGoodsItemGrab)
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(width: 6),
                        xtText(_model.buyingPriceText, 16, mainRedColor),
                        SizedBox(width: 2),
                        Text(
                          _model.marketPriceText,
                          style: TextStyle(
                            fontSize: 12,
                            color: main99GrayColor,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: main99GrayColor
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          )
        )
      ],
    );
  }

  /// 商品样式1 && 排列样式3
  Widget _getGoodsTypeOneAndRowThreeWidget({bool isShowWrap = true}) {
    GoodsItemDataModel _model = widget.dataModel;
    GoodsItemConfigModel _config = widget.configModel;
    return Column(
      children: <Widget>[
        Stack(
          children: _getProductImgAndSubTag(_model, _config.itemWidth(context), isShowWrap: isShowWrap, wrapPadding: 4),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.fromLTRB(4, 4, 4, 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: xtText(_model.productName, 12, mainBlackColor, fontWeight: FontWeight.w500, maxLines: 1, overflow: TextOverflow.ellipsis, alignment: TextAlign.left)),
                Row(
                  children: <Widget>[
                    Visibility(
                      visible: _model.mostEarnText.isNotEmpty,
                      child: Container(
                        padding: EdgeInsets.only(left: 2, right: 2),
                        alignment: Alignment.centerLeft,
                        child: xtText(_model.mostEarnText, 10, xtColor_FF6600, alignment: TextAlign.center),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                          border: Border.all(
                            color: xtColor_FF6600,
                            width: 0.5
                          )
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    xtText(_model.buyingPriceText, 16, mainRedColor),
                    SizedBox(width: 2),
                    Text(
                      _model.marketPriceText,
                      style: TextStyle(
                        fontSize: 12,
                        color: main99GrayColor,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: main99GrayColor
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        )
      ],
    );
  }

  /// 商品样式2 && 排列样式1
  Widget _getGoodsTypeTwoAndRowOneWidget() {
    GoodsItemDataModel _model = widget.dataModel;
    GoodsItemConfigModel _config = widget.configModel;
    return Row(
      children: <Widget>[
        Stack(
          children: _getProductImgAndSubTag(_model, _config.itemHeight(context)),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 0.5, width: double.infinity),
                    xtText(_model.productName, 16, mainBlackColor, fontWeight: FontWeight.w500, maxLines: 1, overflow: TextOverflow.ellipsis, alignment: TextAlign.left),
                    Visibility(
                      visible: _model.productDescription != null && _model.productDescription.isNotEmpty,
                      child: xtText(_model.productDescription, 12, main99GrayColor, maxLines: 1, overflow: TextOverflow.ellipsis, alignment: TextAlign.left),
                    ),
                    Visibility(
                      visible: _model.mostEarnText.isNotEmpty,
                      child: Container(
                        margin: EdgeInsets.only(top: 5),
                        padding: EdgeInsets.only(left: 2, right: 2),
                        child: xtText(_model.mostEarnText, 10, xtColor_FF6600, alignment: TextAlign.center),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                          border: Border.all(
                            color: xtColor_FF6600,
                            width: 0.5
                          )
                        ),
                      ),
                    ),
                    Container(child: xtText(_model.productSaleCountText, 12, mainBlackColor), margin: EdgeInsets.only(top: 5))
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _model.marketPriceText,
                      style: TextStyle(
                        fontSize: 14,
                        color: main99GrayColor,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: main99GrayColor
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        xtText(_model.buyingPriceText, 20, mainRedColor),
                        Container(
                          height: 28,
                          width: 72,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [xtColor_FFFF7700, mainRedColor],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(14))
                          ),
                          child: xtText("立即抢", 14, Colors.white, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        )
      ],
    );
  }

  /// 商品样式2 && 排列样式2
  Widget _getGoodsTypeTwoAndRowTwoWidget() {
    GoodsItemDataModel _model = widget.dataModel;
    GoodsItemConfigModel _config = widget.configModel;
    return Column(
      children: <Widget>[
        Stack(
          children: _getProductImgAndSubTag(_model, _config.itemWidth(context)),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.fromLTRB(9, 6, 9, 11),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                xtText(_model.productName, 14, mainBlackColor, fontWeight: FontWeight.w500, maxLines: 1, overflow: TextOverflow.ellipsis, alignment: TextAlign.left),
                Visibility(
                  visible: _model.mostEarnText.isNotEmpty,
                  child: Container(
                    margin: EdgeInsets.only(top: 5),
                    padding: EdgeInsets.only(left: 2, right: 2),
                    child: xtText(_model.mostEarnText, 10, xtColor_FF6600, alignment: TextAlign.center),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                      border: Border.all(
                        color: xtColor_FF6600,
                        width: 0.5
                      )
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 0.5, width: double.infinity),
                    Container(child: xtText(_model.productSaleCountText, 12, mainBlackColor), margin: EdgeInsets.only(bottom: 8)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        xtText(_model.buyingPriceText, 16, mainRedColor),
                        SizedBox(width: 2),
                        Text(
                          _model.marketPriceText,
                          style: TextStyle(
                            fontSize: 12,
                            color: main99GrayColor,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: main99GrayColor
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          )
        )
      ],
    );
  }

  /// 商品样式2 && 排列样式3
  Widget _getGoodsTypeTwoAndRowThreeWidget() {
    return _getGoodsTypeOneAndRowThreeWidget(isShowWrap: false);
  }

  /// 商品样式3 && 排列样式1
  Widget _getGoodsTypeThreeAndRowOneWidget() {
    GoodsItemDataModel _model = widget.dataModel;
    GoodsItemConfigModel _config = widget.configModel;
    double imgW = _config.itemWidth(context);
    double imgH = _config.itemWidth(context) * 160 / 351;
    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Image(
              image: NetworkImage(_model.coverImage),
              width: imgW,
              height: imgH,
              fit: BoxFit.cover,
            ),
            /// 4个角落上的标签
            Visibility(
              visible: _model.tagType == TagPositionType.leftTop,
              child: Positioned(left: 0, top: 0,
                child: Image(image: NetworkImage(_model.tagUrl), width: 50, height: 30)
              )
            ),
            Visibility(
              visible: _model.tagType == TagPositionType.leftBottom,
              child: Positioned(left: 0, bottom: 0,
                child: Image(image: NetworkImage(_model.tagUrl), width: 50, height: 30)
              )
            ),
            Visibility(
              visible: _model.tagType == TagPositionType.rightTop,
              child: Positioned(right: 0, top: 0,
                child: Image(image: NetworkImage(_model.tagUrl), width: 50, height: 30)
              )
            ),
            Visibility(
              visible: _model.tagType == TagPositionType.rightBottom,
              child: Positioned(right: 0, bottom: 0,
                child: Image(image: NetworkImage(_model.tagUrl), width: 50, height: 30)
              )
            ),
            Visibility(
              visible: _model.isSellOut,
              child: Container(
                alignment: Alignment.center,
                height: imgH,
                width: imgW,
                color: Color(0x7D000000),
                child: Image(
                  width: 136,
                  height: 136,
                  fit: BoxFit.fitWidth,
                  image: AssetImage(R.imagesProductSellOutSmall),
                ),
              )
            ),
          ],
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.fromLTRB(8, 10, 8, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                xtText(_model.productName, 16, mainBlackColor, fontWeight: FontWeight.w500, maxLines: 1, overflow: TextOverflow.ellipsis, alignment: TextAlign.left),
                Row(
                  mainAxisAlignment: _model.productTagImgNameList.isNotEmpty ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
                  children: <Widget>[
                    Visibility(
                      visible: _model.productTagImgNameList.isNotEmpty,
                      child: Wrap(
                        spacing: 2,
                        runSpacing: 2,
                        children: _productTags(_model),
                      ),
                    ),
                    xtText(_model.productSaleCountText, 12, mainBlackColor),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        xtText(_model.buyingPriceText, 18, mainRedColor),
                        Visibility(
                          visible: _model.mostEarnText.isEmpty,
                          child: Container(
                            padding: EdgeInsets.only(left: 4),
                            child: Text(
                              _model.marketPriceText,
                              style: TextStyle(
                                fontSize: 12,
                                color: main99GrayColor,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: main99GrayColor
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: _model.mostEarnText.isNotEmpty,
                          child: Container(padding: EdgeInsets.only(left: 4), child: xtText(_model.mostEarnText, 12, xtColor_FFFF7700)),
                        ),
                      ],
                    ),
                    Container(
                      height: 28,
                      width: 96,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: HexColor(_config.buttonBgColor),
                        borderRadius: BorderRadius.all(Radius.circular(14))
                      ),
                      child: xtText("立即购买", 16, Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          )
        )
      ],
    );
  }

  /// 商品样式3 && 排列样式2
  Widget _getGoodsTypeThreeAndRowTwoWidget() {
    GoodsItemDataModel _model = widget.dataModel;
    GoodsItemConfigModel _config = widget.configModel;
    return Column(
      children: <Widget>[
        Stack(
          children: _getProductImgAndSubTag(_model, _config.itemWidth(context), isShowWrap: true, wrapPadding: 6)
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.fromLTRB(9, 6, 9, 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                xtText(_model.productName, 14, mainBlackColor, fontWeight: FontWeight.w500, maxLines: 1, overflow: TextOverflow.ellipsis, alignment: TextAlign.left),
                Row(
                  children: <Widget>[
                    xtText(_model.buyingPriceText, 14, mainRedColor),
                    Visibility(
                      visible: _model.mostEarnText.isEmpty,
                      child: Container(
                        padding: EdgeInsets.only(left: 2),
                        child: Text(
                          _model.marketPriceText,
                          style: TextStyle(
                            fontSize: 10,
                            color: main99GrayColor,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: main99GrayColor
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _model.mostEarnText.isNotEmpty,
                      child: Container(padding: EdgeInsets.only(left: 2), child: xtText(_model.mostEarnText, 10, xtColor_FFFF7700)),
                    ),
                    Spacer(),
                    xtText(_model.productSaleCountText, 10, mainBlackColor),
                  ],
                ),
                Container(
                  height: 24,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: HexColor(_config.buttonBgColor),
                    borderRadius: BorderRadius.all(Radius.circular(12))
                  ),
                  child: xtText("立即购买", 14, Colors.white, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          )
        )
      ],
    );
  }

  /// 商品样式3 && 排列样式3
  Widget _getGoodsTypeThreeAndRowThreeWidget() {
    GoodsItemDataModel _model = widget.dataModel;
    GoodsItemConfigModel _config = widget.configModel;
    return Column(
      children: <Widget>[
        Stack(
          children: _getProductImgAndSubTag(_model, _config.itemWidth(context))
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.fromLTRB(4, 4, 4, 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                xtText(_model.productName, 12, mainBlackColor, fontWeight: FontWeight.w500, maxLines: 1, overflow: TextOverflow.ellipsis, alignment: TextAlign.left),
                Row(
                  children: <Widget>[
                    xtText(_model.buyingPriceText, 14, mainRedColor),
                    Visibility(
                      visible: _model.mostEarnText.isEmpty,
                      child: Container(
                        padding: EdgeInsets.only(left: 2),
                        child: Text(
                          _model.marketPriceText,
                          style: TextStyle(
                            fontSize: 10,
                            color: main99GrayColor,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: main99GrayColor
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _model.mostEarnText.isNotEmpty,
                      child: Container(padding: EdgeInsets.only(left: 2), child: xtText(_model.mostEarnText, 10, xtColor_FFFF7700)),
                    ),
                  ],
                ),
                Container(
                  height: 20,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: HexColor(_config.buttonBgColor),
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child: xtText("立即购买", 12, Colors.white, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          )
        )
      ],
    );
  }
}





/// ----------------------------------------- 优惠券组件测试页面 -----------------------------------------
class GoodsPage extends StatefulWidget {
  static String routerName = "goods";
  @override
  _GoodsPageState createState() => _GoodsPageState();
}

class _GoodsPageState extends State<GoodsPage> {
  GoodsModel _model = GoodsModel.getData();
  List<GoodsItemDataModel> goodsDataList = GoodsModel.getDataList();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: xtBackBar(
          title: "商品", back: () => XTRouter.closePage(context: context)),
      body: Container(
        child: ListView.builder(
          itemCount: _model.configList.length,
          itemBuilder: (BuildContext ctx, int index) {
            return GoodsItems(configModel: _model.configList[index], dataList: goodsDataList);
          }
        ),
      ),
    );
  }
}
