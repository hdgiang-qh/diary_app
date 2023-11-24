part of 'edit_comment_bloc.dart';

@immutable
abstract class EditCommentState {}

class EditCommentInitial extends EditCommentState {}

class EditCommentLoading extends EditCommentState{
}

class EditCommentSuccess extends EditCommentState{
  final CommentModel cmtM;
  EditCommentSuccess(this.cmtM);
}
class EditCommentFailure extends EditCommentState
{
  final String er;
  EditCommentFailure({required this.er});
}