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

class MessageListDetailModel {

  String content;
	String id;
	String jumpUrl;
	int    time;
	String title;

	MessageListDetailModel({this.content, this.id, this.jumpUrl, this.time, this.title});

	factory MessageListDetailModel.fromJson(Map<String, dynamic> json) {
		return MessageListDetailModel(
			content: json['content'],
			id: json['id'],
			jumpUrl: json['jumpUrl'],
			time: json['time'],
			title: json['title'],
		);
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['content'] = this.content;
		data['id'] = this.id;
		data['jumpUrl'] = this.jumpUrl;
		data['time'] = this.time;
		data['title'] = this.title;
		return data;
	}
}
