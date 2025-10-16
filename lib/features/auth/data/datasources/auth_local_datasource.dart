import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../../../core/errors/exceptions.dart';

abstract class AuthLocalDataSource {
  Future<void> saveAuthToken(String token);
  Future<String?> getAuthToken();
  Future<void> saveUserId(String userId);
  Future<String?> getUserId();
  Future<void> clearAuthData();
  Future<bool> isLoggedIn();
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> saveAuthToken(String token) async {
    final result = await sharedPreferences.setString(
      StorageKeys.accessToken,
      token,
    );
    if (!result) {
      throw CacheException('Failed to save auth token');
    }
    await sharedPreferences.setBool(StorageKeys.isLoggedIn, true);
  }

  @override
  Future<String?> getAuthToken() async {
    return sharedPreferences.getString(StorageKeys.accessToken);
  }

  @override
  Future<void> saveUserId(String userId) async {
    final result = await sharedPreferences.setString(
      StorageKeys.userId,
      userId,
    );
    if (!result) {
      throw CacheException('Failed to save user id');
    }
  }

  @override
  Future<String?> getUserId() async {
    return sharedPreferences.getString(StorageKeys.userId);
  }

  @override
  Future<void> clearAuthData() async {
    await sharedPreferences.remove(StorageKeys.accessToken);
    await sharedPreferences.remove(StorageKeys.refreshToken);
    await sharedPreferences.remove(StorageKeys.userId);
    await sharedPreferences.remove(StorageKeys.userEmail);
    await sharedPreferences.setBool(StorageKeys.isLoggedIn, false);
  }

  @override
  Future<bool> isLoggedIn() async {
    return sharedPreferences.getBool(StorageKeys.isLoggedIn) ?? false;
  }
}
