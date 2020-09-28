import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:xtflutter/config/app_config/color_config.dart';
import 'package:xtflutter/r.dart';

enum CouponItemStyleType {
  /// 一行一个
  rowOne,
  /// 一行二个
  rowTwo,
  /// 一行三个
  rowThree,
}

enum CouponStatusType {
  /// 立即领取
  normal,
  /// 已领取
  geted,
  /// 已领完
  gone
}

/// 优惠券样式配置model
class CouponItemConfigModel {
  CouponItemConfigModel({this.couponStyle, this.selectColor, this.styleType});

  int couponStyle;
  int styleType;
  int selectColor;

  factory CouponItemConfigModel.fromJson(Map<String, dynamic> json) {
    return CouponItemConfigModel(
      couponStyle: json["couponStyle"] == null ? 2 : json["couponStyle"],
      selectColor: json["selectColor"] == null ? 0 : json["selectColor"],
      styleType: json["styleType"] == null ? 1 : json["styleType"],
    );
  }

  Map<String, dynamic> toJson() => {
    "couponStyle": couponStyle,
    "styleType": styleType,
    "selectColor": selectColor,
  };

  Color get bgColor {
    return couponStyle == 2 ? Colors.orange : mainF5GrayColor;
  }

  CouponStatusType _statusType;
  CouponStatusType get statusType => _statusType;
  void setStatusType(CouponStatusType type) {
    this._statusType = type;
  }

  /// 自定义属性
  /// 样式类型
  CouponItemStyleType get style {
    switch (styleType) {
      case 1:
        return CouponItemStyleType.rowOne;
        break;
      case 2:
        return CouponItemStyleType.rowTwo;
        break;
      case 3:
        return CouponItemStyleType.rowThree;
        break;
      default:
        return CouponItemStyleType.rowOne;
    }
  }

  /// 单个item高度
  double itemWidth(BuildContext ctx) {
    final width = MediaQuery.of(ctx).size.width;
    switch (style) {
      case CouponItemStyleType.rowOne:
        return width - 24;
        break;
      case CouponItemStyleType.rowTwo:
        return (width - 24 - 3) / 2;
        break;
      case CouponItemStyleType.rowThree:
        return (width - 24 - 6) / 3;
        break;
      default:
        return 0.0;
    }
  }

  /// 高度
  double gridHeight(int count, BuildContext ctx) {
    switch (style) {
      case CouponItemStyleType.rowOne:
        double itemHeight = itemWidth(ctx) / childRatio;
        return count * itemHeight + (count - 1) * 8 + 8;
        break;
      case CouponItemStyleType.rowTwo:
        double itemHeight = itemWidth(ctx) / childRatio;
        return (count / 2).ceil() * itemHeight +
            ((count / 2).ceil() - 1) * 8 +
            8;
        break;
      case CouponItemStyleType.rowThree:
        double itemHeight = itemWidth(ctx) / childRatio;
        return (count / 3).ceil() * itemHeight +
            ((count / 3).ceil() - 1) * 8 +
            8;
        break;
      default:
        return 0.0;
    }
  }

  /// 横向间隔
  double get crossAxisSpacing {
    switch (style) {
      case CouponItemStyleType.rowOne:
        return 0.0;
        break;
      case CouponItemStyleType.rowTwo:
      case CouponItemStyleType.rowThree:
        return 3.0;
        break;
      default:
        return 0.0;
    }
  }

  /// 宽高比
  double get childRatio {
    switch (style) {
      case CouponItemStyleType.rowOne:
        return 351 / 96;
        break;
      case CouponItemStyleType.rowTwo:
        return 174 / 64;
        break;
      case CouponItemStyleType.rowThree:
        return 115 / 96;
        break;
      default:
        return 1;
    }
  }

