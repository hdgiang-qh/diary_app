import 'package:bloc/bloc.dart';
import 'package:diary/src/core/api.dart';
import 'package:diary/src/core/apiPath.dart';
import 'package:diary/src/models/podcast_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:meta/meta.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'podcast_event.dart';

part 'podcast_state.dart';

class PodcastBloc extends Bloc<PodcastEvent, PodcastState> {
  PodcastBloc() : super(PodcastInitial());
  List<PodcastModel> podcast = [];
  PodcastModel? model;
  RefreshController refreshController = RefreshController();
  int? id;
  String? epoint;

  void getListPodcast({bool? isRefresh = false}) async {
    emit(isRefresh == true ? PodcastLoading() : PodcastInitial());
    EasyLoading.show(dismissOnTap: true);
    try {
      if (id == null) {
        epoint = "${ApiPath.listSound}/all";
      } else {
        epoint = "${ApiPath.listMoodSound}?moodSound=$id";
      }
      var res = await Api.getAsync(endPoint: epoint.toString());
      if (res['status'] == "SUCCESS") {
        podcast.clear();
        EasyLoading.dismiss();
        if ((res['data'] as List).isNotEmpty) {
          for (var json in res['data']) {
            podcast.add(PodcastModel.fromJson(json));
          }
          emit(PodcastSuccess(podcast));
        } else {
          emit(PodcastFailure(error: 'Data Empty'));
        }
        refreshController.refreshCompleted();
      } else {
        emit(PodcastFailure(error: res['description']));
      }
    } on DioException catch (e) {
      emit(PodcastFailure(error: e.error.toString()));
    } catch (e) {
      emit(PodcastFailure(error: e.toString()));
    }
    EasyLoading.dismiss();
  }

  void getPodcastId({int? id}) async {
    emit(PodcastLoading());
    EasyLoading.show(dismissOnTap: true);
    try {
      var res = await Api.getAsync(endPoint: "${ApiPath.listSound}/$id");
      if (res['status'] == "SUCCESS") {
        model = PodcastModel.fromJson(res['data']);
        emit(PodcastSuccessV2(model!));
      } else {
        emit(PodcastFailure(error: res['description']));
      }
    } on DioException catch (e) {
      emit(PodcastFailure(error: e.error.toString()));
    } catch (e) {
      emit(PodcastFailure(error: e.toString()));
    }

    EasyLoading.dismiss();
  }
}
