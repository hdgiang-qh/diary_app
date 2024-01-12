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
import 'package:nb_utils/nb_utils.dart';

part 'infor_event.dart';

part 'infor_state.dart';

class InforBloc extends Bloc<InforEvent, InforState> {
  InforUser? ifUser, ifUserv2;
  List<InforUserRole> ifUserRole = [];
  TextEditingController date = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController nickName = TextEditingController();
  TextEditingController email = TextEditingController();
  XFile? image;
  int? idRole,idRole2 ;
  int? idUser;
  final AuthService authService = AuthService();

  InforBloc() : super(InforInitial());

  void getInforUser() async {
    emit(InforLoading());
    EasyLoading.show(dismissOnTap: true);
    try {
      var res = await Api.getAsync(endPoint: ApiPath.inforUser);
      if (res['status'] == "SUCCESS") {
        ifUser = InforUser.fromJson(res['data']);
        idUser = res['data']['id'];
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

  void getInforUserRole() async {
    emit(InforLoading());
    try {
      var res = await Api.getAsync(endPoint: ApiPath.inforUser);
      if (res['status'] == "SUCCESS") {
        if ((res['data']['role'] as List).isNotEmpty) {
          for (var json in res['data']['role']) {
            ifUserRole.add(InforUserRole.fromJson(json));
          }
          idRole = ifUserRole.fold(
              0,
                  (sum, item) =>
              (item.id ?? 0));
          emit(InforSuccess(ifUserRole));
        }
        else{
          emit(InforFailure(error: res['']));
        }
      } else {
        emit(InforFailure(error: res['']));
      }
    } on DioException catch (e) {
      emit(InforFailure(error: e.error.toString()));
    } catch (e) {
      emit(InforFailure(error: e.toString()));
    }
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
    EasyLoading.show(dismissOnTap: true);
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
    EasyLoading.dismiss();
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

}
