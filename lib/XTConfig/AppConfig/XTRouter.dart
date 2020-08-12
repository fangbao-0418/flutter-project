import 'package:flutter_boost/flutter_boost.dart';
import 'package:xtflutter/FlutterBoostDemo/simple_page_widgets.dart';
import 'package:xtflutter/UIPages/UserInfo/EditNamePage.dart';
import 'package:xtflutter/UIPages/UserInfo/UserInfoPage.dart';

class XTRouter {
  ///配置整体路由
  static routerCongfig() {
    FlutterBoost.singleton.registerPageBuilders(<String, PageBuilder>{
      'info': (String pageName, Map<dynamic, dynamic> params, String _) =>
          UserInfoPage(),
      'editPage': (String pageName, Map<dynamic, dynamic> params, String _) =>
          EditNamePage(params: params,name: pageName),

      ///可以在native层通过 getContainerParams 来传递参数
      'flutterPage': (String pageName, Map<dynamic, dynamic> params, String _) {
        print('flutterPage params:$params');
        return FlutterRouteWidget(params: params);
      },
    });
  }
}
