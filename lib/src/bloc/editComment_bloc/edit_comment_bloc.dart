import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:diary/src/core/api.dart';
import 'package:diary/src/core/apiPath.dart';
import 'package:diary/src/models/comment_model.dart';
import 'package:meta/meta.dart';

part 'edit_comment_event.dart';
part 'edit_comment_state.dart';

class EditCommentBloc extends Bloc<EditCommentEvent, EditCommentState> {
  EditCommentBloc() : super(EditCommentInitial()) {
    on<EditCommentEvent>((event, emit) async {
      // if (event is GetIdComment) {
      //   emit(EditCommentLoading());
      //   try {
      //     var res =
      //         await Api.getAsync(endPoint: '${ApiPath.comment}/${event.id}');
      //     if (res['status'] == "SUCCESS") {
      //       list.clear();
      //       if ((res['data'] as List).isNotEmpty) {
      //         for (var json in res['data']) {
      //           list.add(CommentModel.fromJson(json));
      //           idCmt = list.fold(0, (intId, e) => e.id);
      //         }
      //         id = event.id;
      //         emit(GetCMTSuccess(list));
      //       } else {
      //         emit(GetCMTFailure(error: "Data Empty"));
      //       }
      //     } else {
      //       emit(GetCMTFailure(error: res['']));
      //     }
      //   } on DioException catch (e) {
      //     emit(GetCMTFailure(
      //       error: e.error.toString(),
      //     ));
      //   } catch (e) {
      //     emit(GetCMTFailure(error: e.toString()));
      //   }
      // }
    });
  }
}
