
import 'package:flutter_boost/flutter_boost.dart';

import 'package:xtflutter/FlutterBoostDemo/simple_page_widgets.dart';
import 'package:xtflutter/UIPages/Address/AddressListPage.dart';
import 'package:xtflutter/UIPages/UserInfo/EditNamePage.dart';
import 'package:xtflutter/UIPages/UserInfo/EditPhonePage.dart';
import 'package:xtflutter/UIPages/UserInfo/UserInfoPage.dart';
import 'package:xtflutter/UIPages/Address/AddAddressPage.dart';
import 'package:xtflutter/UIPages/setting_page.dart';
import 'package:xtflutter/UIPages/TestPage/page1.dart';
import 'package:xtflutter/UIPages/TestPage/page2.dart';
import 'package:xtflutter/UIPages/TestPage/page3.dart';

Map<String, PageBuilder> routeConfigs = {
  'setting': (pageName, params, _) => SettingPage(),
  'info': (pageName, params, _) => UserInfoPage(),
  'editPage': (pageName, params, _) => EditNamePage(params: params, name: pageName),
  'addAddress': (pageName, params, _) => AddAddressPage(params: params, name: pageName),
  'editPhone': (pageName, params, _) => EditPhonePage(),
  'flutterPage': (pageName, params, _) => FlutterRouteWidget(params: params),
  'page1': (pageName, params, _) => TestPage1(),
  'page2': (pageName, params, _) => TestPage2(),
  'page3': (pageName, params, _) => TestPage3()
};