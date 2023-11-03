part of 'sign_up_bloc.dart';

@immutable
abstract class SignUpState {}

class SignUpInitial extends SignUpState {}
class SignUpLoading extends SignUpState{}

class SignUpSuccess extends SignUpState{
  final List<UserInfor> listUser;
  SignUpSuccess(this.listUser);
}

class SignUpFailure extends SignUpState{
  final String error;
  SignUpFailure(this.error);
}