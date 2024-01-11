part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class AuthInitialEvent extends AuthEvent {}

class AuthLoginFormSubmitedEvent extends AuthEvent {
  final String email;
  final String password;

  AuthLoginFormSubmitedEvent({
    required this.email,
    required this.password,
  });
}

class AuthSignupFormSubmitedEvent extends AuthEvent {
  final String email;
  final String username;
  final File? userImage;
  final String password;

  AuthSignupFormSubmitedEvent({
    required this.username,
    required this.email,
    required this.password,
    required this.userImage,
  });
}

class AuthLogoutButtonClickedEvent extends AuthEvent {}

class AuthNavigateToSavedPostScreenButtonClickedEvent extends AuthEvent {}
