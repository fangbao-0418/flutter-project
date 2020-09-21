class MessageBriefModel {
  final String group;
  final String groupName;
  final String iconUrl;
  final String id;
  final String title;
  final int time;

  const MessageBriefModel(
      this.group, this.groupName, this.iconUrl, this.id, this.title, this.time);

  factory MessageBriefModel.fromJson(Map<String, dynamic> map) =>
      MessageBriefModel(
        map["group"],
        map["groupName"],
        map["iconUrl"],
        map["id"],
        map["title"],
        map["time"],
      );

  Map toJson() {
    Map map = Map<String, dynamic>();
    map["group"] = group;
    map["groupName"] = groupName;
    map["iconUrl"] = iconUrl;
    map["id"] = id;
    map["title"] = title;
    map["time"] = time;
    return map;
  }
}
