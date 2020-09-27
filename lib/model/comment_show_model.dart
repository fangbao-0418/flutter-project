import 'dart:typed_data';

class CommentShowModel {
  String content;
  String author;
  String authorImage;
  String auditMsg;
  String productInfo;
  bool canPublish;
  bool like;
  bool focus;
  int id;
  int productId;
  int memberId;
  int sharePv;
  int likeUv;
  int auditStatus;
  num createTime;
  List<String> shareHeadImages;
  List<PictureUrlListListBean> pictureUrlList;
  List<VideoUrlListListBean> videoUrlList;
  Uint8List uint8list;

  CommentShowModel({this.content, this.author, this.authorImage, this.auditMsg, this.productInfo, this.canPublish, this.like, this.focus, this.id, this.productId, this.memberId, this.sharePv, this.likeUv, this.auditStatus, this.createTime, this.pictureUrlList, this.videoUrlList, this.shareHeadImages});

  CommentShowModel.fromJson(Map<String, dynamic> json) {    
    this.content = json['content'];
    this.author = json['author'];
    this.authorImage = json['authorImage'];
    this.auditMsg = json['auditMsg'];
    this.productInfo = json['productInfo'];
    this.canPublish = json['canPublish'];
    this.like = json['like'];
    this.focus = json['focus'];
    this.id = json['id'];
    this.productId = json['productId'];
    this.memberId = json['memberId'];
    this.sharePv = json['sharePv'];
    this.likeUv = json['likeUv'];
    this.auditStatus = json['auditStatus'];
    this.createTime = json['createTime'];
    this.pictureUrlList = (json['pictureUrlList'] as List)!=null?(json['pictureUrlList'] as List).map((i) => PictureUrlListListBean.fromJson(i)).toList():null;
    this.videoUrlList = (json['videoUrlList'] as List)!=null?(json['videoUrlList'] as List).map((i) => VideoUrlListListBean.fromJson(i)).toList():null;

    List<dynamic> shareHeadImagesList = json['shareHeadImages'];
    this.shareHeadImages = new List();
    this.shareHeadImages.addAll(shareHeadImagesList.map((o) => o.toString()));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['author'] = this.author;
    data['authorImage'] = this.authorImage;
    data['auditMsg'] = this.auditMsg;
    data['productInfo'] = this.productInfo;
    data['canPublish'] = this.canPublish;
    data['like'] = this.like;
    data['focus'] = this.focus;
    data['id'] = this.id;
    data['productId'] = this.productId;
    data['memberId'] = this.memberId;
    data['sharePv'] = this.sharePv;
    data['likeUv'] = this.likeUv;
    data['auditStatus'] = this.auditStatus;
    data['createTime'] = this.createTime;
    data['pictureUrlList'] = this.pictureUrlList != null?this.pictureUrlList.map((i) => i.toJson()).toList():null;
    data['videoUrlList'] = this.videoUrlList != null?this.videoUrlList.map((i) => i.toJson()).toList():null;
    data['shareHeadImages'] = this.shareHeadImages;
    return data;
  }

}

class PictureUrlListListBean {
  String url;
  int size;

  PictureUrlListListBean({this.url, this.size});

  PictureUrlListListBean.fromJson(Map<String, dynamic> json) {    
    this.url = json['url'];
    this.size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['size'] = this.size;
    return data;
  }
}

class VideoUrlListListBean {
  String url;
  int size;

  VideoUrlListListBean({this.url, this.size});

  VideoUrlListListBean.fromJson(Map<String, dynamic> json) {    
    this.url = json['url'];
    this.size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['size'] = this.size;
    return data;
  }
}
