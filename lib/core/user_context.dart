import 'package:shared_preferences/shared_preferences.dart';

abstract class UserContext {
  const UserContext();

  Future<String?> getUserToken();

  Future<bool> setUserToken(String token);
}

class UserContextImpl extends UserContext {
  static const String userTokenKey = "USER_TOKEN";
  final SharedPreferences sharedPreferences;

  const UserContextImpl({required this.sharedPreferences});

  @override
  Future<String?> getUserToken() async {
    return sharedPreferences.getString(userTokenKey);
  }

  @override
  Future<bool> setUserToken(String token) async {
    return await sharedPreferences.setString(userTokenKey, token);
  }
}
