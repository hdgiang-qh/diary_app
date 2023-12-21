import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:diary/src/core/api.dart';
import 'package:diary/src/core/apiPath.dart';
import 'package:diary/src/core/const.dart';
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
      var res = await Api.getAsync(
          endPoint: "${ApiPath.search}/$id");
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
        return ;
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
    // emit(InforLoading());
    // if (image == null) {
    //   return;
    // }
    // try {
    //   String apiUrl = Const.api_host + ApiPath.changeAvatar; // Thay đổi URL của API của bạn
    //   Dio dio = Dio();
    //   FormData formData = FormData.fromMap({
    //     "avatar": await MultipartFile.fromFile(
    //       image!.path,
    //       filename: "image.jpg", // Tên file khi gửi lên API
    //     ),
    //   });
    //   Response response = await dio.put(apiUrl, data: formData);
    //
    //   print("Response: ${response.data}");
    //
    // } catch (error) {
    //   print("Error updating image: $error");
    // }

    emit(InforLoading());
    if (image == null) {
        return;
      }
    try {
      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(
          image!.path,
          filename: "image.jpg", // Tên file khi gửi lên API
        ),
      });
      Map<String, dynamic> data = formData.fields.asMap().map((key, value) {
        String entryKey = value.key;
        dynamic entryValue = value.value;
        return MapEntry(entryKey, entryValue);
      });

      final res = await Api.putAsync(
        endPoint: ApiPath.changeAvatar,
        req: data,
      );
      if (res['status'] == "SUCCESS") {
        return ;
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
}
