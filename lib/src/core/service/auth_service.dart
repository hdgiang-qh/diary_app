import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


import '../apiPath.dart';
import '../const.dart';

class AuthService {
  static const String _kRememberMeKey = 'remember_me';
  static const String _kUsernameKey = 'username';
  static const String _kPasswordKey = 'password';
  static const String _kToken = 'token';
  final Dio dio = Dio();
  static const FlutterSecureStorage secureStorage =  FlutterSecureStorage();
  String? _error;

  String? get error => _error;

  Future<String?> login(String username, String password) async {
    EasyLoading.show();
    try {
      Response response = await dio.post(Const.api_host + ApiPath.login,
          data: {'username': username, 'password': password});

      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        final token = response.data['token'];
        await secureStorage.write(key: 'token', value: token);
        _error = null;
        return token;
      } else {
        _error = 'Đăng nhập thất bại';
        EasyLoading.dismiss();// Đặt thông báo lỗi
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Login error: $e');
      }
      EasyLoading.dismiss();
      _error = "Đã xảy ra lỗi";
      return null;
    }
  }

  Future<String?> getToken() async {
    return await secureStorage.read(key: 'token');
  }

  Future<void> logout() async {
    await secureStorage.delete(key: 'token');
  }

  static Future<bool> getRememberMe() async {
    String? value = await secureStorage.read(key: _kRememberMeKey);
    return value == 'true';
  }

  static Future<void> setRememberMe(bool value) async {
    await secureStorage.write(key: _kRememberMeKey, value: value.toString());
  }

  static Future<String?> getUsername() async {
    return secureStorage.read(key: _kUsernameKey);
  }

  static Future<void> setUsername(String username) async {
    await secureStorage.write(key: _kUsernameKey, value: username);
  }

  static Future<String?> getPassword() async {
    return secureStorage.read(key: _kPasswordKey);
  }

  static Future<void> setPassword(String password) async {
    await secureStorage.write(key: _kPasswordKey, value: password);
  }

  static Future<void> setToken(String token) async {
    await secureStorage.write(key: _kToken, value: token);
  }
}

