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
  TextEditingController place = TextEditingController();
  TextEditingController moodPast = TextEditingController();
  TextEditingController thinkPast = TextEditingController();
  TextEditingController time = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController level = TextEditingController();
  String? dropdownValue,dropdownLevel;
  int?  moodId,idDiary;
  AddDiaryBloc() : super(AddDiaryInitial());

  void createDiary() async {
    emit(AddDiaryLoading());
    try {
      Map<String, dynamic> data ={
        "date": date.text,
        "happened": happened.text,
        "level": dropdownLevel,
        "moodId": moodId,
        "other": "string",
        "place": place.text,
        "status": "PRIVATE",
        "thinkingFelt": moodPast.text,
        "thinkingMoment": thinkPast.text,
        "time": time.text,
        "title": "string"
      };
      final res = await Api.postAsync(
        endPoint: ApiPath.curdDiary,
        req: data,
      );
      if (res['status'] == "SUCCESS") {
        idDiary = res["data"]["id"];
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
