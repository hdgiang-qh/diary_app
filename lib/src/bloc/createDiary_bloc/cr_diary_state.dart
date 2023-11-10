part of 'cr_diary_bloc.dart';

@immutable
abstract class CrDiaryState {}

class CrDiaryInitial extends CrDiaryState {}

class CrDiaryLoading extends CrDiaryState{}

class CrDiarySuccess extends CrDiaryState{
  final List<CreateDiaryModel> createDiary;
  CrDiarySuccess(this.createDiary);
}

class CrDiaryFailure extends CrDiaryState{
  final String er;
  CrDiaryFailure({required this.er});
}