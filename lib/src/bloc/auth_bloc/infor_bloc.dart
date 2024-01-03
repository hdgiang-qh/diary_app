import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:diary/src/core/api.dart';
import 'package:diary/src/core/apiPath.dart';
import 'package:diary/src/core/const.dart';
import 'package:diary/src/core/service/auth_service.dart';
import 'package:diary/src/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'infor_event.dart';

part 'infor_state.dart';

class InforBloc extends Bloc<InforEvent, InforState> {
  List<InforUser> inforUsers = [];
  List<InforUserRole> inforUserRoles = [];
  InforUser? ifUser, ifUserv2;
  TextEditingController date = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController nickName = TextEditingController();
  TextEditingController email = TextEditingController();
  XFile? image;
  final AuthService authService = AuthService();

  InforBloc() : super(InforInitial());

  void getInforUser() async {
    emit(InforLoading());
    EasyLoading.show(dismissOnTap: true);
    try {
      var res = await Api.getAsync(endPoint: ApiPath.inforUser);
      if (res['status'] == "SUCCESS") {
        ifUser = InforUser.fromJson(res['data']);
        emit(InforSuccess2(ifUser!));
      } else {
        emit(InforFailure(error: res['']));
      }
    } on DioException catch (e) {
      emit(InforFailure(error: e.error.toString()));
    } catch (e) {
      emit(InforFailure(error: e.toString()));
    }
    EasyLoading.dismiss();
  }

  void getSearchId({int? id}) async {
    emit(InforLoading());
    try {
      var res = await Api.getAsync(endPoint: "${ApiPath.search}/$id");
      if (res['status'] == "SUCCESS") {
        ifUserv2 = InforUser.fromJson(res['data']);
        emit(InforSuccess3(ifUserv2!));
      } else {
        emit(InforFailure(error: ''));
      }
    } on DioException catch (e) {
      emit(InforFailure(error: e.error.toString()));
    } catch (e) {
      emit(InforFailure(error: e.toString()));
    }
  }

  void refreshPage() {
    emit(InforLoading());
    getInforUser();
    emit(InforSuccess2(ifUser!));
  }

  void updateInfor() async {
    emit(InforLoading());
    try {
      Map<String, dynamic> data = {
        "date": date.text,
        "email": email.text,
        "nickName": nickName.text,
        "phone": phone.text
      };
      final res = await Api.putAsync(
        endPoint: ApiPath.updateInforUser,
        req: data,
      );
      if (res['status'] == "SUCCESS") {
        return;
      } else {
        // Xử lý lỗi
        print('Fail: ${res.statusCode}');
        print(res.data);
        return;
      }
    } on DioException catch (e) {
      // Xử lý lỗi Dio
      print('Lỗi Dio: ${e.error}');
    } catch (e) {
      // Xử lý lỗi khác
      print('Lỗi: $e');
    }
  }

  void updateAvatar() async {
    emit(InforLoading());
    if (image == null) {
      return;
    }
    try {
      final res = await Api.putAsyncAvatar(
        endPoint: ApiPath.changeAvatar,
        req: {
          "avatar": await MultipartFile.fromFile(
            image!.path,
            filename: "image.jpg", // Tên file khi gửi lên API
          ),
        },
      );
      if (res['status'] == "SUCCESS") {
        return;
      } else {
        // Xử lý lỗi
        print('Fail: ${res.statusCode}');
        print(res.data);
        return;
      }
    } on DioException catch (e) {
      // Xử lý lỗi Dio
      print('Lỗi Dio: ${e.error}');
    } catch (e) {
      // Xử lý lỗi khác
      print('Lỗi: $e');
    }
  }

  // void updateAvatar() async {
  //   Dio dio = Dio();
  //   var token = await authService.getToken();
  //   FormData formData = FormData.fromMap({
  //     "avatar": await MultipartFile.fromFile(
  //       image!.path,
  //       filename: "image.jpg", // Tên file khi gửi lên API
  //     ),
  //   });
  //   try {
  //     Response response = await dio.put(
  //       Const.api_host + ApiPath.changeAvatar,
  //       data: formData,
  //       options: Options(
  //         headers: {
  //           "accept": "*/*",
  //           "Authorization": "Bearer $token",
  //           "Content-Type": "multipart/form-data",
  //         },
  //       ),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       print("Cập nhật thành công");
  //     } else {
  //       print("Lỗi từ server: ${response.statusCode}");
  //       print(response.data);
  //     }
  //   } catch (e) {
  //     // Xử lý lỗi khi gửi yêu cầu
  //     print("Lỗi khi gửi yêu cầu: $e");
  //   }
  // }
}
