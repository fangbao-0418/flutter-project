///主播信息模型
class LiveStationAnchorModel {
  LiveStationAnchorModel(
      {this.id,
      this.nickName,
      this.level,
      this.type,
      this.label,
      this.fansNum,
      this.coverUrl,
      this.bizScope});

  int id = 0;
  String nickName = "null";
  int level = 0;
  int type = 0;
  String label = "";
  int fansNum = 0;
  String coverUrl =
      "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1600340832019&di=23b16b29163d4a3571f84c9e09f7c5ee&imgtype=0&src=http%3A%2F%2Fa1.att.hudong.com%2F05%2F00%2F01300000194285122188000535877.jpg";
  int bizScope;

  factory LiveStationAnchorModel.fromJson(Map<String, dynamic> json) {
    return LiveStationAnchorModel(
      id: json["id"],
      nickName: json["nickName"],
      level: json["level"],
      type: json["type"],
      label: json["label"],
      fansNum: json["fansNum"],
      coverUrl: json["coverUrl"],
      bizScope: json["bizScope"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "nickName": nickName,
        "level": level,
        "type": type,
        "label": label,
        "fansNum": fansNum,
        "coverUrl": coverUrl,
        "bizScope": bizScope,
      };
}

///直播计划和直播历史模型
class LivePlanHistoryModel {
  LivePlanHistoryModel(
      {this.id,
      this.anchorId,
      this.startTime,
      this.liveCover,
      this.title,
        //直播公告
      this.bulletin,
      //直播类型(1: 公开直播, 2: 私密直播)
      this.liveType,
      this.productIds,
      // 直播标签IDs
      this.labelIds,
      this.labels,
      //直播贴纸数据
      this.liveDecals,
      this.couponCodes,
      // 直播状态(0: 未开播, 1: 开播中, 2: 已结束)
      this.status,
      // 直播指定(0: 未置顶, 1: 置顶)
      this.liveTop,
      this.bizType,
      this.openShare,
      this.shareIcon,
      this.hasRedEnvelope,
      this.liveRedEnvelopeInfo,
      this.endTime,
      this.masterProductId,
      this.stopMessage,
      this.statistics,
      this.statusMessage,
      this.delLabelFlag});

  int id = 0;
  int anchorId;
  int startTime;
  String liveCover;
  String title;
  String bulletin;
  int liveType;
  List<int> productIds;
  List labelIds;
  List labels;
  String liveDecals;
  String couponCodes;
  int status;
  String liveTop;
  int bizType;
  bool openShare;
  String shareIcon;
  int hasRedEnvelope;
  String liveRedEnvelopeInfo;
  int endTime;
  int masterProductId;
  String stopMessage;
  Statistics statistics;
  String statusMessage;
  bool delLabelFlag;
  String statusText;

  String getStatusText(){
    String statusString = "";
    if (status == 0){
      statusString = "待直播";
    } else if (status == 1){
      statusString = "直播中";
    } else if (status == 2){
      statusString = "结束";
    }

    return statusString;
  }

  factory LivePlanHistoryModel.fromJson(Map<String, dynamic> json) {
//    json["id"] = int.parse(json["id"].toString());
    return LivePlanHistoryModel(
        id: json["id"],
        anchorId: json["anchorId"],
        startTime: json["startTime"],
        liveCover: json["liveCover"],
        title: json["title"],
        bulletin: json["bulletin"],
        liveType: json["liveType"],
        productIds: json["productIds"] != null
            ? List<int>.from(json["productIds"])
            : [],
        labelIds: json["labelIds"],
        labels: json["labels"],
        liveDecals: json["liveDecals"],
        couponCodes: json["couponCodes"],
        status: json["status"],
        liveTop: json["liveTop"],
        bizType: json["bizType"],
        openShare: json["openShare"],
        shareIcon: json["shareIcon"],
        hasRedEnvelope: json["hasRedEnvelope"],
        liveRedEnvelopeInfo: json["liveRedEnvelopeInfo"],
        endTime: json["endTime"],
        masterProductId: json["masterProductId"],
        stopMessage: json["stopMessage"],
        statistics: json["statistics"] != null
            ? Statistics.fromJson(json["statistics"])
            : Statistics(),
        statusMessage: json["statusMessage"],
        delLabelFlag: json["delLabelFlag"]);
  }
}

class Statistics {
  Statistics({this.popularity});

  int popularity;

  factory Statistics.fromJson(Map<String, dynamic> json) {
    return Statistics(
      popularity: json["popularity"],
    );
  }
}
