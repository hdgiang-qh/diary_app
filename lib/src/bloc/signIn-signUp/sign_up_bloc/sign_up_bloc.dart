import 'package:bloc/bloc.dart';
import 'package:diary/src/core/api.dart';
import 'package:diary/src/core/apiPath.dart';
import 'package:diary/src/core/const.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitial());
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController nickName = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController email = TextEditingController();

  void register()async{
    emit(SignUpLoading());
    try {
      final response = await dio.post(
        Const.api_host + ApiPath.register,
        data: {
          "avatar": "https://i.imgur.com/6WCf7zr.jpg",
          "date": date.text,
          "email": email.text,
          "firstName": "string",
          "lastName": "string",
          'nickName': nickName.text,
          'password': password.text,
          'phone': phone.text,
          'username': username.text,
        },
      );
      if (response.statusCode == 200) {
        // Xử lý thành công
        print('Đăng ký thành công');
        print(response.data);
      } else {
        // Xử lý lỗi
        print('Đăng ký thất bại: ${response.statusCode}');
        print(response.data);
      }
    } on DioException catch (e) {
      // Xử lý lỗi Dio
      print('Lỗi Dio: ${e.error}');
    } catch (e) {
      // Xử lý lỗi khác
      print('Lỗi: $e');
    }
  }
}
