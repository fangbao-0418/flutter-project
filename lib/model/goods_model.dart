import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:xtflutter/model/promotion_model.dart';
import 'dart:convert';

/// 排列样式
enum GoodsItemRowStyleType {
  /// 一行一个
  rowOne,
  /// 一行二个
  rowTwo,
  /// 一行三个
  rowThree,
}

/// 商品样式
enum GoodsItemStyleType {
  /// 样式一
  styleOne,
  /// 样式二
  styleTwo,
  /// 样式三
  styleThree,
}

/// 角标
enum TagPositionType {
  none,
  leftTop,
  leftBottom,
  rightTop,
  rightBottom
}

class GoodsModel {
  static GoodsModel getData() => GoodsModel.fromJson({});
  static List<GoodsItemDataModel> getDataList() =>
      List<GoodsItemDataModel>.from(
          goodsDataList.map((e) => GoodsItemDataModel.fromJson(e)));
  GoodsModel({this.configList});
  List<GoodsItemConfigModel> configList;
  factory GoodsModel.fromJson(Map<String, dynamic> json) {
    return GoodsModel(
        configList: List<GoodsItemConfigModel>.from(
            goodsConfigList.map((e) => GoodsItemConfigModel.fromJson(e["config"]))));
  }
}

class GoodsItemConfigModel extends Config {

  GoodsItemConfigModel({
      this.styleType,
      this.goodsStyleType,
      this.type,
      this.buttonBgColor,
  });

  int styleType;
  int goodsStyleType;
  int type;
  String buttonBgColor;

  factory GoodsItemConfigModel.fromJson(Map<String, dynamic> json) => GoodsItemConfigModel(
    styleType: json["styleType"],
    goodsStyleType: json["goodsStyleType"],
    type: json["type"],
    buttonBgColor: json["buttonBgColor"],
  );

  Map<String, dynamic> toJson() => {
    "styleType": styleType,
    "goodsStyleType": goodsStyleType,
    "type": type,
    "buttonBgColor": buttonBgColor,
  };

  /// 自定义参数
  /// 商品样式
  GoodsItemStyleType get goodsType {
    switch (goodsStyleType) {
      case 1:
        return GoodsItemStyleType.styleOne;
        break;
      case 2:
        return GoodsItemStyleType.styleTwo;
        break;
      case 3:
        return GoodsItemStyleType.styleThree;
        break;
      default:
        return GoodsItemStyleType.styleOne;
    }
  }
  /// 排列样式
  GoodsItemRowStyleType get style {
    switch (styleType) {
      case 1:
        return GoodsItemRowStyleType.rowOne;
        break;
      case 2:
        return GoodsItemRowStyleType.rowTwo;
        break;
      case 3:
        return GoodsItemRowStyleType.rowThree;
        break;
      default:
        return GoodsItemRowStyleType.rowOne;
    }
  }

  /// 单个item宽度
  double itemWidth(BuildContext ctx) {
    final width = MediaQuery.of(ctx).size.width;
    switch (style) {
      case GoodsItemRowStyleType.rowOne:
        return width - 24;
        break;
      case GoodsItemRowStyleType.rowTwo:
        return (width - 24 - 8) / 2;
        break;
      case GoodsItemRowStyleType.rowThree:
        return (width - 24 - 6) / 3;
        break;
      default:
        return 0.0;
    }
  }
  /// 单个item高度
  double itemHeight(BuildContext ctx) {
    return itemWidth(ctx) / childRatio;
  }
  /// 高度
  double gridHeight(int count, BuildContext ctx) {
    switch (style) {
      case GoodsItemRowStyleType.rowOne:
        double itemHeight = itemWidth(ctx) / childRatio;
        return count * itemHeight + (count - 1) * 8 + 16;
        break;
      case GoodsItemRowStyleType.rowTwo:
        double itemHeight = itemWidth(ctx) / childRatio;
        return (count / 2).ceil() * itemHeight + ((count / 2).ceil() - 1) * 8 + 16;
        break;
      case GoodsItemRowStyleType.rowThree:
        double itemHeight = itemWidth(ctx) / childRatio;
        return (count / 3).ceil() * itemHeight + ((count / 3).ceil() - 1) * 3 + 16;
        break;
      default:
        return 0.0;
    }
  }

