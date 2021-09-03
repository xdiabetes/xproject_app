import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:xproject_app/core/user_context.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserContext userContext;

  AuthenticationBloc({
    required this.userContext,
  }) : super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStartedEvent) {
      String? userToken = await userContext.getUserToken();
      if (userToken != null) {
        yield AuthenticationAuthenticated();
      } else {
        yield AuthenticationUnauthenticated();
      }
    } else if (event is AuthenticationAuthenticate) {
      await userContext.setUserToken(event.token);
      yield AuthenticationAuthenticated();
    }
  }
}
