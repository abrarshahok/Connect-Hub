part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthActionState extends AuthState {}

class AuthInitial extends AuthState {}

class AuthLoginFormSubmitedState extends AuthState {}

class AuthSignupFormSubmitedState extends AuthState {}

class AuthUserAuthenticationSuccessState extends AuthState {}

class AuthUserAuthenticationFailedState extends AuthState {}

class AuthButtonLoadingActionState extends AuthActionState {}

class AuthSignUpFailedActionState extends AuthActionState {}

class AuthLoginFailedActionState extends AuthActionState {}
