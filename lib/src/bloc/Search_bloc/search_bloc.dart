import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:diary/src/core/api.dart';
import 'package:diary/src/core/apiPath.dart';
import 'package:diary/src/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  InforUser? inforUser;
  SearchBloc() : super(SearchInitial()) ;
  TextEditingController findByPhone = TextEditingController();

  void getSearch() async {
    emit(SearchLoading());
    try {
      var res = await Api.getAsync(
          endPoint: "${ApiPath.search}?phone=${findByPhone.text}");
      if (res['status'] == "SUCCESS") {
        inforUser = InforUser.fromJson(res['data']);
        emit(SearchSuccess(inforUser!));
      } else {
        emit(SearchFailure(error: ''));
      }
    } on DioException catch (e) {
      emit(SearchFailure(error: 'Lỗi nhập dữ liệu'));
    } catch (e) {
      emit(SearchFailure( error: e.toString()));
    }
  }
}
