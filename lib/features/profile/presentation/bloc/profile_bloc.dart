import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connecthub/repos/profile_repo.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileFollowOrUnfollowButtonClickedEvent>(
        profileFollowOrUnfollowButtonClickedEvent);
  }

  FutureOr<void> profileFollowOrUnfollowButtonClickedEvent(
    ProfileFollowOrUnfollowButtonClickedEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final isDone = await ProfileRepo.followOrUnfollow(
      followers: event.followers,
      userId: event.userId,
    );
    if (isDone) {
      emit(ProfileFollowOrUnfollowSuccessActionState());
    } else {
      emit(ProfileFollowOrUnfollowFailedActionState());
    }
  }
}
