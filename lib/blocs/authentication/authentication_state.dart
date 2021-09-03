part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
}

class AuthenticationInitial extends AuthenticationState {
  const AuthenticationInitial();

  @override
  List<Object?> get props => [];
}

class AuthenticationAuthenticated extends AuthenticationState {
  const AuthenticationAuthenticated();

  @override
  List<Object?> get props => [];
}

class AuthenticationUnauthenticated extends AuthenticationState {
  const AuthenticationUnauthenticated();

  @override
  List<Object?> get props => [];
}
