part of 'get_comment_bloc.dart';

@immutable
abstract class GetCommentEvent {}

class GetIdCMTDiary extends GetCommentEvent{
  final int id;
  GetIdCMTDiary({required this.id});
}