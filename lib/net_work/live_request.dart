import 'package:xtflutter/model/comment_show_model.dart';
import 'package:xtflutter/model/live_anchorPlan_model.dart';
import 'package:xtflutter/model/video_replay_model.dart';
import 'package:xtflutter/net_work/http_request.dart';

class LiveRequest {

  /// 获取直播信息
  static Future<dynamic> getLiveInfoData(Map para) async {
    final url = "/live/list/station";
    final result = await HttpRequest.request(url, queryParameters:para);
    print(result);
    return result;
  }

  /// 获取主播信息
  static Future<dynamic> getUserInfoData() async {
    final url = "/live/station/anchor/info";
    final result = await HttpRequest.request(url);
    print(result);
    return result;
  }

  /// 获取结算信息
  static Future<dynamic> getSettleInfoData() async {
    final url = "/cweb/member/settlement/v1/queryLiveWorkbenchAmount";
    final result = await HttpRequest.request(url);
    print(result);
    return result;
  }

  ///获取主播直播计划列表
  static Future<List<LiveAnchorPlanModel>> getAnchorPlanList(String anchorId) {
    final url = "/live/anchorPlan";
    final  Future<List> future = HttpRequest.request(url, method: "post",params: {"id":anchorId});

    return future.then((value) {
      var list = List<LiveAnchorPlanModel>();
      value.forEach((element) {
        list.add(LiveAnchorPlanModel.fromJson(element));
      });
      return list;
    });
  }

  ///获取主播历史直播列表
  static Future<dynamic> getLiveHistoryList(Map para) async {
    final url = "/live/list/station/history";
    final result = await HttpRequest.request(url, queryParameters:para);
    print(result);
    return result;
  }

  ///获取主播个人页回放列表
  static Future<List<VideoReplayModel>> getVideoReplayList(String anchorId,int currentPage) {
    final url = "/live/historyPlayback";
    final  Future<List> future = HttpRequest.request(url, method: "post",params: {"id":anchorId,"page":currentPage,"pageSize":10});
    return future.then((value) {
      var list = List<VideoReplayModel>();
      value.forEach((element) {
        list.add(VideoReplayModel.fromJson(element));
      });
      return list;
    });
  }

  ///获取主播口碑秀列表
  static Future<List<CommentShowModel>> getCommentShowList(String memberId,int currentPage) {
    final url = "/ncweb/product/material/getListByPerson";
    final  Future<List> future = HttpRequest.request(url,queryParameters: {"memberId":memberId,"page":currentPage,"pageSize":10});
    return future.then((value) {
      var list = List<CommentShowModel>();
      value.forEach((element) {
        list.add(CommentShowModel.fromJson(element));
      });
      return list;
    });
  }
}
