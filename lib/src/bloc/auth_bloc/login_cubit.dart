import 'package:bloc/bloc.dart';
import 'package:diary/src/bloc/cubit_state.dart';
import 'package:dio/dio.dart';

import '../../core/api.dart';
import '../../core/apiPath.dart';
import '../../core/share_pref/app_key.dart';
import '../../core/share_pref/share_pref.dart';
import '../bloc_status.dart';


class LoginCubit extends Cubit<CubitState>{
  LoginCubit() : super(CubitState());

  login({
    required String phone,
    required String pass,
    required bool remember,
  }) async {
    emit(state.copyWith(status: BlocStatus.loading));
    try {
      Map<String, dynamic> req = {
        "phone": phone,
        "password": pass,
      };
      var res = await Api.postAsync(endPoint: ApiPath.login, req: req);
      if (res['result'] == true) {
        await SharedPrefs.setInt(AppKey.userId, res['data']['user']['id']);
        await SharedPrefs.saveString(
            AppKey.userToken, res['data']['access_token']);
        if (remember) {
          await SharedPrefs.saveBool(AppKey.login, true);
        }
        emit(state.copyWith(status: BlocStatus.sucsess, msg: res['message']));
      } else {
        emit(state.copyWith(status: BlocStatus.loadfail, msg: res['message']));
      }
    } on DioException catch (e) {
      emit(state.copyWith(status: BlocStatus.loadfail, msg: e.error.toString()));
    } catch (e) {
      emit(state.copyWith(status: BlocStatus.loadfail, msg: e.toString()));
    }
  }
}