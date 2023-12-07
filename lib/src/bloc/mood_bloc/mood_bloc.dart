import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:diary/src/core/api.dart';
import 'package:diary/src/core/apiPath.dart';
import 'package:diary/src/models/mood_model.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'mood_event.dart';
part 'mood_state.dart';

class MoodBloc extends Bloc<MoodEvent, MoodState> {
  MoodBloc() : super(MoodInitial()) ;
  List<MoodModel> mood= [];
  MoodModel? moodModel;


  void getMood() async{
    emit(MoodLoading());
    try{
      var res = await Api.getAsync(endPoint: ApiPath.moodStatus);
      if(res['status'] == "SUCCESS"){
        if((res['data'] as List).isNotEmpty){
          for(var json in res['data']){
            mood.add(MoodModel.fromJson(json));
          }
          emit(MoodSuccess(mood));
        }
        else{
          emit(MoodFailure(error :'Data Empty'));
        }
      } else {
        emit(MoodFailure(error : res['description']));
      }
    }
    on DioException catch(e){
      emit(MoodFailure(error : e.error.toString()));
    }
    catch(e){
      emit(MoodFailure(error: e.toString()));
    }
  }
}
