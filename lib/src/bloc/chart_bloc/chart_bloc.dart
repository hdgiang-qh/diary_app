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
  List<ChartMonthModel> list = [];
  late int? id;

  ChartBloc() : super(ChartInitial());

  void getDataChart() async {
    emit(ChartLoading());
    try {
      var res =
          await Api.getAsync(endPoint: "${ApiPath.chartMonthUser}/25?month=1");
      final Map<String, dynamic> jsonData = res;
      print("json: $jsonData");
      list.add(ChartMonthModel.fromJson(res["Jan"]));
      print(list);
    } on DioException catch (e) {
      emit(ChartFailure(e.error.toString()));
    } catch (e) {
      emit(ChartFailure(e.toString()));
    }
  }

  Future<ChartMonthModel> fetchData() async {
    var res = await Api.getAsync(endPoint: "${ApiPath.chartMonthUser}/25?month=1");
    final Map<String, dynamic> jsonData = res;
    print("json: $jsonData");
    return ChartMonthModel.fromJson(jsonData);
  }
}
