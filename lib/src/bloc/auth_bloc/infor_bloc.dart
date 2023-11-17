import 'package:bloc/bloc.dart';
import 'package:diary/src/core/api.dart';
import 'package:diary/src/core/apiPath.dart';
import 'package:diary/src/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'infor_event.dart';

part 'infor_state.dart';

class InforBloc extends Bloc<InforEvent, InforState> {
  InforBloc() : super(InforInitial());
  List<InforUser> inforUsers = [];
  InforUser? ifUser;

  void getInfor() async {
    emit(InforLoading());
    try {
      var res = await Api.getAsync(endPoint: ApiPath.inforUser);
      if (res['status'] == "SUCCESS") {
        if ((res['data'] as List).isNotEmpty) {
          for (var json in res['data']) {
            inforUsers.add(InforUser.fromJson(json));
          }
          emit(InforSuccess(inforUsers));
        } else {
          emit(InforFailure(error: 'Data Empty'));
        }
      } else {
        emit(InforFailure(error: res['nickName']));
      }
    } on DioException catch (e) {
      emit(InforFailure(error: e.error.toString()));
    } catch (e) {
      emit(InforFailure(error: e.toString()));
    }
  }
}
