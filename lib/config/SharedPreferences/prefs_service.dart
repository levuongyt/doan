import 'package:shared_preferences/shared_preferences.dart';

class PrefsService{
  Future<bool> saveBoolCheck(String key,bool ischeckBook) async {
    bool result = false;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(key, ischeckBook);
      result = true;
    } catch (e) {
      result=false;
    }
    return result;
  }

  Future<bool> readBoolCheck(String key) async {
    bool? result;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      result = prefs.getBool(key);
    } catch (e) {
      result=false;
    }
    return result ?? false;
  }

  Future<bool> saveStringData(String key, String value) async {
    bool result = false;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
      result = true;
    } catch (e) {
      result=false;
    }
    return result;
  }

  Future<String?> readStringData(String key) async {
    String? result;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      result = prefs.getString(key);
    } catch (e) {
      result = null;
    }
    return result;
  }
}