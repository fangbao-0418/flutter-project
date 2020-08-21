import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static Future<SharedPreferences> getInstance() {
    return SharedPreferences.getInstance();
  }

  static setStringList(String key, List<String> value) async {
    final pref = await getInstance();
    pref.setStringList(key, value);
  }

  static Future<List<String>> getStringList(String key) async {
    return getInstance().then((pref) {
      return pref.getStringList(key);
    });
  }
}
