import 'dart:io';

import 'package:xtflutter/config/app_config/app_listener.dart';
import 'package:xtflutter/model/comment_show_model.dart';
import 'package:xtflutter/model/live_anchorPlan_model.dart';
import 'package:xtflutter/model/video_replay_model.dart';
import 'package:xtflutter/net_work/http_request.dart';
import 'package:xtflutter/utils/appconfig.dart';

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

  ///点赞或者取消点赞
  static void likeOrCancelLike(int materialId){
    final url = "/ncweb/product/material/like";
    HttpRequest.request(url,method: "post",queryParameters: {"materialId":materialId});
  }

  ///关注
  ///focusId 关注id,
  ///focusType 关注类型 1 用户
  ///focusSource 关注来源 1 直播 2 口碑秀
  ///autoFocus 0 手动关注 1 自动关注
  static Future<bool> attentionRequest(int focusId,int focusType,int focusSource,int autoFocus) async{
    final url = "/ncweb/octupus/member/focus";
    return await HttpRequest.request(url,method: "post",params: {"focusId":focusId,"focusType":focusType,"focusSource":focusSource,"autoFocus":autoFocus});
  }

  ///取消关注
  static Future<bool> cancelAttentionRequest(int focusId,int focusType) async{
    final url = "/ncweb/octupus/member/cancelFocus";
    return await HttpRequest.request(url,method: "post",params: {"focusId":focusId,"focusType":focusType});
  }

  ///能否发布口碑秀
  static Future<bool> canPublish() {
    final url = "/ncweb/product/material/getPublish";
    return HttpRequest.request(url).then((value) {
      return value["canPublish"];
    });
  }

  static Future<String> checkOnOffNotice(bool isNotice,int id,int anchorId){
    return AppListener.getPushToken().then((pushToken) {
      String url;
      if(isNotice){
        url = "/live/unStar";
      }else{
        url = "/live/star";
      }
      return HttpRequest.request(url,method: "post",params: {"id":id,"anchorId":anchorId,"token":pushToken,"platform":AppConfig.osPlatform}).then((value) {
        return value["value"];
      });
    });

  }
}