  /// 横向间隔
  double get crossAxisSpacing {
    switch (style) {
      case GoodsItemRowStyleType.rowOne:
        return 0.0;
        break;
      case GoodsItemRowStyleType.rowTwo:
        return 8.0;
        break;
      case GoodsItemRowStyleType.rowThree:
        return 3.0;
        break;
      default:
        return 0.0;
    }
  }

  /// 宽高比
  double get childRatio {
    switch (goodsType) {
      case GoodsItemStyleType.styleOne:
        switch (style) {
          case GoodsItemRowStyleType.rowOne:
            return 351 / 152;
            break;
          case GoodsItemRowStyleType.rowTwo:
            return 172 / 252;
            break;
          case GoodsItemRowStyleType.rowThree:
            return 115 / 180;
            break;
          default:
            return 1;
        }
        break;
      case GoodsItemStyleType.styleTwo:
        switch (style) {
          case GoodsItemRowStyleType.rowOne:
            return 351 / 152;
            break;
          case GoodsItemRowStyleType.rowTwo:
            return 172 / 274;
            break;
          case GoodsItemRowStyleType.rowThree:
            return 115 / 180;
            break;
          default:
            return 1;
        }
        break;
      case GoodsItemStyleType.styleThree:
        switch (style) {
          case GoodsItemRowStyleType.rowOne:
            return 351 / 260;
            break;
          case GoodsItemRowStyleType.rowTwo:
            return 172 / 252;
            break;
          case GoodsItemRowStyleType.rowThree:
            return 115 / 183;
            break;
          default:
            return 1;
        }
        break;
      default:
        return 1;
    }
  }
}


GoodsItemDataModel goodsItemDataModelFromJson(String str) => GoodsItemDataModel.fromJson(json.decode(str));
String goodsItemDataModelToJson(GoodsItemDataModel data) => json.encode(data.toJson());
class GoodsItemDataModel {
    GoodsItemDataModel({
        this.interest,
        this.productId,
        this.coverImage,
        this.bannerImage,
        this.productName,
        this.productDescription,
        this.marketPrice,
        this.buyingPrice,
        this.limitNumber,
        this.groupBuyingPrice,
        this.groupMostEarn,
        this.groupMarketPrice,
        this.remainInventory,
        this.inventory,
        this.mostEarn,
        this.productSaleCount,
        this.tagUrl,
        this.tagPosition,
        this.showNum,
        this.type,
        this.shopType,
        this.promotionId,
        this.promotionType,
        this.promotionStartTime,
        this.promotionEndTime,
        this.canAddCart,
        this.showCoupon,
    });

    dynamic interest;
    int productId;
    String coverImage;
    String bannerImage;
    String productName;
    String productDescription;
    int marketPrice;
    int buyingPrice;
    int limitNumber;
    dynamic groupBuyingPrice;
    dynamic groupMostEarn;
    dynamic groupMarketPrice;
    int remainInventory;
    dynamic inventory;
    int mostEarn;
    int productSaleCount;
    String tagUrl;
    dynamic tagPosition;
    int showNum;
    int type;
    int shopType;
    dynamic promotionId;
    dynamic promotionType;
    dynamic promotionStartTime;
    dynamic promotionEndTime;
    int canAddCart;
    int showCoupon;

    factory GoodsItemDataModel.fromJson(Map<String, dynamic> json) => GoodsItemDataModel(
        interest: json["interest"],
        productId: json["productId"],
        coverImage: json["coverImage"],
        bannerImage: json["bannerImage"],
        productName: json["productName"],
        productDescription: json["productDescription"],
        marketPrice: json["marketPrice"],
        buyingPrice: json["buyingPrice"],
        limitNumber: json["limitNumber"],
        groupBuyingPrice: json["groupBuyingPrice"],
        groupMostEarn: json["groupMostEarn"],
        groupMarketPrice: json["groupMarketPrice"],
        remainInventory: json["remainInventory"],
        inventory: json["inventory"],
        mostEarn: json["mostEarn"],
        productSaleCount: json["productSaleCount"],
        tagUrl: json["tagUrl"] == null ? "" : json["tagUrl"],
        tagPosition: json["tagPosition"],
        showNum: json["showNum"],
        type: json["type"],
        shopType: json["shopType"],
        promotionId: json["promotionId"],
        promotionType: json["promotionType"],
        promotionStartTime: json["promotionStartTime"],
        promotionEndTime: json["promotionEndTime"],
        canAddCart: json["canAddCart"],
        showCoupon: json["showCoupon"],
    );

