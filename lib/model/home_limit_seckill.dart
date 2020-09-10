class LimitTimeSeckillModel {
  LimitTimeSeckillModel({
    this.promotionId, 
    this.status, 
    this.promotionTime,
    this.promotionEndTime, 
    this.defaultSelected, 
    this.tagUrl,
    this.tagPosition, 
    this.promotionStartTimeDesc, 
    this.desc,
    this.products});

  int promotionId;
  int status;
  int promotionTime;
  int promotionEndTime;
  bool defaultSelected;
  String tagUrl;
  int tagPosition;
  String promotionStartTimeDesc;
  String desc;
  List products;

  factory LimitTimeSeckillModel.fromJson(Map<String, dynamic> json) =>
      LimitTimeSeckillModel(
          promotionId: json["promotionId"],
          status: json["status"],
          promotionTime: json["promotionTime"],
          promotionEndTime: json["promotionEndTime"],
          defaultSelected: json["defaultSelected"],
          tagUrl: json["tagUrl"],
          tagPosition: json["tagPosition"],
          promotionStartTimeDesc: json["promotionStartTimeDesc"],
          desc: json["desc"],
          products: json["products"]);
}