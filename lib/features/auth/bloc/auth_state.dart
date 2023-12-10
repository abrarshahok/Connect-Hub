part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthActionState extends AuthState {}

class AuthInitial extends AuthState {}

class AuthUserAuthenticatingState extends AuthState {}

class AuthLoginFormSubmitedState extends AuthState {}

class AuthSignupFormSubmitedState extends AuthState {}

class AuthUserAuthenticationSuccessState extends AuthState {
  final User user;
  AuthUserAuthenticationSuccessState({required this.user});
}

class AuthUserAuthenticationFailedState extends AuthState {}

class AuthUserNavigateToHomePageActionState extends AuthActionState {}
