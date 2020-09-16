
enum SeckillStatus {
  buying,
  end,
  noStart
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
    this.isSub});

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

  /// 自定义参数
  /// 是否已售罄
  bool get isSellOut => remainInventory == 0;
  /// 已售比例
  double get sellRatio {
    if (inventory == null || remainInventory == null) {
      return 0;
    }
    if (isSellOut) {
      return 1;
    } else {
      return ((inventory - remainInventory) / inventory);
    }
  }
  /// 已售xxx%
  String get sellText {
    double sealsRatio100 = sellRatio * 100;
    if (sealsRatio100 <= 0) {
      return "  已售0%";
    }
    return "  已售" + sealsRatio100.ceil().toString() + "%";
  }
  /// 已抢xxx件
  String get sellCountText {
    if (spuSalesCount != null && spuSalesCount > 0) {
      return "  已抢$spuSalesCount件";
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
          isSub: json["isSub"]);
}