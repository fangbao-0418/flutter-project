
enum SeckillStatus {
  buying,
  end,
  noStart
}

enum TagPositionType {
  none,
  leftTop,
  leftBottom,
  rightTop,
  rightBottom
}

class LimitTimeSeckillModel {
  LimitTimeSeckillModel({
    this.promotionId, 
    this.status, 
    this.promotionTime,
    this.promotionEndTime, 
    this.defaultSelected, 
    this.tagUrl,
    this.tagPosition, 
    this.promotionStartTimeDesc, 
    this.desc,
    this.products});

  int promotionId;
  int status;
  int promotionTime;
  int promotionEndTime;
  bool defaultSelected;
  String tagUrl;
  int tagPosition;
  String promotionStartTimeDesc;
  String desc;
  List<LimitTimeSeckillProductModel> products;

  ///自定义参数
  SeckillStatus get seckillStatus {
    switch (status) {
      case 3:
        return SeckillStatus.noStart;
        break;
      case 2:
        return SeckillStatus.end;
        break;
      case 1:
        return SeckillStatus.buying;
        break;
      default:
        return SeckillStatus.buying;
    }
  }

  factory LimitTimeSeckillModel.fromJson(Map<String, dynamic> json) =>
      LimitTimeSeckillModel(
          promotionId: json["promotionId"],
          status: json["status"],
          promotionTime: json["promotionTime"],
          promotionEndTime: json["promotionEndTime"],
          defaultSelected: json["defaultSelected"],
          tagUrl: json["tagUrl"],
          tagPosition: json["tagPosition"],
          promotionStartTimeDesc: json["promotionStartTimeDesc"],
          desc: json["desc"],
          products: json["products"] == null 
              ? [] : List<LimitTimeSeckillProductModel>.from(json["products"].map((x) => LimitTimeSeckillProductModel.fromJson(x)))
        );
}

class LimitTimeSeckillProductModel {
  LimitTimeSeckillProductModel({
    this.promotionSpuId, 
    this.productId, 
    this.coverImage,
    this.newCoverImage, 
    this.bannerImage, 
    this.productName,
    this.productDescription, 
    this.marketPrice, 
    this.buyingPrice,
    this.limitNumber,
    this.remainInventory,
    this.inventory,
    this.spuSalesCount,
    this.mostEarn,
    this.isSub,
    this.tagPosition,
    this.tagUrl,
    this.type});

  int promotionSpuId;
  int productId;
  String coverImage;
  String newCoverImage;
  String bannerImage;
  String productName;
  String productDescription;
  int marketPrice;
  int buyingPrice;
  int limitNumber;
  
  int remainInventory;
  int inventory;
  int spuSalesCount;
  int mostEarn;
  bool isSub;
  int tagPosition;
  String tagUrl;
  int type;

  /// 自定义参数
  /// 是否已售罄
  bool get isSellOut {
    if (inventory == null) {
      return true;
    }
    int salesCount = spuSalesCount ?? 0;
    if (salesCount >= inventory || inventory == 0) {
      return true;
    } else {
      return false;
    }
  }
  /// 已售比例
  double get sellRatio {
    if (inventory == null) {
      return 1.0;
    }
    if (isSellOut) {
      return 1.0;
    } else if (spuSalesCount != null && spuSalesCount > 0) {
      double ratio = spuSalesCount / inventory;
      if (ratio > 0 && ratio< 0.01) {
        ratio = 0.01;
      } else if (ratio > 0.99 && ratio < 1) {
        ratio = 0.99;
      } else if (ratio > 1.0) {
        ratio = 1.0;
      }
      return ratio;
    } else {
      return 0.0;
    }
  }
  /// 已售xxx%
  String get sellText {
    double sealsRatio100 = sellRatio * 100;
    if (sealsRatio100 <= 0) {
      return "  已售0%";
    }
    return "  已售" + sealsRatio100.floor().toString() + "%";
  }
  /// 已抢xxx件
  String get sellCountText {
    if (spuSalesCount != null && spuSalesCount > 0) {
      return "  已抢$spuSalesCount件";
    }
    return "";
  }
  /// 秒杀价
  String get buyingPriceText {
    if (buyingPrice != null && buyingPrice > 0) {
      return (buyingPrice / 100).toString();
    }
    return "";
  }
  /// 划线价
  String get marketPriceText {
    if (marketPrice != null && marketPrice > 0) {
      return (marketPrice / 100).toString();
    }
    return "";
  }
  /// 分享赚
  String get mostEarnText {
    if (mostEarn != null && mostEarn > 0) {
      return "分享赚" + (mostEarn / 100).toString() + "元";
    }
    return "";
  }
  /// 限量多少件
  String get limitNumText {
    return inventory == null ? "" : "限量$inventory件";
  }
  /// 标签位置类型
  TagPositionType get tagType {
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
  /// 商品类型图标路径
  String get productImgName {
    if (type == 10) {
      return "images/product_tag_abroad_s.png";
    } else if (type == 20) {
      return "images/product_tag_global_s.png";
    } else {
      return "";
    }
  }

  factory LimitTimeSeckillProductModel.fromJson(Map<String, dynamic> json) =>
      LimitTimeSeckillProductModel(
          promotionSpuId: json["promotionSpuId"],
          productId: json["productId"],
          coverImage: json["coverImage"],
          newCoverImage: json["newCoverImage"],
          bannerImage: json["bannerImage"],
          productName: json["productName"],
          productDescription: json["productDescription"],
          marketPrice: json["marketPrice"],
          buyingPrice: json["buyingPrice"],
          limitNumber: json["limitNumber"],
          remainInventory: json["remainInventory"],
          inventory: json["inventory"],
          spuSalesCount: json["spuSalesCount"],
          mostEarn: json["mostEarn"],
          isSub: json["isSub"],
          tagPosition: json["tagPosition"] == null ? 0 : json["tagPosition"],
          tagUrl: json["tagUrl"] == null ? "" : json["tagUrl"],
          type: json["type"]);
}


class ShareCardInfoModel {
  ShareCardInfoModel({
    this.shareType,
    this.imagerUrl,
    this.linkUrl,
    this.host,
    this.appid,
    this.miniId,
  });

  String shareType;
  String imagerUrl;
  String linkUrl;
  String host;
  String appid;
  String miniId;

  /// mid
  String _mid;
  String get mid => _mid;
  void setMid(String mid) {
    this._mid = mid;
  }

  factory ShareCardInfoModel.fromJson(Map<String, dynamic> json) =>
      ShareCardInfoModel(
        shareType: json["shareType"],
        imagerUrl: json["imagerUrl"],
        linkUrl: json["linkUrl"],
        host: json["host"],
        appid: json["appid"],
        miniId: json["miniId"],
      );

  Map<String, dynamic> toJson() => {
    "shareType": shareType, 
    "imagerUrl": imagerUrl, 
    "linkUrl": linkUrl, 
    "host": host,
    "appid": appid, 
    "miniId": miniId, 
  };
}