part of 'change_pass_bloc.dart';

@immutable
abstract class ChangePassState {}

class ChangePassInitial extends ChangePassState {}

class ChangePassLoading extends ChangePassState{}

class ChangePassSuccess extends ChangePassState{}

class ChangePassFailure extends ChangePassState{
  final String er;
  ChangePassFailure(this.er);
}