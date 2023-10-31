abstract class LoginState {}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {
  final Map<String, dynamic> userData;

  LoginSuccessState(this.userData);
}

class LoginErrorState extends LoginState {
  final String error;

  LoginErrorState(this.error);
}