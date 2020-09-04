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
  ///设置
  'setting': (pageName, params, _) => SettingPage(),

  /// 用户信息
  'fl-user-info': (pageName, params, _) => UserInfoPage(),

  ///用户昵称编辑
  'editPage': (pageName, params, _) =>
      EditNamePage(params: params, name: pageName),

  /// 添加收货地址
  'addAddress': (pageName, params, _) =>
      AddAddressPage(params: params, name: pageName),

  /// 收货地址
  'addressList': (pageName, params, _) => AddressListPage(),

  ///关于喜团
  'aboutXituan': (pageName, params, _) => AboutXituanPage(),

  ///编辑手机号
  'editPhone': (pageName, params, _) => EditPhonePage(),

  ///支付宝账户
  'alipayAccount': (pageName, params, _) => AlipayAccountPage(),

  ///微信账户
  'wechatInfo': (pageName, params, _) => WeChatInfoPage(),

  ///修改微信账户
  'wechatNameChange': (pageName, params, _) =>
      WeChatInfoNameChangePage(params: params, name: pageName),

  ///修改微信二维码
  'wechatQrChange': (pageName, params, _) =>
      WeChatInfoQrChangePage(params: params, name: pageName),
  'page1': (pageName, params, _) => Testpage1(),
  'page2': (pageName, params, _) => Testpage2(),
  'page3': (pageName, params, _) => Testpage3(),

  /// 全球淘实名认证
  'officalname': (pageName, params, _) => GlobalOfficalName(),
};
