part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
}

class AppStartedEvent extends AuthenticationEvent {
  const AppStartedEvent();

  @override
  List<Object?> get props => [];
}

class AuthenticationAuthenticate extends AuthenticationEvent {
  final String token;

  const AuthenticationAuthenticate({
    required this.token
  });

  @override
  List<Object?> get props => [
    token,
  ];
}
