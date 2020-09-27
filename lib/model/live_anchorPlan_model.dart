class LiveAnchorPlanModel {
  AnchorBean anchor;
  LiveInfoBean liveInfo;
  StatisticsBean statistics;

  LiveAnchorPlanModel({this.anchor, this.liveInfo, this.statistics});

  LiveAnchorPlanModel.fromJson(Map<String, dynamic> json) {    
    this.anchor = json['anchor'] != null ? AnchorBean.fromJson(json['anchor']) : null;
    this.liveInfo = json['liveInfo'] != null ? LiveInfoBean.fromJson(json['liveInfo']) : null;
    this.statistics = json['statistics'] != null ? StatisticsBean.fromJson(json['statistics']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.anchor != null) {
      data['anchor'] = this.anchor.toJson();
    }
    if (this.liveInfo != null) {
      data['liveInfo'] = this.liveInfo.toJson();
    }
    if (this.statistics != null) {
      data['statistics'] = this.statistics.toJson();
    }
    return data;
  }

}

class AnchorBean {
  String nickName;
  String label;
  String coverUrl;
  int id;
  int level;
  int type;
  int fansNum;
  int bizScope;

  AnchorBean({this.nickName, this.label, this.coverUrl, this.id, this.level, this.type, this.fansNum, this.bizScope});

  AnchorBean.fromJson(Map<String, dynamic> json) {    
    this.nickName = json['nickName'];
    this.label = json['label'];
    this.coverUrl = json['coverUrl'];
    this.id = json['id'];
    this.level = json['level'];
    this.type = json['type'];
    this.fansNum = json['fansNum'];
    this.bizScope = json['bizScope'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nickName'] = this.nickName;
    data['label'] = this.label;
    data['coverUrl'] = this.coverUrl;
    data['id'] = this.id;
    data['level'] = this.level;
    data['type'] = this.type;
    data['fansNum'] = this.fansNum;
    data['bizScope'] = this.bizScope;
    return data;
  }
}

class LiveInfoBean {
  String liveCover;
  String title;
  String bulletin;
  String liveDecals;
  String couponCodes;
  String openShare;
  String shareIcon;
  String hasRedEnvelope;
  String liveRedEnvelopeInfo;
  int id;
  int anchorId;
  int liveType;
  int status;
  int liveTop;
  int bizType;
  num startTime;
  List<int> labelIds;
  List<String> labels;
  List<int> productIds;
  bool openNotice = false;//是否开启提醒

  LiveInfoBean({this.liveCover, this.title, this.bulletin, this.liveDecals, this.couponCodes, this.openShare, this.shareIcon, this.hasRedEnvelope, this.liveRedEnvelopeInfo, this.id, this.anchorId, this.liveType, this.status, this.liveTop, this.bizType, this.startTime, this.labelIds, this.labels, this.productIds});

  LiveInfoBean.fromJson(Map<String, dynamic> json) {    
    this.liveCover = json['liveCover'];
    this.title = json['title'];
    this.bulletin = json['bulletin'];
    this.liveDecals = json['liveDecals'];
    this.couponCodes = json['couponCodes'];
    this.openShare = json['openShare'];
    this.shareIcon = json['shareIcon'];
    this.hasRedEnvelope = json['hasRedEnvelope'];
    this.liveRedEnvelopeInfo = json['liveRedEnvelopeInfo'];
    this.id = json['id'];
    this.anchorId = json['anchorId'];
    this.liveType = json['liveType'];
    this.status = json['status'];
    this.liveTop = json['liveTop'];
    this.bizType = json['bizType'];
    this.startTime = json['startTime'];

    List<dynamic> labelIdsList = json['labelIds'];
    this.labelIds = new List();
    this.labelIds.addAll(labelIdsList.map((o) => int.parse(o.toString())));

    List<dynamic> labelsList = json['labels'];
    this.labels = new List();
    this.labels.addAll(labelsList.map((o) => o.toString()));

    List<dynamic> productIdsList = json['productIds'];
    this.productIds = new List();
    this.productIds.addAll(productIdsList.map((o) => int.parse(o.toString())));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['liveCover'] = this.liveCover;
    data['title'] = this.title;
    data['bulletin'] = this.bulletin;
    data['liveDecals'] = this.liveDecals;
    data['couponCodes'] = this.couponCodes;
    data['openShare'] = this.openShare;
    data['shareIcon'] = this.shareIcon;
    data['hasRedEnvelope'] = this.hasRedEnvelope;
    data['liveRedEnvelopeInfo'] = this.liveRedEnvelopeInfo;
    data['id'] = this.id;
    data['anchorId'] = this.anchorId;
    data['liveType'] = this.liveType;
    data['status'] = this.status;
    data['liveTop'] = this.liveTop;
    data['bizType'] = this.bizType;
    data['startTime'] = this.startTime;
    data['labelIds'] = this.labelIds;
    data['labels'] = this.labels;
    data['productIds'] = this.productIds;
    return data;
  }
}

class StatisticsBean {
  int popularity;
  int love;

  StatisticsBean({this.popularity, this.love});

  StatisticsBean.fromJson(Map<String, dynamic> json) {    
    this.popularity = json['popularity'];
    this.love = json['love'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['popularity'] = this.popularity;
    data['love'] = this.love;
    return data;
  }
}
