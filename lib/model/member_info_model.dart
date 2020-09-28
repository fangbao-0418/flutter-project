class MemberInfoModel {
  String headImage;
  String userName;
  String nickName;
  bool isFocus;
  bool isAnchor;
  bool isSelf;
  int fansTotal;
  int focusTotal;
  int likeTotal;
  num contextTime;
  AnchorBean anchor;

  MemberInfoModel({this.headImage, this.userName, this.nickName, this.isFocus, this.isAnchor, this.isSelf, this.fansTotal, this.focusTotal, this.likeTotal, this.contextTime, this.anchor});

  MemberInfoModel.fromJson(Map<String, dynamic> json) {    
    this.headImage = json['headImage'];
    this.userName = json['userName'];
    this.nickName = json['nickName'];
    this.isFocus = json['isFocus'];
    this.isAnchor = json['isAnchor'];
    this.isSelf = json['isSelf'];
    this.fansTotal = json['fansTotal'];
    this.focusTotal = json['focusTotal'];
    this.likeTotal = json['likeTotal'];
    this.contextTime = json['contextTime'];
    this.anchor = json['anchor'] != null ? AnchorBean.fromJson(json['anchor']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['headImage'] = this.headImage;
    data['userName'] = this.userName;
    data['nickName'] = this.nickName;
    data['isFocus'] = this.isFocus;
    data['isAnchor'] = this.isAnchor;
    data['isSelf'] = this.isSelf;
    data['fansTotal'] = this.fansTotal;
    data['focusTotal'] = this.focusTotal;
    data['likeTotal'] = this.likeTotal;
    data['contextTime'] = this.contextTime;
    if (this.anchor != null) {
      data['anchor'] = this.anchor.toJson();
    }
    return data;
  }

}

class AnchorBean {
  int id;
  int status;
  int type;

  AnchorBean({this.id, this.status, this.type});

  AnchorBean.fromJson(Map<String, dynamic> json) {    
    this.id = json['id'];
    this.status = json['status'];
    this.type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['type'] = this.type;
    return data;
  }
}