    Map<String, dynamic> toJson() => {
        "interest": interest,
        "productId": productId,
        "coverImage": coverImage,
        "bannerImage": bannerImage,
        "productName": productName,
        "productDescription": productDescription,
        "marketPrice": marketPrice,
        "buyingPrice": buyingPrice,
        "limitNumber": limitNumber,
        "groupBuyingPrice": groupBuyingPrice,
        "groupMostEarn": groupMostEarn,
        "groupMarketPrice": groupMarketPrice,
        "remainInventory": remainInventory,
        "inventory": inventory,
        "mostEarn": mostEarn,
        "productSaleCount": productSaleCount,
        "tagUrl": tagUrl,
        "tagPosition": tagPosition,
        "showNum": showNum,
        "type": type,
        "shopType": shopType,
        "promotionId": promotionId,
        "promotionType": promotionType,
        "promotionStartTime": promotionStartTime,
        "promotionEndTime": promotionEndTime,
        "canAddCart": canAddCart,
        "showCoupon": showCoupon,
    };

    /// 自定义参数
    /// 标签位置类型
    TagPositionType get tagType {
      if (tagPosition == null || tagUrl == null) { return TagPositionType.none; }
      switch (tagPosition) {
        case 5:
          return TagPositionType.leftTop;
          break;
        case 10:
          return TagPositionType.leftBottom;
          break;
        case 15:
          return TagPositionType.rightTop;
          break;
        case 20:
          return TagPositionType.rightBottom;
          break;
        default:
          return TagPositionType.none;
      }
    }
    /// 是否已售罄
    bool get isSellOut {
      if (inventory == null) {
        return true;
      }
      int salesCount = productSaleCount ?? 0;
      if (salesCount >= inventory || inventory == 0) {
        return true;
      } else {
        return false;
      }
    }
     /// 秒杀价
  String get buyingPriceText {
    if (buyingPrice != null && buyingPrice > 0) {
      return MoneyUtil.changeF2YWithUnit(buyingPrice, format: MoneyFormat.END_INTEGER, unit: MoneyUnit.YUAN);
    }
    return "";
  }
  /// 划线价
  String get marketPriceText {
    if (marketPrice != null && marketPrice > 0) {
      return MoneyUtil.changeF2YWithUnit(marketPrice, format: MoneyFormat.END_INTEGER, unit: MoneyUnit.YUAN);
    }
    return "";
  }
  /// 分享赚
  String get mostEarnText {
    if (mostEarn != null && mostEarn > 0) {
      return "赚" + MoneyUtil.changeF2YWithUnit(mostEarn, format: MoneyFormat.END_INTEGER, unit: MoneyUnit.YUAN_ZH);
    }
    return "";
  }
}