  /// 优惠券背景图片
  String get getBgImgName {
    if (couponStyle == 1) {
      /// 自定义样式
      switch (style) {
        case CouponItemStyleType.rowOne:
          if (statusType == CouponStatusType.gone) {
            return "images/Coupon/coupon_bg_one_color_gone$selectColor.png";
          } else if (statusType == CouponStatusType.geted) {
            return "images/Coupon/coupon_bg_one_color_get$selectColor.png";
          } else {
            return "images/Coupon/coupon_bg_one_color$selectColor.png";
          }
          break;
        case CouponItemStyleType.rowTwo:
          if (statusType == CouponStatusType.gone) {
            return "images/Coupon/coupon_bg_two_color_gone$selectColor.png";
          } else {
            return "images/Coupon/coupon_bg_two_color$selectColor.png";
          }
          break;
        case CouponItemStyleType.rowThree:
          if (statusType == CouponStatusType.gone) {
            return "images/Coupon/coupon_bg_three_color_gone$selectColor.png";
          } else {
            return "images/Coupon/coupon_bg_three_color$selectColor.png";
          }
          break;
        default:
          return "";
      }
    } else {
      /// 默认样式
      switch (style) {
        case CouponItemStyleType.rowOne:
          return R.imagesCouponCouponBgOneNone;
          break;
        case CouponItemStyleType.rowTwo:
          return R.imagesCouponCouponBgTwoNone;
          break;
        case CouponItemStyleType.rowThree:
          return R.imagesCouponCouponBgThreeNone;
          break;
        default:
          return "";
      }
    }
  }

  /// 面额颜色
  Color get couponFaceColor {
    if (couponStyle == 2) {
      return statusType == CouponStatusType.gone ? mainCCColor : mainRedColor;
    } else {
      return couponHaveStyleFaceColor;
    }
  }

  /// 满足条件颜色
  Color get couponFaceDescColor {
    if (couponStyle == 2) {
      return statusType == CouponStatusType.gone ? mainCCColor : mainBlackColor;
    } else {
      return couponHaveStyleFaceColor;
    }
  }

  /// couponStyle==1 有样式时面额颜色
  Color get couponHaveStyleFaceColor {
    if (statusType == CouponStatusType.gone) {
      /// 已领完
      switch (selectColor) {
        case 1:
        case 4:
        case 5:
          return main99GrayColor;
          break;
        default:
          return Colors.white;
      }
    } else {
      /// 已领取
      /// 可领
      switch (selectColor) {
        case 1:
          return xtColor_FFFF4D6A;
          break;
        case 4:
        case 5:
          return mainRedColor;
          break;
        default:
          return Colors.white;
      }
    }
  }

  /// 优惠券名称颜色
  Color get couponNameColor {
    if (statusType == CouponStatusType.gone) {
      /// 已领完
      switch (selectColor) {
        case 4:
          return Colors.white;
          break;
        default:
          return main99GrayColor;
      }
    } else {
      /// 已领取
      /// 可领
      switch (selectColor) {
        case 1:
          return xtColor_FFFF4D6A;
          break;
        case 3:
          return xtColor_FF0091FF;
          break;
        case 4:
          return Colors.white;
          break;
        case 6:
          return xtColor_39B54A;
          break;
        default:
          return mainRedColor;
      }
    }
  }

  /// 立即领取按钮颜色
  List<Color> get couponGetNowColors {
    switch (selectColor) {
      case 0:
        return [mainRedColor, Colors.white];
        break;
      case 1:
        return [xtColor_FFFF4D6A, Colors.white];
        break;
      case 2:
        return [xtColor_FFFF4461, xtColor_FFFFED55];
        break;
      case 3:
        return [xtColor_FF0086FA, Colors.white];
        break;
      case 4:
        return [Colors.white, xtColor_FFFF6C22];
        break;
      case 5:
        return [xtColor_FFEE071F, Colors.white];
        break;
      case 6:
        return [xtColor_FF10AC48, Colors.white];
        break;
      default:
        return [];
    }
  }

  /// rowTwo && rowThree模式下 领取状态文案
  String get rowTGetText {
    switch (statusType) {
      case CouponStatusType.gone:
        return "已领完";
        break;
      case CouponStatusType.geted:
        return "已领取";
        break;
      default:
        if (style == CouponItemStyleType.rowThree) {
          return "点击领取";
        } else {
          return "点击\n领取";
        }
    }
  }

  /// rowTwo && rowThree模式下 领取状态文案颜色
  Color get rowTGetTextColor {
    switch (statusType) {
      case CouponStatusType.gone:
        if (couponStyle == 2) {
          /// 无样式
          return mainCCColor;
        }
        if (selectColor == 4) {
          return main66GrayColor;
        } else {
          return main99GrayColor;
        }
        break;
      case CouponStatusType.geted:
        return main66GrayColor;
        break;
      default:
        if (couponStyle == 2) {
          /// 无样式
          return mainRedColor;
        } else {
          return couponNameColor;
        }
    }
  }
}

/// 优惠券样式数据model
class CouponItemDataModel {
  static CouponItemDataModel getData() =>
      CouponItemDataModel.fromJson(couponData);

