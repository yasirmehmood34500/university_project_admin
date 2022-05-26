import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String sharedPreferenceLogInKey = "LOGINKEY";
  static String sharedPreferenceNameKey = "NAMEKEY";
  static String sharedPreferenceEmailKey = "EMAILKEY";
  static String sharedPreferenceIdKey = "IDKEY";

  static Future<bool> saveLogInSharePreference(bool isUserLogIn) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.setBool(sharedPreferenceLogInKey, isUserLogIn);
  }

  static Future<bool> saveNameSharePreference(String name) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.setString(sharedPreferenceNameKey, name);
  }
  static Future<bool> saveMobileSharePreference(String email) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.setString(sharedPreferenceEmailKey, email);
  }

  static Future<bool> saveIdSharePreference(int id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.setInt(sharedPreferenceIdKey, id);
  }


  static Future<bool?> getLogInSharePreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(sharedPreferenceLogInKey);
  }

  static Future<String?> getNameSharePreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(sharedPreferenceNameKey);
  }

  static Future<String?> getEmailSharePreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(sharedPreferenceEmailKey);
  }

  static Future<int?> getIdSharePreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt(sharedPreferenceIdKey);
  }

}
