import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static final  Map<String, Object> _data = {};
  static Future<SharedPreferences> getInstance () {
    return SharedPreferences.getInstance();
  }
  static setStringList  (String key, List<String> value) async {
    final pref = await getInstance();
    _data[key] = value;
    pref.setStringList(key, value);
  }
  static Future<List<String>> getStringList  (String key) async {
    return getInstance().then((pref) {
      print(pref.getStringList(key));
      print(_data);
      return _data[key];
    });
  }
}