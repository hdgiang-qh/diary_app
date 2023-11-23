part of 'edit_comment_bloc.dart';

@immutable
abstract class EditCommentEvent {}

class GetIdComment extends EditCommentEvent{
  final int id;
  GetIdComment({required this.id});
}