import 'package:bloc/bloc.dart';
import 'package:diary/src/core/api.dart';
import 'package:diary/src/core/apiPath.dart';
import 'package:diary/src/models/comment_model.dart';
import 'package:diary/src/models/getAll_diary_model.dart';
import 'package:diary/styles/text_styles.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'get_comment_event.dart';

part 'get_comment_state.dart';

class GetCommentBloc extends Bloc<GetCommentEvent, GetCommentState> {
  CommentModel? model;
  List<CommentModel> list = [];
  int? count;
  GetCommentBloc() : super(GetCommentInitial()) {
    on<GetCommentEvent>((event, emit) async {
      if (event is GetIdCMTDiary) {
        emit(GetCMTLoading());
        try {
          var res =
              await Api.getAsync(endPoint: '${ApiPath.comment}/${event.id}');
          if (res['status'] == "SUCCESS") {
            list.clear();
            if ((res['data'] as List).isNotEmpty) {
              for (var json in res['data']) {
                list.add(CommentModel.fromJson(json));
              }
              count = list.length;
              emit(GetCMTSuccess(list));
            } else {
              count = 0;
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
    });
  }
}
