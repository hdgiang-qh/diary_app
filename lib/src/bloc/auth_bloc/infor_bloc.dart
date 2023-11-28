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
  InforUser? ifUser;
  InforBloc() : super(InforInitial()){
    on<InforEvent>(
        (event, emit) async {
          if(event is GetInforUser){
            emit(InforLoading());
            try {
              var res = await Api.getAsync(endPoint: ApiPath.inforUser);
              if (res['status'] == "SUCCESS") {
                ifUser = InforUser.fromJson(res['data']);
               // inforUsers.add(InforUser.fromJson(res['data']));
                emit(InforSuccess2(ifUser!));
              }
              else {
                emit(InforFailure(error: res['']));
              }
            } on DioException catch (e) {
              emit(InforFailure(error: e.error.toString()));
            } catch (e) {
              emit(InforFailure(error: e.toString()));
            }
          }
        }
    );
  }
}
