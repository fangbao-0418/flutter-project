import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:xtflutter/config/app_config/app_listener.dart';
import 'package:xtflutter/config/app_config/color_config.dart';
import 'package:xtflutter/config/app_config/method_config.dart';
import 'package:xtflutter/model/home_limit_seckill.dart';
import 'package:xtflutter/pages/normal/toast.dart';
import 'package:xtflutter/r.dart';
import 'package:xtflutter/utils/appconfig.dart';

enum SeckillShareType {
  none,
  twoPro,
  sixPro
}

class LimitTimeSeckillSharePage extends StatefulWidget {

  LimitTimeSeckillSharePage({this.productList, this.shareModel});

  final List<LimitTimeSeckillProductModel> productList;

  final ShareCardInfoModel shareModel;

  @override
  _LimitTimeSeckillSharePageState createState() => _LimitTimeSeckillSharePageState();
}

class _LimitTimeSeckillSharePageState extends State<LimitTimeSeckillSharePage> {
  /// 尺寸
  double _scale = 1;
  /// 商品列表
  List<LimitTimeSeckillProductModel> _productList = [];
  /// 分享数据
  ShareCardInfoModel _shareModel;
  /// 截图key
  GlobalKey _repaintWidgetKey = GlobalKey();
  /// 分享类型
  SeckillShareType _shareType = SeckillShareType.none;

  @override
  void initState() {
    super.initState();
    _productList = widget.productList;
    _shareModel = widget.shareModel;
    if (_productList.length >= 6) {
      _shareType = SeckillShareType.sixPro;
    } else if (_productList.length >= 2 && _productList.length < 6) {
      _shareType = SeckillShareType.twoPro;
    } else {
      _shareType = SeckillShareType.none;
    }
  }

  /// 分享微信
  void _shareWechatMini() {
    Map<String, dynamic> shareParams = _shareModel.toJson();
    shareParams["desc"] = "喜团超值爆款限时秒杀！速度抢！";
    shareParams["title"] = "喜团超值爆款限时秒杀！速度抢！";
    shareParams["headImage"] = AppConfig.user.headImage;
    shareParams["imgUrl"] = "https://assets.hzxituan.com/upload/2020-05-11/6aa7e8de-4468-47b5-a43e-14dfc1975e57-ka29uu10.png";
    shareParams["link"] = "https://myouxuan.hzxituan.com/#/spike";
    shareParams["nickName"] = AppConfig.user.nickName;
    shareParams["page"] = "pages/seckill/index?mid=" + _shareModel.mid;
    shareParams["scene"] = "mid=" + _shareModel.mid;
    shareParams["shareType"] = "wx-mini";
    AppListener.shareWechat(shareParams);
  }

  /// 保存图片
  void _shareSaveImg() async {
    try {
      RenderRepaintBoundary boundary = _repaintWidgetKey.currentContext.findRenderObject();
      double dpr = MediaQuery.of(context).devicePixelRatio;
      var image = await boundary.toImage(pixelRatio: dpr);
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      String base64Str = base64Encode(pngBytes);
      String base64Image = "data:image/png;base64," + base64Str;
      AppListener.saveImage({"data": base64Image});
    } catch (e) {
      Toast.showToast(msg: "保存失败，请重试");
    }
  }

  /// 获取分享背景图
  String get _shareBgImgName {
    switch (_shareType) {
      case SeckillShareType.twoPro:
        return R.imagesLimitTimeSeckillShareBgTwo;
        break;
      case SeckillShareType.sixPro:
        return R.imagesLimitTimeSeckillShareBg;
        break;
      default:
        return R.imagesLimitTimeSeckillShareBgNone;
    }
  }

