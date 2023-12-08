import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:diary/src/core/api.dart';
import 'package:diary/src/core/apiPath.dart';
import 'package:diary/src/models/podcast_model.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'podcast_event.dart';
part 'podcast_state.dart';

class PodcastBloc extends Bloc<PodcastEvent, PodcastState> {
  PodcastBloc() : super(PodcastInitial()) ;
  List<PodcastModel> podcast = [];
  PodcastModel? model;
  bool loaded = false;
  bool playing = false;


  void getListPodcast() async {
    emit(PodcastLoading());
    try{
      var res = await Api.getAsync(endPoint: "${ApiPath.podcast}/all");
      if(res['status'] == "SUCCESS"){
        if((res['data'] as List).isNotEmpty){
          for(var json in res['data']){
            podcast.add(PodcastModel.fromJson(json));
          }
          emit(PodcastSuccess(podcast));
        }
        else{
          emit(PodcastFailure(error :'Data Empty'));
        }
      } else {
        emit(PodcastFailure(error : res['description']));
      }
    }
    on DioException catch(e){
      emit(PodcastFailure(error : e.error.toString()));
    }
    catch(e){
      emit(PodcastFailure(error: e.toString()));
    }
  }

  void getPodcastId({int? id}) async {
    emit(PodcastLoading());
    try{
      var res = await Api.getAsync(endPoint: "${ApiPath.podcast}/$id");
      if(res['status'] == "SUCCESS"){
        model = PodcastModel.fromJson(res['data']);
        emit(PodcastSuccessV2(model!));
      } else {
        emit(PodcastFailure(error : res['description']));
      }
    }
    on DioException catch(e){
      emit(PodcastFailure(error : e.error.toString()));
    }
    catch(e){
      emit(PodcastFailure(error: e.toString()));
    }
  }
}
