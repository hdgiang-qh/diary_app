import 'package:bloc/bloc.dart';
import 'package:diary/src/core/api.dart';
import 'package:diary/src/core/apiPath.dart';
import 'package:diary/src/models/userDiary_model.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'detail_diary_event.dart';

part 'detail_diary_state.dart';

class DetailDiaryBloc extends Bloc<DetailDiaryEvent, DetailDiaryState> {
  DiaryUserModel? model;
  DetailDiaryBloc() : super(DetailDiaryInitial()) {
    on<DetailDiaryEvent>((event, emit) async {
      if (event is GetIdDiary) {
        emit(DetailLoading());
        try {
          var res =
              await Api.getAsync(endPoint: '${ApiPath.curdDiary}/${event.id}');
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
      }
    });
  }
}
