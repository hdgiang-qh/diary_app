import 'package:bloc/bloc.dart';
import 'package:diary/src/core/api.dart';
import 'package:diary/src/core/apiPath.dart';
import 'package:diary/src/models/userDiary_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:meta/meta.dart';
import 'package:nb_utils/nb_utils.dart';

part 'detail_diary_event.dart';

part 'detail_diary_state.dart';

class DetailDiaryBloc extends Bloc<DetailDiaryEvent, DetailDiaryState> {
  DiaryUserModel? model;
  DetailDiaryBloc(this.id) : super(DetailDiaryInitial());
  TextEditingController happen = TextEditingController();
  TextEditingController place = TextEditingController();
  TextEditingController moodPast = TextEditingController();
  TextEditingController thinkPast = TextEditingController();
  String? dropdownLevel,dropdownStatus;
  int id;

  void getDetailDiary(id) async {
    emit(DetailLoading());
    EasyLoading.show(dismissOnTap: true);
    try {
      var res = await Api.getAsync(endPoint: '${ApiPath.curdDiary}/$id');
      if (res['status'] == "SUCCESS") {
        model = DiaryUserModel.fromJson(res["data"]);
        emit(DetailSuccessV2(model!));
      } else {
        emit(DetailFailure(res['message']));
      }
    } on DioException catch (e) {
      emit(DetailFailure(e.error.toString()));
    } catch (e) {
      emit(DetailFailure(e.toString()));
    }
    EasyLoading.dismiss();
  }


  void setPublicDiary(id) async {
    emit(DetailLoading());
    EasyLoading.show(dismissOnTap: true);
    try {
      var res = await Api.getAsync(endPoint: '${ApiPath.curdDiary}/public/$id');
      if (res['status'] == "SUCCESS") {
        model = DiaryUserModel.fromJson(res["data"]);
        emit(DetailSuccessV2(model!));
      } else {
        emit(DetailFailure(res['message']));
      }
    } on DioException catch (e) {
      emit(DetailFailure(e.error.toString()));
    } catch (e) {
      emit(DetailFailure(e.toString()));
    }
    EasyLoading.dismiss();
  }
  void setPrivateDiary(id) async {
    emit(DetailLoading());
    EasyLoading.show(dismissOnTap: true);
    try {
      var res = await Api.getAsync(endPoint: '${ApiPath.curdDiary}/private/$id');
      if (res['status'] == "SUCCESS") {
        model = DiaryUserModel.fromJson(res["data"]);
        emit(DetailSuccessV2(model!));
      } else {
        emit(DetailFailure(res['message']));
      }
    } on DioException catch (e) {
      emit(DetailFailure(e.error.toString()));
    } catch (e) {
      emit(DetailFailure(e.toString()));
    }
    EasyLoading.dismiss();
  }

  void updateDiary(id) async {
    emit(DetailLoading());
    try {
      Map<String, dynamic> data = {
        "happened": happen.text,
        "place": place.text,
        "thinkingFelt": moodPast.text,
        "thinkingMoment": thinkPast.text,
        "level":dropdownLevel
      };
      final res = await Api.putAsync(
        endPoint: "${ApiPath.curdDiary}/$id",
        req: data,
      );
      if (res['status'] == "SUCCESS") {
        return ;
      } else {
        // Xử lý lỗi
        print('Fail: ${res.statusCode}');
        print(res.data);
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
