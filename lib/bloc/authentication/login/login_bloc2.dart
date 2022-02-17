import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:devkitflutter/model/integration/login_model.dart';
import 'package:devkitflutter/network/api_provider.dart';
import 'package:meta/meta.dart';

part 'login_event2.dart';
part 'login_state2.dart';

class LoginBloc2 extends Bloc<LoginEvent2, LoginState2> {
  LoginBloc2() : super(LoginInitial());

  @override
  Stream<LoginState2> mapEventToState(
    LoginEvent2 event,
  ) async* {
    if(event is Login2){
      yield* _loginImei(event.username, event.password, "");
    }
  }
}

Stream<LoginState2> _loginImei(String username, password, imei) async* {
  ApiProvider _apiProvider = ApiProvider();

  yield LoginWaiting();
  try {
    LoginModel data = await _apiProvider.loginImei(username, password, imei);
    yield LoginSuccess(loginData: data);
  } catch (ex){
    // if(ex != 'cancel'){
      print("ex: $ex");
      yield LoginError(errorMessage: ex.toString());
    //}
  }
}