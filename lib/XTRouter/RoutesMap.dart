import 'package:flutter_boost/flutter_boost.dart';

import 'package:xtflutter/FlutterBoostDemo/simple_page_widgets.dart';
import 'package:xtflutter/UIPages/UserInfo/AddressListPage.dart';
import 'package:xtflutter/UIPages/UserInfo/AlipayAccountPage.dart';
import 'package:xtflutter/UIPages/UserInfo/EditNamePage.dart';
import 'package:xtflutter/UIPages/UserInfo/EditPhonePage.dart';
import 'package:xtflutter/UIPages/UserInfo/UserInfoPage.dart';
import 'package:xtflutter/UIPages/UserInfo/AddAddressPage.dart';
import 'package:xtflutter/UIPages/UserInfo/WeChatInfoChangePage.dart';
import 'package:xtflutter/UIPages/UserInfo/WeChatInfoPage.dart';
import 'package:xtflutter/UIPages/UserInfo/AboutXituanPage.dart';
import 'package:xtflutter/UIPages/UserInfo/global_offical_name.dart';
import 'package:xtflutter/UIPages/setting_page.dart';
import 'package:xtflutter/UIPages/TestPage/page1.dart';
import 'package:xtflutter/UIPages/TestPage/page2.dart';
import 'package:xtflutter/UIPages/TestPage/page3.dart';

Map<String, PageBuilder> routeConfigs = {
  'setting': (pageName, params, _) => SettingPage(),
  'fl-user-info': (pageName, params, _) => UserInfoPage(),
  'editPage': (pageName, params, _) =>
      EditNamePage(params: params, name: pageName),
  'addAddress': (pageName, params, _) =>
      AddAddressPage(params: params, name: pageName),
  'addressList': (pageName, params, _) => AddressListPage(),
  'aboutXituan': (pageName, params, _) => AboutXituanPage(),
  'editPhone': (pageName, params, _) => EditPhonePage(),
  'alipayAccount': (pageName, params, _) => AlipayAccountPage(),
  'wechatInfo': (pageName, params, _) => WeChatInfoPage(),
  'wechatNameChange': (pageName, params, _) =>
      WeChatInfoNameChangePage(params: params, name: pageName),
  'wechatQrChange': (pageName, params, _) =>
      WeChatInfoQrChangePage(params: params, name: pageName),
  'flutterPage': (pageName, params, _) => FlutterRouteWidget(params: params),
  'page1': (pageName, params, _) => TestPage1(),
  'page2': (pageName, params, _) => TestPage2(),
  'page3': (pageName, params, _) => TestPage3(),
  // 全球淘
  'officalname': (pageName, params, _) => GlobalOfficalName(),
};
