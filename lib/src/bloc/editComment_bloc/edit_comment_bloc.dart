import 'package:bloc/bloc.dart';
import 'package:diary/src/core/api.dart';
import 'package:diary/src/core/apiPath.dart';
import 'package:diary/src/models/comment_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:meta/meta.dart';

part 'edit_comment_event.dart';

part 'edit_comment_state.dart';

class EditCommentBloc extends Bloc<EditCommentEvent, EditCommentState> {
  CommentModel? model;
  int id;

  EditCommentBloc(this.id) : super(EditCommentInitial());
  TextEditingController editCommentController = TextEditingController();

  void getComment(id) async {
    emit(EditCommentLoading());
    EasyLoading.show(dismissOnTap: true);
    try {
      var res = await Api.getAsync(endPoint: '${ApiPath.comment}/$id');
      if (res['status'] == "SUCCESS") {
        model = CommentModel.fromJson(res['data']);
        emit(EditCommentSuccess(model!));
      } else {
        emit(EditCommentFailure(er: res['']));
      }
    } on DioException catch (e) {
      emit(EditCommentFailure(
        er: "You are not owner",
      ));
    } catch (e) {
      emit(EditCommentFailure(er: e.toString()));
    }
    EasyLoading.dismiss();
  }

  void editComment(ids) async {
    emit(EditCommentLoading());
    try {
      Map<String, dynamic> data = {
        'comment': editCommentController.text,
        'diaryId': ids,
      };
      final res = await Api.putAsync(
        endPoint: "${ApiPath.comment}/$id",
        req: data,
      );
      if (res['status'] == "SUCCESS") {
        return;
      }
    } on DioException catch (e) {
      // Xử lý lỗi Dio
      print('Lỗi Dio: ${e.error}');
    } catch (e) {
      // Xử lý lỗi khác
      print('Lỗi: $e');
    }
  }

  void deleteComment() async {
    emit(EditCommentLoading());
    try {
      final res = await Api.deleteAsync(
        endPoint: "${ApiPath.comment}/$id",
      );
      if (res['status'] == "SUCCESS") {
        return;
      }
    } on DioException catch (e) {
      print('Lỗi Dio: ${e.error}');
    } catch (e) {
      // Xử lý lỗi khác
      print('Lỗi: $e');
    }
  }

  void deleteCommentAll(int? id) async {
    emit(EditCommentLoading());
    try {
      final res = await Api.deleteAsync(
        endPoint: "${ApiPath.comment}/$id",
      );
      if (res['status'] == "SUCCESS") {
        return;
      }
    } on DioException catch (e) {
      print('Lỗi Dio: ${e.error}');
    } catch (e) {
      // Xử lý lỗi khác
      print('Lỗi: $e');
    }
  }
}
