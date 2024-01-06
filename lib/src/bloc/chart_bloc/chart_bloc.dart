import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:diary/src/core/api.dart';
import 'package:diary/src/core/apiPath.dart';
import 'package:diary/src/core/const.dart';
import 'package:diary/src/models/chart_model.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'chart_event.dart';

part 'chart_state.dart';

class ChartBloc extends Bloc<ChartEvent, ChartState> {
  List<ChartMonthModelV2> list = [];
  late int? id;
  ChartBloc() : super(ChartInitial());

  void getDataChart() async {
    emit(ChartLoading());
    try {
      var res =
          await Api.getAsync(endPoint: "${ApiPath.chartMonthUser}");
      if (res['status'] == "SUCCESS") {
        if ((res['data']['Jan'] as List).isNotEmpty) {
          for(var json in res['data']['Jan']) {
            list.add(ChartMonthModelV2.fromJson(json));
          }
          emit(ChartSuccess(list));
        } else {
        }
      } else {
      }
    } on DioException catch (e) {
      emit(ChartFailure(e.error.toString()));
    } catch (e) {
      emit(ChartFailure(e.toString()));
    }
  }

}