  /// 获取分享背景视图
  Widget _getShareBgWidget() {
    switch (_shareType) {
      case SeckillShareType.twoPro:
        return Container(
          margin: EdgeInsets.only(top: 242 * _scale),
          child: _getGridViewTwo(),
        );
        break;
      case SeckillShareType.sixPro:
        return Container(
          margin: EdgeInsets.only(top: 187 * _scale),
          child: _getGridView()
        );
        break;
      default:
        return Container();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    /// 分享视图宽度
    final double viewW = MediaQuery.of(context).size.width - 100;
    /// 比例尺寸
    _scale = viewW / 375;
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        color: Color(0x90000000),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: () {},
                  child: RepaintBoundary(
                    key: _repaintWidgetKey,
                    child: Container(
                      width: viewW,
                      height: viewW * 668 / 375,
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Image.asset(_shareBgImgName),
                          _getShareBgWidget(),
                          Container(
                            margin: EdgeInsets.only(top: 490 * _scale, left: 12 * _scale, right: 12 * _scale),
                            padding: EdgeInsets.only(left: 11 * _scale),
                            height: 120 * _scale,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(4))
                            ),
                            child: _getUserInfoView(),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ),
            Container(
              height: AppConfig.bottomH + 110,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12)
                ),
              ),
              padding: EdgeInsets.only(left: 72 * _scale, right: 72 * _scale),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      _shareWechatMini();
                    }, 
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Image(
                          image: AssetImage(R.imagesShareWechat),
                          width: 45,
                          height: 45,
                        ),
                        SizedBox(height: 8),
                        xtText("分享好友", 14, xtColor_4C4C4C),
                        SizedBox(height: AppConfig.bottomH),
                      ],
                    )
                  ),
                  FlatButton(
                    onPressed: () {
                      _shareSaveImg();
                    }, 
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Image(
                          image: AssetImage(R.imagesShareSaveImg),
                          width: 45,
                          height: 45,
                        ),
                        SizedBox(height: 8),
                        xtText("保存本地", 14, xtColor_4C4C4C),
                        SizedBox(height: AppConfig.bottomH),
                      ],
                    )
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _getGridView() {
    return GridView.builder(
      padding: EdgeInsets.only(left: 12 * _scale, right: 12 * _scale),
      itemCount: 6,
      controller: ScrollController(
        keepScrollOffset: false
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10 * _scale,
        mainAxisSpacing: 10 * _scale,
        childAspectRatio: 110 / 143
      ), 
      itemBuilder: (BuildContext ctx, int index) {
        return _getGridCellView(_productList[index], false);
      },
    );
  }

  Widget _getGridViewTwo() {
    return GridView.builder(
      padding: EdgeInsets.only(left: 12 * _scale, right: 12 * _scale),
      itemCount: 2,
      controller: ScrollController(
        keepScrollOffset: false
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15 * _scale,
        childAspectRatio: 168 / 218
      ), 
      itemBuilder: (BuildContext ctx, int index) {
        return _getGridCellView(_productList[index], true);
      },
    );
  }

  Widget _getGridCellView(LimitTimeSeckillProductModel model, bool isTwo) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
              child: Image(
                image: NetworkImage(model.coverImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: (isTwo ? 43 : 28) * _scale,
            child: Text(
              "秒杀价¥${model.buyingPriceText}", 
              style: TextStyle(
                fontSize: (isTwo ? 16 : 12) * _scale, 
                color: xtColor_E02020, 
                fontWeight: FontWeight.bold, 
                decoration: TextDecoration.none
              )
            ),
            decoration: BoxDecoration(
              color: xtColor_FFD652,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(4),
                bottomLeft: Radius.circular(4),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _getUserInfoView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            xtRoundAvatarImage(40 * _scale, (40 * _scale) / 2, AppConfig.user.headImage),
            SizedBox(width: 5 * _scale),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppConfig.user.nickName, 
                  style: TextStyle(
                    fontSize: 16 * _scale, 
                    color: mainBlackColor, 
                    fontWeight: FontWeight.normal, 
                    decoration: TextDecoration.none
                  )
                ),
                Text(
                  "喜团限时秒杀速度抢！", 
                  style: TextStyle(
                    fontSize: 15 * _scale, 
                    color: mainRedColor, 
                    fontWeight: FontWeight.normal, 
                    decoration: TextDecoration.none
                  )
                ),
              ],
            )
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 80 * _scale,
              height: 80 * _scale,
              child: Image.network(_shareModel.imagerUrl),
            ),
            Text(
              "长按识别去购买！", 
              style: TextStyle(
                fontSize: 12 * _scale, 
                color: xtColor_6D7278, 
                fontWeight: FontWeight.normal, 
                decoration: TextDecoration.none
              )
            ),
          ],
        )
      ],
    );
  }
}