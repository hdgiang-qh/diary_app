import 'package:bloc/bloc.dart';
import 'package:diary/src/core/api.dart';
import 'package:diary/src/core/apiPath.dart';
import 'package:diary/src/models/getAll_diary_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'get_all_diary_event.dart';

part 'get_all_diary_state.dart';

class GetAllDiaryBloc extends Bloc<GetAllDiaryEvent, GetAllDiaryState> {
  GetAllDiaryBloc() : super(GetAllDiaryInitial());
  List<GetAllDiaryPublicModel> getAllDiaries = [];
  List<GetAllDiaryPublicModel> reversedList = [];
  RefreshController refreshController = RefreshController();

  void getAllDiary({bool? isRefresh = false}) async {
    emit(isRefresh == true ? GetAllDiaryLoading() : GetAllDiaryInitial());
    EasyLoading.show(dismissOnTap: true);
    try {
      var res = await Api.getAsync(endPoint: ApiPath.getAllDiaryFeed);
      if (res['status'] == "SUCCESS") {
        EasyLoading.dismiss();
        if ((res['data'] as List).isNotEmpty) {
          for (var json in res['data']) {
            getAllDiaries.add(GetAllDiaryPublicModel.fromJson(json));
            reversedList = getAllDiaries.reversed.toList();
          }
          emit(GetAllDiarySuccess(reversedList));
        } else {
          emit(GetAllDiaryEmpty());
        }
        refreshController.refreshCompleted();
      } else {
        emit(GetAllDiaryFailure(error: res['change']));
      }
    } on DioException catch (e) {
      EasyLoading.dismiss();
      emit(GetAllDiaryFailure(error: e.error.toString()));
    }
  }
}
