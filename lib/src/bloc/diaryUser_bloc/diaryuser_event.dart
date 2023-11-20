part of 'diaryuser_bloc.dart';

@immutable
abstract class DiaryuserEvent {}

class GetIdDiary extends DiaryuserEvent {
  final int id;
  GetIdDiary({required this.id});

}