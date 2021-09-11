import 'package:shared_preferences/shared_preferences.dart';

abstract class UserContext {
  const UserContext();

  Future<String?> getUserToken();
  Future<bool> setUserToken(String token);

  Future<bool> setTrackerInterval(int value);
  int getTrackerInterval();
}

class UserContextImpl extends UserContext {
  static const String userTokenKey = "USER_TOKEN";
  static const String trackerIntervalKey = "TRACKER_INTERVAL";
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


  @override
  int getTrackerInterval() {
    return sharedPreferences.getInt(trackerIntervalKey) ?? 120;
  }

  @override
  Future<bool> setTrackerInterval(int value) async {
    return await sharedPreferences.setInt(trackerIntervalKey, value);
  }
}
