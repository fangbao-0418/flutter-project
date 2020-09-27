import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:xtflutter/config/app_config/color_config.dart';
import 'package:xtflutter/r.dart';

enum CouponItemStyleType {
  rowOne,   /// 一行一个
  rowTwo,   /// 一行二个  
  rowThree, /// 一行三个
}

enum CouponStatusType {
  normal,   /// 立即领取
  geted,    /// 已领取
  gone      /// 已领完
}

/// 优惠券样式配置model
class CouponItemConfigModel {

  CouponItemConfigModel({
    this.couponStyle,
    this.selectCorlor,
    this.styleType
  });
  
  int couponStyle;
  int styleType;
  int selectCorlor;

  factory CouponItemConfigModel.fromJson(Map<String, dynamic> json) {
    return CouponItemConfigModel(
      couponStyle: json["couponStyle"],
      selectCorlor: json["selectCorlor"],
      styleType: json["styleType"],
    );
  }

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
        return count * itemHeight + (count - 1) * 8 + 24;
        break;
      case CouponItemStyleType.rowTwo:
        double itemHeight = itemWidth(ctx) / childRatio;
        return (count / 2).ceil() * itemHeight + ((count / 2).ceil() - 1) * 8 + 24;
        break;
      case CouponItemStyleType.rowThree:
        double itemHeight = itemWidth(ctx) / childRatio;
        return (count / 3).ceil() * itemHeight + ((count / 3).ceil() - 1) * 8 + 24;
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
            return "images/Coupon/coupon_bg_one_color_gone$selectCorlor.png";
          } else if (statusType == CouponStatusType.geted) {
            return "images/Coupon/coupon_bg_one_color_get$selectCorlor.png";
          } else {
            return "images/Coupon/coupon_bg_one_color$selectCorlor.png";
          }
          break;
        case CouponItemStyleType.rowTwo:
          if (statusType == CouponStatusType.gone) {
            return "images/Coupon/coupon_bg_two_color_gone$selectCorlor.png";
          } else {
            return "images/Coupon/coupon_bg_two_color$selectCorlor.png";
          }
          break;
        case CouponItemStyleType.rowThree:
          if (statusType == CouponStatusType.gone) {
            return "images/Coupon/coupon_bg_three_color_gone$selectCorlor.png";
          } else {
            return "images/Coupon/coupon_bg_three_color$selectCorlor.png";
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
      return statusType == CouponStatusType.gone ? xtColor_FFCCCCCC : mainRedColor;
    } else {
      return couponHaveStyleFaceColor;
    }
  }
  /// 满足条件颜色
  Color get couponFaceDescColor {
    if (couponStyle == 2) {
      return statusType == CouponStatusType.gone ? xtColor_FFCCCCCC : AppColors.FF333333;
    } else {
      return couponHaveStyleFaceColor;
    }
  }
  /// couponStyle==1 有样式时面额颜色
  Color get couponHaveStyleFaceColor {
    if (statusType == CouponStatusType.gone) {
      /// 已领完
      switch (selectCorlor) {
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
      switch (selectCorlor) {
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
      switch (selectCorlor) {
        case 4:
          return Colors.white;
          break;
        default:
          return main99GrayColor;
      }
    } else {
      /// 已领取
      /// 可领
      switch (selectCorlor) {
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
    switch (selectCorlor) {
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
          return xtColor_FFCCCCCC;
        }
        if (selectCorlor == 4) {
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

  static CouponItemDataModel getData() => CouponItemDataModel.fromJson(couponData);

  CouponItemDataModel({
    this.code,
    this.couponId,
    this.status,
    this.couponTypeDesc,
    this.faceValue,
    this.faceValueDesc,
    this.id,
    this.name,
  });
  
  String code;
  int couponId;
  String couponTypeDesc;
  String faceValue;
  String faceValueDesc;
  int id;
  String name;
  int status;

  factory CouponItemDataModel.fromJson(Map<String, dynamic> json) {
    return CouponItemDataModel(
      code: json["code"],
      couponId: json["couponId"],
      couponTypeDesc: json["couponTypeDesc"],
      faceValue: json["faceValue"],
      faceValueDesc: json["faceValueDesc"],
      id: json["id"],
      name: json["name"],
      status: json["status"],
    );
  }

  /// 自定义参数
  /// 优惠券状态
  CouponStatusType get statusType {
    switch (status) {
      case 1:
        return CouponStatusType.normal;
        break;
      case 2:
        return CouponStatusType.gone;
        break;
      case 3:
        return CouponStatusType.geted;
        break;
      default:
        return CouponStatusType.normal;
    }
  }
  /// 获取优惠券金额
  String get couponFaceValue {
    List<String> valueList = faceValue.split(":");
    return MoneyUtil.changeFStr2YWithUnit(valueList.last, format: MoneyFormat.END_INTEGER);
  }
  /// 获取优惠券满多少金额 （满xxx元可用）
  String get couponAllValue {
    List<String> valueList = faceValue.split(":");
    String allMoeny = MoneyUtil.changeFStr2YWithUnit(valueList.first, format: MoneyFormat.END_INTEGER);
    return "满$allMoeny元可用";
  }

}


/// ----------------------------------------- 测试 -----------------------------------------

/// 测试数据model
class CouponModel {
  static CouponModel getData() => CouponModel.fromJson(couponData);
  static List<CouponItemDataModel> getDataLis() => List<CouponItemDataModel>.from(couponDataList.map((e) => CouponItemDataModel.fromJson(e)));
  CouponModel({this.dataList});
  List<CouponItemModel> dataList;
  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      dataList: List<CouponItemModel>.from(json["dataList"].map((e) => CouponItemModel.fromJson(e)))
    );
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
      config: CouponItemConfigModel.fromJson(json["config"])
    );
  }

}


const Map<String, dynamic> couponData = {
  "dataList": [
    {
      "config": {
        "couponStyle": 1,
        "styleType": 1,
        "selectCorlor": 0
      },
    },
    {
      "config": {
        "couponStyle": 1,
        "styleType": 2,
        "selectCorlor": 0
      },
    },
    {
      "config": {
        "couponStyle": 1,
        "styleType": 3,
        "selectCorlor": 0
      },
    },
    {
      "config": {
        "couponStyle": 1,
        "styleType": 1,
        "selectCorlor": 1
      },
    },
    {
      "config": {
        "couponStyle": 1,
        "styleType": 2,
        "selectCorlor": 1
      },
    },
    {
      "config": {
        "couponStyle": 1,
        "styleType": 3,
        "selectCorlor": 1
      },
    },
    {
      "config": {
        "couponStyle": 1,
        "styleType": 1,
        "selectCorlor": 2
      },
    },
    {
      "config": {
        "couponStyle": 1,
        "styleType": 2,
        "selectCorlor": 2
      },
    },
    {
      "config": {
        "couponStyle": 1,
        "styleType": 3,
        "selectCorlor": 2
      },
    },
    {
      "config": {
        "couponStyle": 1,
        "styleType": 1,
        "selectCorlor": 3
      },
    },
    {
      "config": {
        "couponStyle": 1,
        "styleType": 2,
        "selectCorlor": 3
      },
    },
    {
      "config": {
        "couponStyle": 1,
        "styleType": 3,
        "selectCorlor": 3
      },
    },
    {
      "config": {
        "couponStyle": 1,
        "styleType": 1,
        "selectCorlor": 4
      },
    },
    {
      "config": {
        "couponStyle": 1,
        "styleType": 2,
        "selectCorlor": 4
      },
    },
    {
      "config": {
        "couponStyle": 1,
        "styleType": 3,
        "selectCorlor": 4
      },
    },
    {
      "config": {
        "couponStyle": 1,
        "styleType": 1,
        "selectCorlor": 5
      },
    },
    {
      "config": {
        "couponStyle": 1,
        "styleType": 2,
        "selectCorlor": 5
      },
    },
    {
      "config": {
        "couponStyle": 1,
        "styleType": 3,
        "selectCorlor": 5
      },
    },
    {
      "config": {
        "couponStyle": 1,
        "styleType": 1,
        "selectCorlor": 6
      },
    },
    {
      "config": {
        "couponStyle": 1,
        "styleType": 2,
        "selectCorlor": 6
      },
    },
    {
      "config": {
        "couponStyle": 1,
        "styleType": 3,
        "selectCorlor": 6
      },
    },
    {
      "config": {
        "couponStyle": 2,
        "styleType": 1,
        "selectCorlor": 6
      },
    },
    {
      "config": {
        "couponStyle": 2,
        "styleType": 2,
        "selectCorlor": 6
      },
    },
    {
      "config": {
        "couponStyle": 2,
        "styleType": 3,
        "selectCorlor": 6
      },
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