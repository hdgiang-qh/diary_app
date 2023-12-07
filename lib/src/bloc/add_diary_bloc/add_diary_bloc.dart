import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:diary/src/core/api.dart';
import 'package:diary/src/core/apiPath.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'add_diary_event.dart';

part 'add_diary_state.dart';

class AddDiaryBloc extends Bloc<AddDiaryEvent, AddDiaryState> {
  TextEditingController happened = TextEditingController();
  TextEditingController mood = TextEditingController();
  String? dropdownValue;
  int? moodId;
  AddDiaryBloc() : super(AddDiaryInitial());

  void createDiary() async {
    emit(AddDiaryLoading());
    try {
      Map<String, dynamic> data = {
        'happened': happened.text,
        'moodId': moodId,
        'status': dropdownValue,
      };
      final res = await Api.postAsync(
        endPoint: ApiPath.curdDiary,
        req: data,
      );
      if (res['status'] == "SUCCESS") {
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
