import 'package:bloc/bloc.dart';
import 'package:diary/src/core/api.dart';
import 'package:diary/src/core/apiPath.dart';
import 'package:diary/src/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'infor_event.dart';

part 'infor_state.dart';

class InforBloc extends Bloc<InforEvent, InforState> {
  List<InforUser> inforUsers = [];
  List<InforUserRole> inforUserRoles = [];
  InforUser? ifUser, ifUserv2;

  InforBloc() : super(InforInitial());

  void getInforUser() async {
    emit(InforLoading());
    try {
      var res = await Api.getAsync(endPoint: ApiPath.inforUser);
      if (res['status'] == "SUCCESS") {
        ifUser = InforUser.fromJson(res['data']);
        emit(InforSuccess2(ifUser!));
      } else {
        emit(InforFailure(error: res['']));
      }
    } on DioException catch (e) {
      emit(InforFailure(error: e.error.toString()));
    } catch (e) {
      emit(InforFailure(error: e.toString()));
    }
  }

  void getSearchId({int? id}) async {
    emit(InforLoading());
    try {
      var res = await Api.getAsync(
          endPoint: "${ApiPath.search}/$id");
      if (res['status'] == "SUCCESS") {
        ifUserv2 = InforUser.fromJson(res['data']);
        emit(InforSuccess3(ifUserv2!));
      } else {
        emit(InforFailure(error: ''));
      }
    } on DioException catch (e) {
      emit(InforFailure(error: e.error.toString()));
    } catch (e) {
      emit(InforFailure(error: e.toString()));
    }
  }
}
