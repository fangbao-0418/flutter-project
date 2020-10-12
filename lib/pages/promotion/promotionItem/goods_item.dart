import 'package:flutter/material.dart';
import 'package:xtflutter/config/app_config/color_config.dart';
import 'package:xtflutter/config/app_config/method_config.dart';
import 'package:xtflutter/model/goods_model.dart';
import 'package:xtflutter/pages/normal/app_nav_bar.dart';
import 'package:xtflutter/router/router.dart';
import '../../../r.dart';

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


class GoodsItems extends StatefulWidget {
  GoodsItems({this.configModel, this.dataList});

  final GoodsItemConfigModel configModel;
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
      child: Container(
        color: Colors.white,
        child: _getWidget(),
      ),
    );
  }

  Widget _getWidget() {
    if (widget.configModel.style == GoodsItemRowStyleType.rowOne && widget.configModel.goodsType == GoodsItemStyleType.styleOne) {
      return _getGoodsTypeOneAndRowOneWidget();
    }

    return Container(color: Colors.red);
  }

  /// 商品样式1 && 排列样式1
  Widget _getGoodsTypeOneAndRowOneWidget() {
    GoodsItemDataModel _model = widget.dataModel;
    GoodsItemConfigModel _config = widget.configModel;
    return Row(
      children: <Widget>[
        Stack(
          children: <Widget>[
            xtRoundAvatarImage(_config.itemHeight(context), 8, _model.coverImage, borderColor: mainF5GrayColor, borderWidth: 0.5),
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
          ],
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                
                Column(
                  children: <Widget>[
                    xtText(_model.productName, 16, mainBlackColor, fontWeight: FontWeight.w500, maxLines: 1, overflow: TextOverflow.ellipsis)
                  ],
                ),
                Column(
                  children: <Widget>[
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
}