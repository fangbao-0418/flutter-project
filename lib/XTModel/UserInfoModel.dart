// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

class UserInfoModel {
  UserInfoModel({
    this.id,
    this.phone,
    this.memberType,
    this.memberTypeLevel,
    this.memberTypeTime,
    this.parentMemberId,
    this.headImage,
    this.nickName,
    this.wechat,
    this.userName,
    this.money,
    this.count,
    this.idCard,
    this.canAuthen,
    this.inviteMemberVo,
    this.fansType,
    this.lockFansTime,
    this.tradeLockPowderTime,
    this.identity,
    this.limitDay,
    this.allEarnings,
  });

  String id; //用户ID
  String phone; //手机号
  int memberType; //类型
  int memberTypeLevel;
  int memberTypeTime;
  int parentMemberId; //上层ID
  String headImage = ""; //头像
  String nickName; //昵称
  String wechat; //微信
  String userName; //用户名
  int money;
  int count;
  String idCard;
  bool canAuthen;
  InviteMemberVo inviteMemberVo;
  int fansType;
  int lockFansTime;
  int tradeLockPowderTime;
  String identity;
  int limitDay;
  int allEarnings;

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => UserInfoModel(
        id: json["id"],
        phone: json["phone"],
        memberType: int.parse(json["memberType"]),
        memberTypeLevel: json["memberTypeLevel"],
        memberTypeTime: json["memberTypeTime"],
        parentMemberId: json["parentMemberId"],
        headImage: json["headImage"],
        nickName: json["nickName"],
        wechat: json["wechat"],
        userName: json["userName"],
        money: json["money"],
        count: json["count"],
        idCard: json["idCard"].toString().trim(),
        canAuthen: json["canAuthen"],
        inviteMemberVo:
            InviteMemberVo.fromJson(Map.from(json["inviteMemberVO"])),
        fansType: json["fansType"],
        lockFansTime: json["lockFansTime"],
        tradeLockPowderTime: json["tradeLockPowderTime"],
        identity: json["identity"],
        limitDay: json["limitDay"],
        allEarnings: json["allEarnings"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "phone": phone,
        "memberType": memberType,
        "memberTypeLevel": memberTypeLevel,
        "memberTypeTime": memberTypeTime,
        "parentMemberId": parentMemberId,
        "headImage": headImage,
        "nickName": nickName,
        "wechat": wechat,
        "userName": userName,
        "money": money,
        "count": count,
        "idCard": idCard,
        "canAuthen": canAuthen,
        "inviteMemberVO": inviteMemberVo.toJson(),
        "fansType": fansType,
        "lockFansTime": lockFansTime,
        "tradeLockPowderTime": tradeLockPowderTime,
        "identity": identity,
        "limitDay": limitDay,
        "allEarnings": allEarnings,
      };
}

class InviteMemberVo {
  InviteMemberVo({
    this.id,
    this.name,
    this.headImage,
    this.inviteCount,
    this.joinTime,
    this.memberType,
    this.memberTypeLevel,
    this.isUpdateInvite,
    this.updateInviteTime,
  });

  int id;
  String name;
  String headImage;
  int inviteCount;
  String joinTime;
  int memberType;
  int memberTypeLevel;
  bool isUpdateInvite;
  int updateInviteTime;

  factory InviteMemberVo.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return InviteMemberVo();
    }
    return InviteMemberVo(
      id: int.parse(json["id"]),
      name: json["name"],
      headImage: json["headImage"],
      inviteCount: json["inviteCount"],
      joinTime: json["joinTime"],
      memberType: json["memberType"],
      memberTypeLevel: json["memberTypeLevel"],
      isUpdateInvite: json["isUpdateInvite"],
      updateInviteTime: json["updateInviteTime"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "headImage": headImage,
        "inviteCount": inviteCount,
        "joinTime": joinTime,
        "memberType": memberType,
        "memberTypeLevel": memberTypeLevel,
        "isUpdateInvite": isUpdateInvite,
        "updateInviteTime": updateInviteTime,
      };
}

class AddressListModel {
  AddressListModel(
      {this.address,
      this.city,
      this.cityId,
      this.consignee,
      this.defaultAddress,
      this.district,
      this.districtId,
      this.freight,
      this.id,
      this.memberId,
      this.phone,
      this.province,
      this.provinceId,
      this.street});

  String address;

  /// 完整地址
  String city;

  /// 城市
  int cityId;

  /// 城市id
  String consignee;

  /// 姓名
  int defaultAddress;

  /// 是否默认地址
  String district;

  /// 地区
  int districtId;

  /// 地区id
  int freight;
  int id;

  /// 地址id
  int memberId;

  /// 会员id
  String phone;

  /// 手机号
  String province;

  /// 省名称
  int provinceId;

  /// 省id
  String street;

  /// 具体地址

  factory AddressListModel.fromJson(Map<String, dynamic> json) =>
      AddressListModel(
        address: json["address"],
        city: json["city"],
        cityId: json["cityId"],
        consignee: json["consignee"],
        defaultAddress: json["defaultAddress"],
        district: json["district"],
        districtId: json["districtId"],
        freight: json["freight"],
        id: json["id"],
        memberId: json["memberId"],
        phone: json["phone"],
        province: json["province"],
        provinceId: json["provinceId"],
        street: json["street"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "city": city,
        "cityId": cityId,
        "consignee": consignee,
        "defaultAddress": defaultAddress,
        "district": district,
        "districtId": districtId,
        "freight": freight,
        "memberId": memberId,
        "phone": phone,
        "province": province,
        "provinceId": provinceId,
        "street": street,
      };
}


class AlipayAccountModel {

  AlipayAccountModel({
    this.memberId,
    this.accountNumber,
    this.accountUserName
  });

  String memberId;
  String accountUserName;
  String accountNumber;

  factory AlipayAccountModel.fromJson(Map<String, dynamic> json) => AlipayAccountModel(
    memberId: json["memberId"],
    accountUserName: json["accountUserName"],
    accountNumber: json["accountNumber"]
  );

  Map<String, dynamic> toJson() => {
    "memberId": memberId,
    "accountUserName": accountUserName,
    "accountNumber": accountNumber
  };
}

class WechatInfoModel {

  WechatInfoModel({
    this.wechat,
    this.wxQr,
  });

  String wechat;
  String wxQr;

  factory WechatInfoModel.fromJson(Map<String, dynamic> json) => WechatInfoModel(
    wechat: json["wechat"],
    wxQr: json["wxQr"]
  );

  Map<String, dynamic> toJson() => {
    "wechat": wechat,
    "wxQr": wxQr
  };
}