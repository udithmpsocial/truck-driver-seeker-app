import 'dart:convert';

import 'package:adastar/config/const.dart';
import 'package:adastar/main.dart';
import 'package:flutter_launcher_name/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pref{

  static Future<bool> saveUserLoginInSharedPreference(bool isPermanent) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setBool(
        Const.PREFERENCEKEY_USERLOGIN, isPermanent);
  }

  static Future<bool> getUserLoginFromSharedPreference() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(Const.PREFERENCEKEY_USERLOGIN);
  }


  static Future<bool> saveUserIdInSharedPreference(String uid) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(
        Const.PREFERENCEKEY_USERID, uid);
  }

  static Future<String> getUserIdFromSharedPreference() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(Const.PREFERENCEKEY_USERID);
  }


  static Future<bool> saveUserTypeInSharedPreference(String type) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(
        Const.PREFERENCEKEY_USERTYPE, type);
  }

  static Future<String> getUserTypeFromSharedPreference() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(Const.PREFERENCEKEY_USERTYPE);
  }



  static Future<bool> saveUserMapInSharedPreference(Map umap) async {
    String mapstr = json.encode(umap);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(
        Const.PREFERENCEKEY_USERTYPE, mapstr);
  }

  static Future<String> getUserMapFromSharedPreference() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String str = sharedPreferences.getString(Const.PREFERENCEKEY_USERTYPE);
    Map<String, dynamic> mapstr = json.decode(str);
    Const.UMAP = mapstr;
    return str;
  }


}
