import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService{

  static Future saveBoolToSharedPreference(String key,bool value) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(key, value);
  }

  static getBoolToSharedPreference(String key) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.get(key);
  }
}