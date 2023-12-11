import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
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
  ) async {
    final isUserFound = await AuthRepo.fetchCurrentUserInfo();
    if (isUserFound) {
      emit(AuthUserAuthenticationSuccessState());
    } else {
      emit(AuthUserAuthenticationFailedState());
    }
  }

  FutureOr<void> onAuthLoginFormSubmitedEvent(
    AuthLoginFormSubmitedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthButtonLoadingActionState());
    final isLoginSuccess = await AuthRepo.signIn(
      email: event.email,
      password: event.password,
    );
    if (isLoginSuccess) {
      emit(AuthUserAuthenticationSuccessState());
    } else {
      emit(AuthUserAuthenticationFailedState());
      emit(AuthLoginFailedActionState());
    }
  }

  FutureOr<void> onAuthSignupFormSubmitedEvent(
    AuthSignupFormSubmitedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthButtonLoadingActionState());
    final isSignupSuccess = await AuthRepo.signUp(
      email: event.email,
      password: event.password,
      username: event.username,
      image: event.userImage,
    );
    if (isSignupSuccess) {
      emit(AuthUserAuthenticationSuccessState());
    } else {
      emit(AuthUserAuthenticationFailedState());
      emit(AuthSignUpFailedActionState());
    }
  }
}
