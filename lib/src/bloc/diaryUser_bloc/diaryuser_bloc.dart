

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
  List<DiaryUserModel> list = [];
  List<DiaryUserModel> listDU = [];
  DateTime? time;
  String? dateTime;
  String? epoint;

  void getListDU() async {
    emit(DiaryUserLoading());
    try {
      if (time == null) {
        epoint = ApiPath.diaryCalendar;
      } else {
        DateFormat df = DateFormat("yyyy-MM-dd");
        dateTime = df.format(time!);
        epoint = "${ApiPath.diaryCalendar}?date=$dateTime";
      }
      var res = await Api.getAsync(
          endPoint: epoint.toString());
      if (res['status'] == "SUCCESS") {
        if ((res['data'] as List).isNotEmpty) {
          for (var json in res['data']) {
            list.add(DiaryUserModel.fromJson(json));
            listDU = list.reversed.toList();
          }
          emit(DiaryUserSuccess(list));
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

  void deletedDiary(int id) async {
    emit(DiaryUserLoading());
    try {
      var res = await Api.deleteAsync(endPoint: "${ApiPath.curdDiary}/$id");
      if (res['status'] == "SUCCESS") {
        listDU.clear();
        getListDU();
        emit(DeleteDiarySuccess());
      } else {
        emit(DiaryUserFailure(error: res['message']));
      }
    } on DioException catch (e) {
      emit(DiaryUserFailure(error: e.toString()));
    } catch (e) {
      emit(DiaryUserFailure(error: e.toString()));
    }
  }

}
