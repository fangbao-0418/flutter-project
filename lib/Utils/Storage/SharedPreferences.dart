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
    return getInstance().then((prefs) {
      return prefs.getStringList(key) ?? [];
    });
  }

  static Future remove(String key) {
    return getInstance().then((prefs) {
      prefs.remove(key);
    });
  }

  static Future clear() {
    return getInstance().then((prefs) {
      prefs.clear();
    });
  }
}