const List<Map<String, dynamic>> goodsConfigList = [
  // {
  //   "id": 7221,
  //   "type": "goods",
  //   "childType": 1,
  //   "bizType": 1,
  //   "config": {
  //     "styleType": 3,
  //     "goodsStyleType": 3,
  //     "type": 1,
  //     "buttonBgColor": "#e7e0e0"
  //   },
  //   "data": null,
  //   "dataTotal": 2,
  //   "userLevel": ["0", "10", "20", "30", "40"],
  //   "platform": ["app", "wx-mini", "wx-h5"],
  //   "isAuchor": false,
  //   "auchorName": ""
  // }, 
  // {
  //   "id": 7222,
  //   "type": "goods",
  //   "childType": 1,
  //   "bizType": 1,
  //   "config": {
  //     "styleType": 2,
  //     "goodsStyleType": 3,
  //     "type": 1,
  //     "buttonBgColor": "#0e0000"
  //   },
  //   "data": null,
  //   "dataTotal": 2,
  //   "userLevel": ["0", "10", "20", "30", "40"],
  //   "platform": ["app", "wx-mini", "wx-h5"],
  //   "isAuchor": false,
  //   "auchorName": ""
  // }, {
  //   "id": 7223,
  //   "type": "goods",
  //   "childType": 1,
  //   "bizType": 1,
  //   "config": {
  //     "styleType": 1,
  //     "goodsStyleType": 3,
  //     "type": 1,
  //     "buttonBgColor": "#ef0c0c"
  //   },
  //   "data": null,
  //   "dataTotal": 1,
  //   "userLevel": ["0", "10", "20", "30", "40"],
  //   "platform": ["app", "wx-mini", "wx-h5"],
  //   "isAuchor": false,
  //   "auchorName": ""
  // }, {
  //   "id": 7224,
  //   "type": "goods",
  //   "childType": 1,
  //   "bizType": 1,
  //   "config": {
  //     "styleType": 3,
  //     "goodsStyleType": 2,
  //     "type": 1,
  //     "buttonBgColor": "#4D4D4D"
  //   },
  //   "data": null,
  //   "dataTotal": 2,
  //   "userLevel": ["0", "10", "20", "30", "40"],
  //   "platform": ["app", "wx-mini", "wx-h5"],
  //   "isAuchor": false,
  //   "auchorName": ""
  // }, {
  //   "id": 7225,
  //   "type": "goods",
  //   "childType": 1,
  //   "bizType": 1,
  //   "config": {
  //     "styleType": 2,
  //     "goodsStyleType": 2,
  //     "type": 1,
  //     "buttonBgColor": "#4D4D4D"
  //   },
  //   "data": null,
  //   "dataTotal": 2,
  //   "userLevel": ["0", "10", "20", "30", "40"],
  //   "platform": ["app", "wx-mini", "wx-h5"],
  //   "isAuchor": false,
  //   "auchorName": ""
  // }, {
  //   "id": 7226,
  //   "type": "goods",
  //   "childType": 1,
  //   "bizType": 1,
  //   "config": {
  //     "styleType": 1,
  //     "goodsStyleType": 2,
  //     "type": 1,
  //     "buttonBgColor": "#4D4D4D"
  //   },
  //   "data": null,
  //   "dataTotal": 1,
  //   "userLevel": ["0", "10", "20", "30", "40"],
  //   "platform": ["app", "wx-mini", "wx-h5"],
  //   "isAuchor": false,
  //   "auchorName": ""
  // }, {
  //   "id": 7227,
  //   "type": "goods",
  //   "childType": 1,
  //   "bizType": 1,
  //   "config": {
  //     "styleType": 3,
  //     "goodsStyleType": 1,
  //     "type": 1,
  //     "buttonBgColor": "#4D4D4D"
  //   },
  //   "data": null,
  //   "dataTotal": 2,
  //   "userLevel": ["0", "10", "20", "30", "40"],
  //   "platform": ["app", "wx-mini", "wx-h5"],
  //   "isAuchor": false,
  //   "auchorName": ""
  // }, {
  //   "id": 7228,
  //   "type": "goods",
  //   "childType": 1,
  //   "bizType": 1,
  //   "config": {
  //     "styleType": 2,
  //     "goodsStyleType": 1,
  //     "type": 1,
  //     "buttonBgColor": "#4D4D4D"
  //   },
  //   "data": null,
  //   "dataTotal": 2,
  //   "userLevel": ["0", "10", "20", "30", "40"],
  //   "platform": ["app", "wx-mini", "wx-h5"],
  //   "isAuchor": false,
  //   "auchorName": ""
  // }, 
  {
    "id": 7229,
    "type": "goods",
    "childType": 1,
    "bizType": 1,
    "config": {
      "styleType": 1,
      "goodsStyleType": 1,
      "type": 1,
      "buttonBgColor": "#4D4D4D"
    },
    "data": null,
    "dataTotal": 2,
    "userLevel": ["0", "10", "20", "30", "40"],
    "platform": ["app", "wx-mini", "wx-h5"],
    "isAuchor": false,
    "auchorName": ""
  }
];

