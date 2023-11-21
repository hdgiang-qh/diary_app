part of 'detail_diary_bloc.dart';

@immutable
abstract class DetailDiaryEvent {}

class GetIdDiary extends DetailDiaryEvent {
  final int id;
  GetIdDiary({required this.id});
}

class GetDiary extends DetailDiaryEvent{
  GetDiary();
}