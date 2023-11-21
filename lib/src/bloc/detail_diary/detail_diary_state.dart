part of 'detail_diary_bloc.dart';

@immutable
abstract class DetailDiaryState {}

class DetailDiaryInitial extends DetailDiaryState {}

class DetailLoading extends DetailDiaryState {}

class DetailSuccess extends DetailDiaryState {
  final List<DiaryUserModel> diaryId;
  DetailSuccess(this.diaryId);
}
class DetailSuccessV2 extends DetailDiaryState{
  final DiaryUserModel diaryId;
  DetailSuccessV2(this.diaryId);
}

class DetailFailure extends DetailDiaryState {
  final String er;
  DetailFailure(this.er);
}
