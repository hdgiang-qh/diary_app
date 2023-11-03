import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../apiPath.dart';
import '../const.dart';

class AuthService {
  final Dio dio = Dio();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  String? _error;
  String? get error => _error;

  // void registerUser() async {
  //   final dio = Dio();
  //
  //   FormData formData = FormData.fromMap({
  //     'username': 'your_username',
  //     'password': 'your_password',
  //     'email': 'your_email',
  //   });
  //
  //   try {
  //     final response = await dio.post(
  //       Const.api_host + ApiPath.register,
  //       data: formData,
  //     );
  //
  //     if (response.statusCode == 200) {
  //       print('Đăng ký thành công');
  //       print(response.data);
  //     } else {
  //       // Xử lý lỗi
  //       print('Đăng ký thất bại: ${response.statusCode}');
  //       print(response.data);
  //     }
  //   } catch (e) {
  //     print('Lỗi: $e');
  //   }
  // }


  //// Login
  Future<String?> login(String username, String password) async {
    try {
      Response response = await dio.post(Const.api_host + ApiPath.login,
          data: {'username': username, 'password': password});

      if (response.statusCode == 200) {
        final token = response.data['token'];
        await secureStorage.write(key: 'token', value: token);
        _error = null;
        return token;
      } else {
        _error = 'Đăng nhập thất bại'; // Đặt thông báo lỗi
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Login error: $e');
      }
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
}

