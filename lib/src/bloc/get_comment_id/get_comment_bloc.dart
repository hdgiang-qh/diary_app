import 'package:bloc/bloc.dart';
import 'package:diary/src/core/api.dart';
import 'package:diary/src/core/apiPath.dart';
import 'package:diary/src/models/comment_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'get_comment_event.dart';

part 'get_comment_state.dart';

class GetCommentBloc extends Bloc<GetCommentEvent, GetCommentState> {
  CommentModel? model;
  List<CommentModel> list = [];
  GetCommentBloc(this.id) : super(GetCommentInitial());
  int id;
  TextEditingController commentController = TextEditingController();

  void getListComment(id)async{
    emit(GetCMTLoading());
          try {
            var res =
                await Api.getAsync(endPoint: '${ApiPath.comment}/list/$id');
            list.clear();
            if (res['status'] == "SUCCESS") {
              if ((res['data'] as List).isNotEmpty) {
                for (var json in res['data']) {
                  list.add(CommentModel.fromJson(json));
                }
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
  }


  void createComment() async{
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
      // Xử lý lỗi Dio
      print('Lỗi Dio: ${e.error}');
      return;
    } catch (e) {
      // Xử lý lỗi khác
      print('Lỗi: $e');
    }
  }
}
