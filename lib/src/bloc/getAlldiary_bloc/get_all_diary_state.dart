part of 'get_all_diary_bloc.dart';

abstract class GetAllDiaryState {}

class GetAllDiaryInitial extends GetAllDiaryState {}

class GetAllDiarySuccess extends GetAllDiaryState{
  final List<GetAllDiaryPublicModel> listGetAllDiary;
  GetAllDiarySuccess(this.listGetAllDiary);
}


class GetAllDiaryLoading extends GetAllDiaryState{}

class GetAllDiaryFailure extends GetAllDiaryState{
  final String error;
  GetAllDiaryFailure({ required this.error});
}