import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:diary/src/core/api.dart';
import 'package:diary/src/core/apiPath.dart';
import 'package:diary/src/models/userDiary_model.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'diary_user_search_event.dart';
part 'diary_user_search_state.dart';

class DiaryUserSearchBloc extends Bloc<DiaryUserSearchEvent, DiaryUserSearchState> {
  final List<DiaryUserModel> list = [];
  DiaryUserSearchBloc() : super(DiaryUserSearchInitial());

  void getListSearch({int? id}) async {
    emit(DiaryUserSearchLoading());
    try {
      var res = await Api.getAsync(
          endPoint: "${ApiPath.getSearchFeedUser}?createdBy=$id");
      if (res['status'] == "SUCCESS") {
        if ((res['data'] as List).isNotEmpty) {
          for (var json in res['data']) {
            list.add(DiaryUserModel.fromJson(json));
          }
          emit(DiaryUserSearchSuccess(list));
        } else {
          emit(DiaryUserSearchFailure(error: ""));
        }
      } else {
        emit(DiaryUserSearchFailure(error: res['change']));
      }
    } on DioException catch (e) {
      emit(DiaryUserSearchFailure(error: e.error.toString()));
    } catch (e) {
      emit(DiaryUserSearchFailure(error: e.toString()));
    }
  }
}
