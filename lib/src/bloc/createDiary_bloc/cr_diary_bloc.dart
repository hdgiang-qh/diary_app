import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:diary/src/core/api.dart';
import 'package:diary/src/core/apiPath.dart';
import 'package:diary/src/models/create_diary_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

part 'cr_diary_event.dart';

part 'cr_diary_state.dart';

class CrDiaryBloc extends Bloc<CrDiaryEvent, CrDiaryState> {
  CrDiaryBloc() : super(CrDiaryInitial());
  List<CreateDiaryModel> crDiary = [];
  CreateDiaryModel createDiaryModel = CreateDiaryModel();

  void postDiary() async {
    emit(CrDiaryLoading());
    try {
      Map<String, dynamic> req = createDiaryModel.toJson();
      var res = await Api.postAsync(
          endPoint: ApiPath.curdDiary, req: req, hasForm: true);
      if (res['status'] == "SUCCESS") {
        if (kDebugMode) {
          print("object");
        }
      } else {
        emit(CrDiaryFailure(er: res['change']));
      }
    } on DioException catch (e) {
      emit(CrDiaryFailure(er: e.error.toString()));
    } catch (e) {
      emit(CrDiaryFailure(er: e.toString()));
    }
  }
}
