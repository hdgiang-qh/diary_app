part of 'diaryuser_bloc.dart';

@immutable
abstract class DiaryuserState {}

class DiaryUserInitial extends DiaryuserState {}

class DiaryUserLoading extends DiaryuserState{}

class DiarySearchSuccess extends DiaryuserState{
  final DiaryUserModel? model;
  DiarySearchSuccess(this.model);
}

class DiaryUserSuccess extends DiaryuserState{
  final List<DiaryUserModel> diaryUser;
  DiaryUserSuccess(this.diaryUser);
}
class DeleteDiarySuccess extends DiaryuserState{}

class DiaryUserEmpty extends DiaryuserState{}

class DiaryUserFailure extends DiaryuserState{
  final String error;
  DiaryUserFailure({required this.error});
}
