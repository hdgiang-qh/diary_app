import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:diary/src/core/api.dart';
import 'package:diary/src/core/apiPath.dart';
import 'package:diary/src/models/userDiary_model.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

part 'diaryuser_event.dart';

part 'diaryuser_state.dart';

class DiaryUserBloc extends Bloc<DiaryuserEvent, DiaryuserState> {
  DiaryUserBloc() : super(DiaryUserInitial());
  List<DiaryUserModel> listDU = [];

  void getListDU() async {
    String? _startDate;
    emit(DiaryUserLoading());
    try {
      late final date = DateTime.now();
      late final formatter = DateFormat('yyyy-MM-dd');
      late String startDate = formatter.format(date);
      var res = await Api.getAsync(
           endPoint:
          startDate == null
              ? ApiPath.diaryCalendar
              : "${ApiPath.diaryCalendar}?date=$startDate");
      if (res['status'] == "SUCCESS") {
        if ((res['data'] as List).isNotEmpty) {
          for (var json in res['data']) {
            listDU.add(DiaryUserModel.fromJson(json));
          }
          emit(DiaryUserSuccess(listDU));
        } else {
          emit(DiaryUserFailure(error: 'Data Empty'));
        }
      } else {
        emit(DiaryUserFailure(error: res['change']));
      }
    } on DioException catch (e) {
      emit(DiaryUserFailure(error: e.error.toString()));
    } catch (e) {
      emit(DiaryUserFailure(error: e.toString()));
    }
  }
}
