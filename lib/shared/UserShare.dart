import 'package:shared_preferences/shared_preferences.dart';

class UserShare {
  static SharedPreferences? _preferences;

  static const _keyUsername = "username";
  static const _keyToken = "token";

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUsernameShare(String username) async =>
      await _preferences?.setString(_keyUsername, username);

  static String? getUsernameShare() => _preferences?.getString(_keyUsername);

  static Future setTokenShare(String token) async =>
      await _preferences?.setString(_keyToken, token);

  static String? getTokenShare() => _preferences?.getString(_keyToken);

  static Future<bool?> removeToken() async => _preferences?.remove(_keyToken);

  static Future<bool?> removeUsername() async =>
      _preferences?.remove(_keyUsername);
}
