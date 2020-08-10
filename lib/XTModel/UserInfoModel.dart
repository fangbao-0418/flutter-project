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

  int id; //用户ID
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
        memberType: json["memberType"],
        memberTypeLevel: json["memberTypeLevel"],
        memberTypeTime: json["memberTypeTime"],
        parentMemberId: json["parentMemberId"],
        headImage: json["headImage"],
        nickName: json["nickName"],
        wechat: json["wechat"],
        userName: json["userName"],
        money: json["money"],
        count: json["count"],
        idCard: json["idCard"],
        canAuthen: json["canAuthen"],
        inviteMemberVo: InviteMemberVo.fromJson(json["inviteMemberVO"]),
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
  int isUpdateInvite;
  int updateInviteTime;

  factory InviteMemberVo.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return InviteMemberVo();
    }
    return InviteMemberVo(
      id: json["id"],
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
