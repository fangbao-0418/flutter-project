// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';


class MagicData {
    MagicData({
        this.list,
    });

    List<ListElement> list;

    factory MagicData.fromJson(Map<String, dynamic> json) => MagicData(
        list: List<ListElement>.from(json["list"].map((x) => ListElement.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
    };
}

class ListElement {
    ListElement({
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
    int groupMostEarn;
    dynamic groupMarketPrice;
    int remainInventory;
    int inventory;
    int mostEarn;
    int productSaleCount;
    String tagUrl;
    int tagPosition;
    int showNum;
    int type;
    int shopType;
    int promotionId;
    int promotionType;
    int promotionStartTime;
    int promotionEndTime;
    int canAddCart;
    int showCoupon;

    factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
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
        tagUrl: json["tagUrl"],
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
}
