import 'package:shared_preferences/shared_preferences.dart';

class PrefsService{
  Future<bool> saveBoolCheck(String key,bool ischeckBook) async {
    bool result = false;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(key, ischeckBook);
      result = true;
    } catch (e) {
      print('error$e');
    }
    return result;
  }

  Future<bool> readBoolCheck(String key) async {
    bool? result;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      result = await prefs.getBool(key);
    } catch (e) {
      print('error$e');
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
      print('error$e');
    }
    return result;
  }

  Future<String> readStringData(String key) async {
    String? result;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      result = await prefs.getString(key);
    } catch (e) {
      print('error$e');
    }
    return result ?? "";
  }
}