  CouponItemDataModel({
    this.id,
    this.couponId,
    this.code,
    this.name,
    this.describe,
    this.remark,
    this.avlRange,
    this.avlValues,
    this.useSill,
    this.faceValueRestrict,
    this.faceValue,
    this.faceValueDesc,
    this.receiveRestrict,
    this.platformRestrict,
    this.startReceiveTime,
    this.overReceiveTime,
    this.useTime,
    this.startUseTime,
    this.overUseTime,
    this.status,
    this.displayStyle,
    this.receivePattern,
    this.businessPlatform,
    this.platformType,
    this.platformShopId,
    this.couponTypeDesc,
    this.curTm,
    this.received,
    this.stock,
  });

  int id;
  int couponId;
  String code;
  String name;
  dynamic describe;
  String remark;
  int avlRange;
  String avlValues;
  int useSill;
  dynamic faceValueRestrict;
  String faceValue;
  String faceValueDesc;
  String receiveRestrict;
  String platformRestrict;
  int startReceiveTime;
  int overReceiveTime;
  dynamic useTime;
  dynamic startUseTime;
  dynamic overUseTime;
  int status;
  dynamic displayStyle;
  int receivePattern;
  int businessPlatform;
  int platformType;
  dynamic platformShopId;
  String couponTypeDesc;
  int curTm;
  bool received;
  int stock;

  factory CouponItemDataModel.fromJson(Map<String, dynamic> json) {
    return CouponItemDataModel(
      id: json["id"],
      couponId: json["couponId"],
      code: json["code"],
      name: json["name"],
      describe: json["describe"],
      remark: json["remark"],
      avlRange: json["avlRange"],
      avlValues: json["avlValues"],
      useSill: json["useSill"],
      faceValueRestrict: json["faceValueRestrict"],
      faceValue: json["faceValue"],
      faceValueDesc: json["faceValueDesc"],
      receiveRestrict: json["receiveRestrict"],
      platformRestrict: json["platformRestrict"],
      startReceiveTime: json["startReceiveTime"],
      overReceiveTime: json["overReceiveTime"],
      useTime: json["useTime"],
      startUseTime: json["startUseTime"],
      overUseTime: json["overUseTime"],
      status: json["status"],
      displayStyle: json["displayStyle"],
      receivePattern: json["receivePattern"],
      businessPlatform: json["businessPlatform"],
      platformType: json["platformType"],
      platformShopId: json["platformShopId"],
      couponTypeDesc: json["couponTypeDesc"],
      curTm: json["curTm"],
      received: json["received"],
      stock: json["stock"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "couponId": couponId,
        "code": code,
        "name": name,
        "describe": describe,
        "remark": remark,
        "avlRange": avlRange,
        "avlValues": avlValues,
        "useSill": useSill,
        "faceValueRestrict": faceValueRestrict,
        "faceValue": faceValue,
        "faceValueDesc": faceValueDesc,
        "receiveRestrict": receiveRestrict,
        "platformRestrict": platformRestrict,
        "startReceiveTime": startReceiveTime,
        "overReceiveTime": overReceiveTime,
        "useTime": useTime,
        "startUseTime": startUseTime,
        "overUseTime": overUseTime,
        "status": status,
        "displayStyle": displayStyle,
        "receivePattern": receivePattern,
        "businessPlatform": businessPlatform,
        "platformType": platformType,
        "platformShopId": platformShopId,
        "couponTypeDesc": couponTypeDesc,
        "curTm": curTm,
        "received": received,
        "stock": stock,
      };

  /// 自定义参数
  /// 优惠券状态
  CouponStatusType get statusType {
    if (received) {
      return CouponStatusType.geted;
    } else if (stock <= 0) {
      return CouponStatusType.gone;
    }
    switch (status) {
      case 1:
        return CouponStatusType.normal;
        break;
      case 2:
        return CouponStatusType.gone;
        break;
      default:
        return CouponStatusType.normal;
    }
  }

  /// 获取优惠券金额
  String get couponFaceValue {
    List<String> valueList = faceValue.split(":");
    return MoneyUtil.changeFStr2YWithUnit(valueList.last,
        format: MoneyFormat.END_INTEGER);
  }

  /// 获取优惠券满多少金额 （满xxx元可用）
  String get couponAllValue {
    List<String> valueList = faceValue.split(":");
    String allMoeny = MoneyUtil.changeFStr2YWithUnit(valueList.first,
        format: MoneyFormat.END_INTEGER);
    return "满$allMoeny元可用";
  }
}

/// ----------------------------------------- 测试 -----------------------------------------

/// 测试数据model
class CouponModel {
  static CouponModel getData() => CouponModel.fromJson(couponData);
  static List<CouponItemDataModel> getDataLis() =>
      List<CouponItemDataModel>.from(
          couponDataList.map((e) => CouponItemDataModel.fromJson(e)));
  CouponModel({this.dataList});
  List<CouponItemModel> dataList;
  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
        dataList: List<CouponItemModel>.from(
            json["dataList"].map((e) => CouponItemModel.fromJson(e))));
  }
}

