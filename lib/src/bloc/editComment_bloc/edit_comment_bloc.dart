

import 'package:bloc/bloc.dart';
import 'package:diary/src/core/api.dart';
import 'package:diary/src/core/apiPath.dart';
import 'package:diary/src/models/comment_model.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'edit_comment_event.dart';
part 'edit_comment_state.dart';

class EditCommentBloc extends Bloc<EditCommentEvent, EditCommentState> {
  CommentModel? model;
  EditCommentBloc() : super(EditCommentInitial()) {
    on<EditCommentEvent>((event, emit) async {
      if (event is GetIdComment) {
        emit(EditCommentLoading());
        try {
          var res =
              await Api.getAsync(endPoint: '${ApiPath.comment}/${event.id}');
          if (res['status'] == "SUCCESS") {
         model = CommentModel.fromJson(res['data']);
         emit(EditCommentSuccess(model!));
          } else {
            emit(EditCommentFailure(er: "Not Data"));
          }
        } on DioException catch (e) {
          String failure = "You are not the owner of this comment";
          emit(EditCommentFailure(
            er: failure.toString(),
          ));
        } catch (e) {
          emit(EditCommentFailure(er: e.toString()));
        }
      }
    });
  }
}
