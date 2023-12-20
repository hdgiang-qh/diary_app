part of 'diary_user_search_bloc.dart';

@immutable
abstract class DiaryUserSearchState {}

class DiaryUserSearchInitial extends DiaryUserSearchState {}

class DiaryUserSearchLoading extends DiaryUserSearchState{}

class DiaryUserSearchSuccess extends DiaryUserSearchState{
  final List<DiaryUserModel> list;
  DiaryUserSearchSuccess(this.list);
}

class DiaryUserSearchEmpty extends DiaryUserSearchState {}
class DiaryUserSearchFailure extends DiaryUserSearchState{
  final String error;
  DiaryUserSearchFailure({ required this.error});
}