part of 'login_bloc2.dart';

@immutable
abstract class LoginState2 {}

class LoginInitial extends LoginState2 {}

class InitialLoginState extends LoginState2 {}

class LoginError extends LoginState2 {
  final String errorMessage;

  LoginError({
    required this.errorMessage,
  });
}

class LoginWaiting extends LoginState2 {}

class LoginSuccess extends LoginState2 {
  final LoginModel loginData;
  LoginSuccess({required this.loginData});
}