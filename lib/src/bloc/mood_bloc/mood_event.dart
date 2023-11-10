part of 'mood_bloc.dart';

@immutable
abstract class MoodEvent {}
class GetMood extends MoodEvent{
  GetMood();
}