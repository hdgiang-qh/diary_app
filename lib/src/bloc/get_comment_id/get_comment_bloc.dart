import 'package:bloc/bloc.dart';
import 'package:diary/src/core/api.dart';
import 'package:diary/src/core/apiPath.dart';
import 'package:diary/src/models/comment_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:meta/meta.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'get_comment_event.dart';

part 'get_comment_state.dart';

class GetCommentBloc extends Bloc<GetCommentEvent, GetCommentState> {
  CommentModel? model;
  List<CommentModel> list = [];
  GetCommentBloc(this.id) : super(GetCommentInitial());
  int id;
  TextEditingController commentController = TextEditingController();
  RefreshController refreshController = RefreshController();
  int? count;

  void getListComment(id) async {
    emit(GetCMTLoading());
    EasyLoading.show(dismissOnTap: true);
    try {
      var res = await Api.getAsync(endPoint: '${ApiPath.comment}/list/$id');
      list.clear();
      if (res['status'] == "SUCCESS") {
        if ((res['data'] as List).isNotEmpty) {
          for (var json in res['data']) {
            list.add(CommentModel.fromJson(json));
          }
          count = list.length;
          emit(GetCMTSuccess(list));
        } else {
          emit(GetCMTFailure(error: "Data Empty"));
        }
      } else {
        emit(GetCMTFailure(error: res['']));
      }
    } on DioException catch (e) {
      emit(GetCMTFailure(
        error: e.error.toString(),
      ));
    } catch (e) {
      emit(GetCMTFailure(error: e.toString()));
    }
    EasyLoading.dismiss();
  }

  void refreshPage() {
    list.clear();
    getListComment(id);
  }

  void createComment() async {
    emit(GetCMTLoading());
    try {
      Map<String, dynamic> data = {
        'comment': commentController.text,
        'diaryId': id,
      };
      final res = await Api.postAsync(
        endPoint: ApiPath.comment,
        req: data,
      );
      if (res['status'] == "SUCCESS") {
        getListComment(id);
      }
    } on DioException catch (e) {
      print('Lỗi Dio: ${e.error}');
      return;
    } catch (e) {
      print('Lỗi: $e');
    }
  }
}
