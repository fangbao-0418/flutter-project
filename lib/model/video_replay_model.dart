class VideoReplayModel {
  LiveInfoBean liveInfo;
  StatisticsBean statistics;

  VideoReplayModel({this.liveInfo, this.statistics});

  VideoReplayModel.fromJson(Map<String, dynamic> json) {    
    this.liveInfo = json['liveInfo'] != null ? LiveInfoBean.fromJson(json['liveInfo']) : null;
    this.statistics = json['statistics'] != null ? StatisticsBean.fromJson(json['statistics']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.liveInfo != null) {
      data['liveInfo'] = this.liveInfo.toJson();
    }
    if (this.statistics != null) {
      data['statistics'] = this.statistics.toJson();
    }
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
  String stopMessage;
  int id;
  int anchorId;
  int liveType;
  int status;
  int liveTop;
  int bizType;
  int masterProductId;
  num startTime;
  num endTime;
  List<int> labelIds;
  List<String> labels;
  List<int> productIds;

  LiveInfoBean({this.liveCover, this.title, this.bulletin, this.liveDecals, this.couponCodes, this.openShare, this.shareIcon, this.hasRedEnvelope, this.liveRedEnvelopeInfo, this.stopMessage, this.id, this.anchorId, this.liveType, this.status, this.liveTop, this.bizType, this.masterProductId, this.startTime, this.endTime, this.labelIds, this.labels, this.productIds});

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
    this.stopMessage = json['stopMessage'];
    this.id = json['id'];
    this.anchorId = json['anchorId'];
    this.liveType = json['liveType'];
    this.status = json['status'];
    this.liveTop = json['liveTop'];
    this.bizType = json['bizType'];
    this.masterProductId = json['masterProductId'];
    this.startTime = json['startTime'];
    this.endTime = json['endTime'];

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
    data['stopMessage'] = this.stopMessage;
    data['id'] = this.id;
    data['anchorId'] = this.anchorId;
    data['liveType'] = this.liveType;
    data['status'] = this.status;
    data['liveTop'] = this.liveTop;
    data['bizType'] = this.bizType;
    data['masterProductId'] = this.masterProductId;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['labelIds'] = this.labelIds;
    data['labels'] = this.labels;
    data['productIds'] = this.productIds;
    return data;
  }
}

class StatisticsBean {
  int popularity;
  int love;
  int liveDuration;
  int orderedCount;
  int orderedAccount;
  int shopOrderedAccount;

  StatisticsBean({this.popularity, this.love, this.liveDuration, this.orderedCount, this.orderedAccount, this.shopOrderedAccount});

  StatisticsBean.fromJson(Map<String, dynamic> json) {    
    this.popularity = json['popularity'];
    this.love = json['love'];
    this.liveDuration = json['liveDuration'];
    this.orderedCount = json['orderedCount'];
    this.orderedAccount = json['orderedAccount'];
    this.shopOrderedAccount = json['shopOrderedAccount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['popularity'] = this.popularity;
    data['love'] = this.love;
    data['liveDuration'] = this.liveDuration;
    data['orderedCount'] = this.orderedCount;
    data['orderedAccount'] = this.orderedAccount;
    data['shopOrderedAccount'] = this.shopOrderedAccount;
    return data;
  }
}
