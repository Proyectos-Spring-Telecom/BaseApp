import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> cacheToken(String token);
  Future<String?> getToken();
  Future<void> clearCache();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences _prefs;

  AuthLocalDataSourceImpl(this._prefs);

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      await _prefs.setString(AppConstants.userKey, jsonEncode(user.toJson()));
    } catch (e) {
      throw CacheException(message: 'Error al guardar usuario: $e');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final jsonString = _prefs.getString(AppConstants.userKey);
      if (jsonString == null) return null;
      return UserModel.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
    } catch (e) {
      throw CacheException(message: 'Error al obtener usuario: $e');
    }
  }

  @override
  Future<void> cacheToken(String token) async {
    try {
      await _prefs.setString(AppConstants.tokenKey, token);
    } catch (e) {
      throw CacheException(message: 'Error al guardar token: $e');
    }
  }

  @override
  Future<String?> getToken() async {
    return _prefs.getString(AppConstants.tokenKey);
  }

  @override
  Future<void> clearCache() async {
    try {
      await _prefs.remove(AppConstants.userKey);
      await _prefs.remove(AppConstants.tokenKey);
    } catch (e) {
      throw CacheException(message: 'Error al limpiar caché: $e');
    }
  }
}
