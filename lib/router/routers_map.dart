import 'package:flutter_boost/flutter_boost.dart';
import 'package:xtflutter/pages/promotion/promotion.dart';
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
  ///设置
  SettingPage.routerName: (pageName, params, _) => SettingPage(),

  /// 用户信息
  UserInfoPage.routerName: (pageName, params, _) => UserInfoPage(),

  ///用户昵称编辑
  EditNamePage.routerName: (pageName, params, _) =>
      EditNamePage(params: params, name: pageName),

  /// 添加收货地址
  AddAddressPage.routerName: (pageName, params, _) =>
      AddAddressPage(params: params, name: pageName),

  /// 收货地址
  AddressListPage.routerName: (pageName, params, _) => AddressListPage(),

  ///关于喜团
  AboutXituanPage.routerName: (pageName, params, _) => AboutXituanPage(),

  ///编辑手机号
  EditPhonePage.routerName: (pageName, params, _) => EditPhonePage(),

  ///支付宝账户
  AlipayAccountPage.routerName: (pageName, params, _) => AlipayAccountPage(),

  ///微信账户
  WeChatInfoPage.routerName: (pageName, params, _) => WeChatInfoPage(),

  ///修改微信账户
  WeChatInfoNameChangePage.routerName: (pageName, params, _) =>
      WeChatInfoNameChangePage(params: params, name: pageName),

  ///活动页
  Promotion.routerName: (pageName, params, _) =>
      Promotion(params: params, name: pageName),

  ///修改微信二维码
  WeChatInfoQrChangePage.routerName: (pageName, params, _) =>
      WeChatInfoQrChangePage(params: params, name: pageName),
  'page1': (pageName, params, _) => Testpage1(),
  'page2': (pageName, params, _) => Testpage2(),
  'page3': (pageName, params, _) => Testpage3(),

  /// 全球淘实名认证
  GlobalOfficalName.routerName: (pageName, params, _) => GlobalOfficalName(),
};
