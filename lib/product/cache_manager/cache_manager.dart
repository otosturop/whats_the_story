import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  Future<bool> saveUser(String token, String id) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(CacheManagerKey.userToken.toString(), token);
    await pref.setString(CacheManagerKey.userId.toString(), id);
    return true;
  }

  Future<bool> removeUser() async {
    final pref = await SharedPreferences.getInstance();
    final removeToken = await pref.remove(CacheManagerKey.userToken.toString());
    final removeId = await pref.remove(CacheManagerKey.userId.toString());
    if (removeToken && removeId) {
      return true;
    } else {
      return false;
    }
  }

  Future<String?> getToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(CacheManagerKey.userToken.toString());
  }

  Future<String?> getUserId() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(CacheManagerKey.userId.toString());
  }
}

enum CacheManagerKey { userToken, userId }