const List<Map<String, dynamic>> goodsDataList = [
  {
			"interest": null,
			"productId": 4846,
			"coverImage": "https://sh-tximg.hzxituan.com/tximg/crm/e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b8551600076421576.jpg",
			"bannerImage": "https://sh-tximg.hzxituan.com/tximg/crm/e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b8551600076432435.jpg",
			"productName": "wl的测试商品-pop商家阿卡丽世纪东方按时",
			"productDescription": "wl的测试商品-pop商家莱克斯顿案例三等奖",
			"marketPrice": 199900,
			"buyingPrice": 99880,
			"limitNumber": 0,
			"groupBuyingPrice": null,
			"groupMostEarn": null,
			"groupMarketPrice": null,
			"remainInventory": 30,
			"inventory": null,
			"mostEarn": 200,
			"productSaleCount": 0,
			"tagUrl": null,
			"tagPosition": null,
			"showNum": 1,
			"type": 0,
			"shopType": 1,
			"promotionId": null,
			"promotionType": null,
			"promotionStartTime": null,
			"promotionEndTime": null,
			"canAddCart": 1,
			"showCoupon": 1
		}, {
			"interest": null,
			"productId": 4844,
			"coverImage": "https://sh-tximg.hzxituan.com/tximg/small-store-goods/e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b8551600068286854.png",
			"bannerImage": "",
			"productName": "wl的小店商品2",
			"productDescription": "",
			"marketPrice": 0,
			"buyingPrice": 1990,
			"limitNumber": 0,
			"groupBuyingPrice": null,
			"groupMostEarn": null,
			"groupMarketPrice": null,
			"remainInventory": 220,
			"inventory": null,
			"mostEarn": 557,
			"productSaleCount": 0,
			"tagUrl": null,
			"tagPosition": null,
			"showNum": 1,
			"type": 40,
			"shopType": 2,
			"promotionId": null,
			"promotionType": null,
			"promotionStartTime": null,
			"promotionEndTime": null,
			"canAddCart": 1,
			"showCoupon": 0
		},
    {
			"interest": null,
			"productId": 4846,
			"coverImage": "https://sh-tximg.hzxituan.com/tximg/crm/e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b8551600076421576.jpg",
			"bannerImage": "https://sh-tximg.hzxituan.com/tximg/crm/e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b8551600076432435.jpg",
			"productName": "wl的测试商品-pop商家",
			"productDescription": "wl的测试商品-pop商家",
			"marketPrice": 1900,
			"buyingPrice": 900,
			"limitNumber": 0,
			"groupBuyingPrice": null,
			"groupMostEarn": null,
			"groupMarketPrice": null,
			"remainInventory": 30,
			"inventory": null,
			"mostEarn": 200,
			"productSaleCount": 0,
			"tagUrl": null,
			"tagPosition": null,
			"showNum": 1,
			"type": 0,
			"shopType": 1,
			"promotionId": null,
			"promotionType": null,
			"promotionStartTime": null,
			"promotionEndTime": null,
			"canAddCart": 1,
			"showCoupon": 1
		}, 
    // {
		// 	"interest": null,
		// 	"productId": 4844,
		// 	"coverImage": "https://sh-tximg.hzxituan.com/tximg/small-store-goods/e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b8551600068286854.png",
		// 	"bannerImage": "",
		// 	"productName": "wl的小店商品2",
		// 	"productDescription": "",
		// 	"marketPrice": 0,
		// 	"buyingPrice": 1990,
		// 	"limitNumber": 0,
		// 	"groupBuyingPrice": null,
		// 	"groupMostEarn": null,
		// 	"groupMarketPrice": null,
		// 	"remainInventory": 220,
		// 	"inventory": null,
		// 	"mostEarn": 557,
		// 	"productSaleCount": 0,
		// 	"tagUrl": null,
		// 	"tagPosition": null,
		// 	"showNum": 1,
		// 	"type": 40,
		// 	"shopType": 2,
		// 	"promotionId": null,
		// 	"promotionType": null,
		// 	"promotionStartTime": null,
		// 	"promotionEndTime": null,
		// 	"canAddCart": 1,
		// 	"showCoupon": 0
		// }, {
		// 	"interest": null,
		// 	"productId": 4844,
		// 	"coverImage": "https://sh-tximg.hzxituan.com/tximg/small-store-goods/e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b8551600068286854.png",
		// 	"bannerImage": "",
		// 	"productName": "wl的小店商品2",
		// 	"productDescription": "",
		// 	"marketPrice": 0,
		// 	"buyingPrice": 1990,
		// 	"limitNumber": 0,
		// 	"groupBuyingPrice": null,
		// 	"groupMostEarn": null,
		// 	"groupMarketPrice": null,
		// 	"remainInventory": 220,
		// 	"inventory": null,
		// 	"mostEarn": 557,
		// 	"productSaleCount": 0,
		// 	"tagUrl": null,
		// 	"tagPosition": null,
		// 	"showNum": 1,
		// 	"type": 40,
		// 	"shopType": 2,
		// 	"promotionId": null,
		// 	"promotionType": null,
		// 	"promotionStartTime": null,
		// 	"promotionEndTime": null,
		// 	"canAddCart": 1,
		// 	"showCoupon": 0
		// }
];
