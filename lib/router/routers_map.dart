import 'package:flutter_boost/flutter_boost.dart';
import 'package:xtflutter/pages/setting/user_info/about_xituan.dart';
import 'package:xtflutter/pages/setting/user_info/add_address.dart';
import 'package:xtflutter/pages/setting/user_info/address_list.dart';
import 'package:xtflutter/pages/setting/user_info/alipay_account.dart';
import 'package:xtflutter/pages/setting/user_info/edit_name.dart';
import 'package:xtflutter/pages/setting/user_info/edit_phone.dart';
import 'package:xtflutter/pages/setting/user_info/global_offical_name.dart';
import 'package:xtflutter/pages/setting/user_info/user_info.dart';
import 'package:xtflutter/pages/setting/user_info/wechat_info.dart';
import 'package:xtflutter/pages/setting/user_info/wechat_info_edit.dart';
import 'package:xtflutter/pages/setting/setting_page.dart';
import 'package:xtflutter/pages/demo_page/page1.dart';
import 'package:xtflutter/pages/demo_page/page2.dart';
import 'package:xtflutter/pages/demo_page/page3.dart';

Map<String, PageBuilder> routeConfigs = {
  'setting': (pageName, params, _) => SettingPage(),

  // 用户信息
  'fl-user-info': (pageName, params, _) => UserInfoPage(),
  'editPage': (pageName, params, _) =>
      EditNamePage(params: params, name: pageName),

  // 添加收货地址
  'addAddress': (pageName, params, _) =>
      AddAddressPage(params: params, name: pageName),
  // 收货地址
  'addressList': (pageName, params, _) => AddressListPage(),
  'aboutXituan': (pageName, params, _) => AboutXituanPage(),
  'editPhone': (pageName, params, _) => EditPhonePage(),
  'alipayAccount': (pageName, params, _) => AlipayAccountPage(),
  'wechatInfo': (pageName, params, _) => WeChatInfoPage(),
  'wechatNameChange': (pageName, params, _) =>
      WeChatInfoNameChangePage(params: params, name: pageName),
  'wechatQrChange': (pageName, params, _) =>
      WeChatInfoQrChangePage(params: params, name: pageName),
  'page1': (pageName, params, _) => Testpage1(),
  'page2': (pageName, params, _) => Testpage2(),
  'page3': (pageName, params, _) => Testpage3(),
  // 全球淘
  'officalname': (pageName, params, _) => GlobalOfficalName(),
};
