
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
class SharePreferencesHelper {
  static SharePreferencesHelper sharePreferenceHelper;
  static const String SHAREPREFERENCES_USER_ID = 'user_id';
  static const String SHAREPREFERENCES_USER_Data = 'user_data';
  static SharePreferencesHelper getInstant() {
    if (sharePreferenceHelper == null) {
      sharePreferenceHelper = new SharePreferencesHelper();
    }
    return sharePreferenceHelper;
  }

  Future<String> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? "";
  }

  setString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }


  setUserData( Map value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = json.encode(value);
    await prefs.setString('user_data', user);
  }
  removePref(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  Future<int> getInt(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(key) ?? 0;
  }

  setInt(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  Future<bool> getBool(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  setBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool(key, value);
  }

  clearPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
