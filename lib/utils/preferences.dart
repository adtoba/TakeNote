import 'package:shared_preferences/shared_preferences.dart';


Future<bool> setPreference(String key, dynamic value) async {
  final SharedPreferences _prefs = await SharedPreferences.getInstance();
  bool result;

  if(value.runtimeType == String) {
    result = await _prefs.setString(key, value);
  } else if(value.runtimeType == int) {
    result = await _prefs.setInt(key, value);
  } else if(value.runtimeType == bool) {
    result = await _prefs.setBool(key, value);
  } else {
    result = await _prefs.setDouble(key, value);
  }

  return result;
}

Future<dynamic> getPreference(String key) async {
  final SharedPreferences _prefs = await SharedPreferences.getInstance();
  dynamic result;

  result = await _prefs.get(key);

  return result;
}