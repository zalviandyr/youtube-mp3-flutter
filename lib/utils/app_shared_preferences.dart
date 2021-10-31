import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreferences {
  static late SharedPreferences _preferences;

  static Future<AppSharedPreferences> getInstance() async {
    _preferences = await SharedPreferences.getInstance();

    return AppSharedPreferences();
  }

  String? getLang() {
    return _preferences.getString('lang');
  }

  Future<void> setLang(String value) async {
    await _preferences.setString('lang', value);
  }
}
