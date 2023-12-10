import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import '/repos/auth_repo.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthInitialEvent>(onAuthInitialEvent);
    on<AuthLoginFormSubmitedEvent>(onAuthLoginFormSubmitedEvent);
    on<AuthSignupFormSubmitedEvent>(onAuthSignupFormSubmitedEvent);
  }

  FutureOr<void> onAuthInitialEvent(
    AuthInitialEvent event,
    Emitter<AuthState> emit,
  ) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      emit(AuthUserAuthenticationSuccessState(user: currentUser));
    } else {
      emit(AuthUserAuthenticationFailedState());
    }
  }

  FutureOr<void> onAuthLoginFormSubmitedEvent(
    AuthLoginFormSubmitedEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthUserAuthenticatingState());
      final isLoginSuccess = await AuthRepo.signIn(
        email: event.email,
        password: event.password,
      );
      if (isLoginSuccess) {
        emit(AuthUserAuthenticationSuccessState(user: AuthRepo.user!));
      } else {
        emit(AuthUserAuthenticationFailedState());
      }
    } catch (_) {
      emit(AuthUserAuthenticationFailedState());
    }
  }

  FutureOr<void> onAuthSignupFormSubmitedEvent(
    AuthSignupFormSubmitedEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthUserAuthenticatingState());
      final isSignupSuccess = await AuthRepo.signUp(
        email: event.email,
        password: event.password,
        username: event.username,
        image: event.userImage,
      );
      if (isSignupSuccess) {
        emit(AuthUserAuthenticationSuccessState(user: AuthRepo.user!));
      } else {
        emit(AuthUserAuthenticationFailedState());
      }
    } catch (_) {
      emit(AuthUserAuthenticationFailedState());
    }
  }
}
