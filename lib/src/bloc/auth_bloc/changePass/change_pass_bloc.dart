import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:diary/src/core/api.dart';
import 'package:diary/src/core/apiPath.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:nb_utils/nb_utils.dart';

part 'change_pass_event.dart';
part 'change_pass_state.dart';

class ChangePassBloc extends Bloc<ChangePassEvent, ChangePassState> {
  ChangePassBloc() : super(ChangePassInitial());
  TextEditingController oldp = TextEditingController();
  TextEditingController np = TextEditingController();

  void changePass() async {
    emit(ChangePassLoading());
    try {
      final res = await Api.getAsync(
        endPoint: "${ApiPath.changePass}?oldPassword=${oldp.text}&password=${np.text}",
      );
      if (res['status'] == "SUCCESS") {
       return;
      }
    } on DioException catch (e) {
      print('Lỗi Dio: ${e.error}');
    } catch (e) {
      // Xử lý lỗi khác
      print('Lỗi: $e');
    }
  }
}
