part of 'get_all_diary_bloc.dart';


abstract class GetAllDiaryEvent {}

class GetAllDiary extends GetAllDiaryEvent{
  final int id;
  GetAllDiary({required this.id});
}