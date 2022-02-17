part of 'login_bloc2.dart';

@immutable
abstract class LoginEvent2 {}

class Login2 extends LoginEvent2 {
  final String username;
  final String password;
  Login2({required this.username, required this.password});
}