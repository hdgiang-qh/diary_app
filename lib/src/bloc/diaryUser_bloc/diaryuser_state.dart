part of 'diaryuser_bloc.dart';

@immutable
abstract class DiaryuserState {}

class DiaryUserInitial extends DiaryuserState {}

class DiaryUserLoading extends DiaryuserState{}

class DiaryUserSuccess extends DiaryuserState{
  final List<DiaryUserModel> diaryUser;
  DiaryUserSuccess(this.diaryUser);
}
class DeleteDiarySuccess extends DiaryuserState{}

class UpdateDiarySuccess extends DiaryuserState{}

class DiaryUserFailure extends DiaryuserState{
  final String error;
  DiaryUserFailure({required this.error});
}
