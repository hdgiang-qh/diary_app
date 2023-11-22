part of 'get_comment_bloc.dart';

@immutable
abstract class GetCommentState {}

class GetCommentInitial extends GetCommentState {}

class GetCMTLoading extends GetCommentState{}

class GetCMTSuccess extends GetCommentState{
  final List<CommentModel> list;
  GetCMTSuccess(this.list);
}
class GetCMTSuccessV2 extends GetCommentState{
  final CommentModel listAllDiary;
  GetCMTSuccessV2(this.listAllDiary);
}

class GetCMTFailure extends GetCommentState{
  final String error;
  GetCMTFailure({required this.error});
}
