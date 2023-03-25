import 'package:shared_preferences/shared_preferences.dart';

class CommonPreferences {

  static const String keyProxyIp = "proxyIp";

  static const String keyProxyPort = "proxyPort";

  static Future<String?> getString(String key) async{
    SharedPreferences sharedPreferences = await _sharedPreferences();
    return sharedPreferences.getString(key);
  }

  ///set string
  static Future<bool> setString(String key, String value) async{
    SharedPreferences sharedPreferences = await _sharedPreferences();
    return sharedPreferences.setString(key, value);
  }

  static Future<SharedPreferences> _sharedPreferences() {
    return SharedPreferences.getInstance();
  }
}
