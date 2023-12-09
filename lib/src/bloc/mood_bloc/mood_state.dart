part of 'mood_bloc.dart';

@immutable
abstract class MoodState {}

class MoodInitial extends MoodState {}
class MoodLoading extends MoodState{}
class MoodSuccess extends MoodState{
  final List<MoodModel> listMood;
  MoodSuccess(this.listMood);
}
class MoodMusicSuccess extends MoodState{
  final List<MoodMusic> listMMusic;
  MoodMusicSuccess(this.listMMusic);
}
class MoodFailure extends MoodState{
  final String error;
  MoodFailure({required this.error});
}