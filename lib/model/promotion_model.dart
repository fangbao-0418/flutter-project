// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

import 'package:xtflutter/model/coupon_model.dart';
import 'package:xtflutter/model/goods_model.dart';

class PromotionData {
  PromotionData({
    this.recordId,
    this.startTime,
    this.endTime,
    this.componentVoList,
    this.countDownMills,
  });

  int recordId;
  String startTime;
  String endTime;
  List<ComponentVoList> componentVoList;
  int countDownMills;

  factory PromotionData.fromJson(Map<String, dynamic> json) => PromotionData(
        recordId: json["recordId"],
        startTime: json["startTime"],
        endTime: json["endTime"],
        componentVoList: List<ComponentVoList>.from(json["componentVOList"]
            .map((x) => ComponentVoList.fromJson(Map.from(x)))),
        countDownMills: json["countDownMills"],
      );

  Map<String, dynamic> toJson() => {
        "recordId": recordId,
        "startTime": startTime,
        "endTime": endTime,
        "componentVOList":
            List<dynamic>.from(componentVoList.map((x) => x.toJson())),
        "countDownMills": countDownMills,
      };
}

class ComponentVoList {

  ComponentVoList({
    this.id,
    this.type,
    this.childType,
    this.bizType,
    this.config,
    this.data,
    this.dataTotal,
    this.userLevel,
    this.platform,
    this.isAuchor,
    this.auchorName,
    this.couponConfig,
    this.goodsConfig
  });

  int id;
  String type;
  int childType;
  int bizType;
  Config config;
  List<Datum> data;
  int dataTotal;
  List<String> userLevel;
  List<String> platform;
  bool isAuchor;
  String auchorName;
  CouponItemConfigModel couponConfig;
  GoodsItemConfigModel goodsConfig;

  factory ComponentVoList.fromJson(Map<String, dynamic> json) =>
      ComponentVoList(
        id: json["id"],
        type: json["type"],
        childType: json["childType"],
        bizType: json["bizType"] == null ? null : json["bizType"],
        config: Config.fromJson(json["config"]),
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        dataTotal: json["dataTotal"],
        userLevel: List<String>.from(json["userLevel"].map((x) => x)),
        platform: List<String>.from(json["platform"].map((x) => x)),
        isAuchor: json["isAuchor"],
        auchorName: json["auchorName"],
        couponConfig: CouponItemConfigModel.fromJson(json["config"]),
        goodsConfig: GoodsItemConfigModel.fromJson(json["config"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "childType": childType,
        "bizType": bizType == null ? null : bizType,
        "config": config.toJson(),
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
        "dataTotal": dataTotal,
        "userLevel": List<dynamic>.from(userLevel.map((x) => x)),
        "platform": List<dynamic>.from(platform.map((x) => x)),
        "isAuchor": isAuchor,
        "auchorName": auchorName,
        "couponConfig": couponConfig.toJson(),
        "goodsConfig": goodsConfig.toJson()
      };
}

class Config {
  Config({
    this.bgColor,
    this.videoUrl,
    this.backgroundColor,
    this.title,
    this.styleType,
    this.padding,
    this.fontColorSelect,
    this.fontColor,
    this.goodsStyleType,
    this.type,
    this.buttonBgColor,
    this.data,
  });
  String backgroundColor;
  String videoUrl;
  String bgColor;
  String title;
  int styleType;
  List<String> padding;
  String fontColorSelect;
  String fontColor;
  int goodsStyleType;
  int type;
  String buttonBgColor;
  ConfigData data;

  factory Config.fromJson(Map<String, dynamic> json) => Config(
        videoUrl: json["videoUrl"] == null ? null : json["videoUrl"],
        bgColor: json["bgColor"] == null ? null : json["bgColor"],
        backgroundColor:
            json["backgroundColor"] == null ? null : json["backgroundColor"],
        title: json["title"] == null ? null : json["title"],
        styleType: json["styleType"] == null ? null : json["styleType"],
        padding: json["padding"] == null
            ? null
            : List<String>.from(json["padding"].map((x) => x)),
        fontColorSelect:
            json["fontColorSelect"] == null ? null : json["fontColorSelect"],
        fontColor: json["fontColor"] == null ? null : json["fontColor"],
        goodsStyleType:
            json["goodsStyleType"] == null ? null : json["goodsStyleType"],
        type: json["type"] == null ? null : json["type"],
        buttonBgColor:
            json["buttonBgColor"] == null ? null : json["buttonBgColor"],
        data: json["data"] == null ? null : ConfigData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "videoUrl": videoUrl == null ? null : videoUrl,
        "bgColor": bgColor == null ? null : bgColor,
        "backgroundColor": bgColor == null ? null : backgroundColor,
        "title": title == null ? null : title,
        "styleType": styleType == null ? null : styleType,
        "padding":
            padding == null ? null : List<dynamic>.from(padding.map((x) => x)),
        "fontColorSelect": fontColorSelect == null ? null : fontColorSelect,
        "fontColor": fontColor == null ? null : fontColor,
        "goodsStyleType": goodsStyleType == null ? null : goodsStyleType,
        "type": type == null ? null : type,
        "buttonBgColor": buttonBgColor == null ? null : buttonBgColor,
        "data": data == null ? null : data.toJson(),
      };
}

class ConfigData {
  ConfigData({
    this.posterTitle,
    this.icon,
    this.title,
    this.poster,
  });

  String posterTitle;
  String icon;
  String title;
  String poster;

  factory ConfigData.fromJson(Map<String, dynamic> json) => ConfigData(
        posterTitle: json["posterTitle"],
        icon: json["icon"],
        title: json["title"],
        poster: json["poster"],
      );

  Map<String, dynamic> toJson() => {
        "posterTitle": posterTitle,
        "icon": icon,
        "title": title,
        "poster": poster,
      };
}

class Datum {
  Datum({
    this.img,
    this.title,
    this.type,
    this.url,
    this.area,
  });

  String img;
  String title;
  int type;
  String url;
  List<Area> area;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        img: json["img"] == null ? null : json["img"],
        title: json["title"] == null ? null : json["title"],
        type: json["type"] == null ? null : json["type"],
        url: json["url"].toString(),
        area: json["area"] == null
            ? null
            : List<Area>.from(json["area"].map((x) => Area.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "img": img == null ? null : img,
        "title": title == null ? null : title,
        "type": type == null ? null : type,
        "url": url,
        "area": area == null
            ? null
            : List<dynamic>.from(area.map((x) => x.toJson())),
      };
}

class Area {
  Area({
    this.coordinate,
    this.code,
    this.type,
    this.value,
  });

  String coordinate;
  String code;
  int type;
  String value;

  factory Area.fromJson(Map<String, dynamic> json) => Area(
        coordinate: json["coordinate"],
        code: json["code"],
        type: json["type"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "coordinate": coordinate,
        "code": code,
        "type": type,
        "value": value,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
