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

  int id;
  String nickName;
  int level;
  int type;
  String label;
  int fansNum;
  String coverUrl;
  int bizScope;


  String get avatarUrl {
    return coverUrl ?? "";
  }

  String get nickNameText {
    return nickName ?? "";
  }

  int get fansNumber {
    return fansNum ?? 0;
  }



  factory LiveStationAnchorModel.fromJson(Map<String, dynamic> json) {
    return LiveStationAnchorModel(
      id: json["id"],
      nickName: json["nickName"],
      level: json["level"],
      type: json["type"],
      label: json["label"],
      fansNum: json["fansNum"],
      bizScope: json["bizScope"],
      coverUrl: json["coverUrl"] != null ? json["coverUrl"] : '',
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
  bool isHistoryModel = false; //是否是历史直播
  bool isEditBtn(){
    bool isEdit = false;
    if (isHistoryModel == false){
      isEdit = status != 3;
    }else{
      isEdit = status == 0 || status == 3;
    }
    return isEdit;
  }              //当前状态对应的按钮是查看还是重新编辑

  String getStatusText(){
    String statusString = "";
    if (isHistoryModel == false){
      switch (status){
        case -1:{
          statusString = "草稿";
        }
        break;
        case 0:{
          statusString = "待审核";
        }
        break;
        case 1:{
          statusString = "待开播";
        }
        break;
        case 2:{
          statusString = "未过审";
        }
        break;
        case 3:{
          statusString = "直播中";
        }
        break;
      }
    }else{
      switch (status){
        case 0:{
          statusString = "过期";
        }
        break;
        case 1:{
          statusString = "回放";
        }
        break;
        case 2:{
          statusString = "禁播";
        }
        break;
        case 3:{
          statusString = "未过审";
        }
        break;
        case 4:{
          statusString = "预告停播";
        }
        break;
      }
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
