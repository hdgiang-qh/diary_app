import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:diary/src/core/api.dart';
import 'package:diary/src/core/apiPath.dart';
import 'package:diary/src/core/const.dart';
import 'package:diary/src/models/chart_model.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

part 'chart_event.dart';

part 'chart_state.dart';

class ChartBloc extends Bloc<ChartEvent, ChartState> {
  List<ChartModelV2> list = [];
  List<ChartModelV2> list2 = [];
  List<ChartModelV2?>? list3;
  ChartModel? listChart;

  ChartBloc() : super(ChartInitial());
  String? endPoints, month;
  String formattedDate = DateFormat.MMM().format(DateTime.now());

  void getDataChartMonth({int? id}) async {
    emit(ChartLoading());
    if (id == null) {
      endPoints = ApiPath.chartMonthUser;
      month = formattedDate;
    } else {
      endPoints = "${ApiPath.chartMonthUser}?month=$id";
      switch (id) {
        case 1:
          month = 'Jan';
          break;
        case 2:
          month = 'Feb';
          break;
        case 3:
          month = 'Mar';
          break;
        case 4:
          month = 'Apr';
          break;
        case 5:
          month = 'May';
          break;
        case 6:
          month = 'Jun';
          break;
        case 7:
          month = 'Jul';
          break;
        case 8:
          month = 'Aug';
          break;
        case 9:
          month = 'Sep';
          break;
        case 10:
          month = 'Oct';
          break;
        case 11:
          month = 'Nov';
          break;
        case 12:
          month = 'Dec';
          break;
      }
    }
    try {
      var res = await Api.getAsync(endPoint: endPoints.toString());
      if (res['status'] == "SUCCESS") {
        if ((res['data'][month] as List).isNotEmpty) {
          for (var json in res['data'][month]) {
            list.add(ChartModelV2.fromJson(json));
          }
          emit(ChartSuccess(list));
        } else {}
      } else {}
    } on DioException catch (e) {
      emit(ChartFailure(e.error.toString()));
    } catch (e) {
      emit(ChartFailure(e.toString()));
    }
  }

}