///
class CouponItemModel {
  CouponItemModel({
    this.config,
  });

  CouponItemConfigModel config;

  factory CouponItemModel.fromJson(Map<String, dynamic> json) {
    return CouponItemModel(
        config: CouponItemConfigModel.fromJson(json["config"]));
  }
}

const Map<String, dynamic> couponData = {
  "dataList": [
    {
      "config": {"couponStyle": 1, "styleType": 1, "selectColor": 0},
    },
    {
      "config": {"couponStyle": 1, "styleType": 2, "selectColor": 0},
    },
    {
      "config": {"couponStyle": 1, "styleType": 3, "selectColor": 0},
    },
    {
      "config": {"couponStyle": 1, "styleType": 1, "selectColor": 1},
    },
    {
      "config": {"couponStyle": 1, "styleType": 2, "selectColor": 1},
    },
    {
      "config": {"couponStyle": 1, "styleType": 3, "selectColor": 1},
    },
    {
      "config": {"couponStyle": 1, "styleType": 1, "selectColor": 2},
    },
    {
      "config": {"couponStyle": 1, "styleType": 2, "selectColor": 2},
    },
    {
      "config": {"couponStyle": 1, "styleType": 3, "selectColor": 2},
    },
    {
      "config": {"couponStyle": 1, "styleType": 1, "selectColor": 3},
    },
    {
      "config": {"couponStyle": 1, "styleType": 2, "selectColor": 3},
    },
    {
      "config": {"couponStyle": 1, "styleType": 3, "selectColor": 3},
    },
    {
      "config": {"couponStyle": 1, "styleType": 1, "selectColor": 4},
    },
    {
      "config": {"couponStyle": 1, "styleType": 2, "selectColor": 4},
    },
    {
      "config": {"couponStyle": 1, "styleType": 3, "selectColor": 4},
    },
    {
      "config": {"couponStyle": 1, "styleType": 1, "selectColor": 5},
    },
    {
      "config": {"couponStyle": 1, "styleType": 2, "selectColor": 5},
    },
    {
      "config": {"couponStyle": 1, "styleType": 3, "selectColor": 5},
    },
    {
      "config": {"couponStyle": 1, "styleType": 1, "selectColor": 6},
    },
    {
      "config": {"couponStyle": 1, "styleType": 2, "selectColor": 6},
    },
    {
      "config": {"couponStyle": 1, "styleType": 3, "selectColor": 6},
    },
    {
      "config": {"couponStyle": 2, "styleType": 1, "selectColor": 6},
    },
    {
      "config": {"couponStyle": 2, "styleType": 2, "selectColor": 6},
    },
    {
      "config": {"couponStyle": 2, "styleType": 3, "selectColor": 6},
    },
  ]
};

const List<Map<String, dynamic>> couponDataList = [
  {
    "code": "hzXHf4CY",
    "id": 1133,
    "couponId": 1133,
    "name": "倪阳指定活动券勿动奥利给卡是空格键拉十多个",
    "faceValue": "30000:4000",
    "faceValueDesc": "满300减40",
    "couponTypeDesc": "自营商品券",
    "status": 1,
  },
  {
    "code": "8eTH7PfR",
    "id": 1132,
    "couponId": 1132,
    "name": "倪阳指定商品券勿动埃里克森按理说看过",
    "faceValue": "30000:3000",
    "faceValueDesc": "满300减30",
    "couponTypeDesc": "自营商品券",
    "status": 3,
  },
  {
    "code": "53iU6agq",
    "id": 1146,
    "couponId": 1146,
    "name": "测试999我打了阿哥AKG华为卡会受到安徽科技馆卡视角读后感氨基酸读后感",
    "faceValue": "2000:1000",
    "faceValueDesc": "满20减10",
    "couponTypeDesc": "自营通用券",
    "status": 2,
  },
];
