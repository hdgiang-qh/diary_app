

import 'package:bloc/bloc.dart';
import 'package:diary/src/core/api.dart';
import 'package:diary/src/core/apiPath.dart';
import 'package:diary/src/core/const.dart';
import 'package:diary/src/models/getAll_diary_model.dart';
import 'package:dio/dio.dart';

part 'get_all_diary_event.dart';
part 'get_all_diary_state.dart';

class GetAllDiaryBloc extends Bloc<GetAllDiaryEvent, GetAllDiaryState> {
  GetAllDiaryBloc() : super(GetAllDiaryInitial());
  List<GetAllDiaryModel> getAllDiaries = [];

  void getAllDiary() async{
    emit(GetAllDiaryLoading());
    try{
      var res = await Api.getAsync(endPoint: ApiPath.getAllDiaryFeed);
      if(res['result'] == true){
        if((res['data'] as List).isNotEmpty){
          for(var json in res['data']){
            getAllDiaries.add(GetAllDiaryModel.fromJson(json));
          }
         emit(GetAllDiarySuccess(getAllDiaries));
        }
        else{
          emit(GetAllDiaryFailure(error :'Data Empty'));
        }
      } else {
        emit(GetAllDiaryFailure(error : res['change']));
      }
    } on DioException catch(e){
      emit(GetAllDiaryFailure(error : e.error.toString()));
    }
    catch(e){
      emit(GetAllDiaryFailure(error :e.toString()));
    }
  }

}
