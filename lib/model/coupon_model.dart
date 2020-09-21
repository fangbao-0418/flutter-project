// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

CouponModel welcomeFromJson(String str) => CouponModel.fromJson(json.decode(str));

String welcomeToJson(CouponModel data) => json.encode(data.toJson());

class CouponModel {
    CouponModel({
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

    factory CouponModel.fromJson(Map<String, dynamic> json) => CouponModel(
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
}
