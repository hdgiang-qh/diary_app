import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:diary/src/core/api.dart';
import 'package:diary/src/core/apiPath.dart';
import 'package:diary/src/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'infor_event.dart';

part 'infor_state.dart';

class InforBloc extends Bloc<InforEvent, InforState> {
  List<InforUser> inforUsers = [];
  List<InforUserRole> inforUserRoles = [];
  InforUser? ifUser, ifUserv2;

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

  void updateAvatar(String avatar) async {
    emit(InforLoading());
    try {
      File file = File(avatar);
      print(file.path);
      Map<String, dynamic> data = {
        'avatar': await MultipartFile.fromFile(
          file.path,
        ),
      };
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
