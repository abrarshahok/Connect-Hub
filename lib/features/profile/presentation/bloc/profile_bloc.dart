import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:connecthub/features/auth/data/auth_repository.dart';
import 'package:connecthub/features/profile/data/profile_repository.dart';
import 'package:meta/meta.dart';

import '../../../../firebase/upload_image.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileFollowOrUnfollowButtonClickedEvent>(
        profileFollowOrUnfollowButtonClickedEvent);
    on<ProfileNavigateToProfileSettingScreenButtonClickedEvent>(
        profileNavigateToProfileSettingScreenButtonClickedEvent);

    on<ProfileNewImageChoosenSuccessEvent>(profileNewImageChoosenSuccessEvent);
    on<ProfileSaveProfileChangesButtonClickedEvent>(
        profileSaveProfileChangesButtonClickedEvent);
  }

  FutureOr<void> profileFollowOrUnfollowButtonClickedEvent(
    ProfileFollowOrUnfollowButtonClickedEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final isDone = await ProfileRepository.followOrUnfollow(
      followers: event.followers,
      userId: event.userId,
    );
    if (isDone) {
      emit(ProfileFollowOrUnfollowSuccessActionState());
    } else {
      emit(ProfileFollowOrUnfollowFailedActionState());
    }
  }

  FutureOr<void> profileNavigateToProfileSettingScreenButtonClickedEvent(
    ProfileNavigateToProfileSettingScreenButtonClickedEvent event,
    Emitter<ProfileState> emit,
  ) {
    emit(ProfileNavigateToProfileSettingsScreenActionState());
  }

  FutureOr<void> profileNewImageChoosenSuccessEvent(
    ProfileNewImageChoosenSuccessEvent event,
    Emitter<ProfileState> emit,
  ) {
    emit(ProfileNewImageChoosenSuccessState(pickedImage: event.pickedImage));
  }

  FutureOr<void> profileSaveProfileChangesButtonClickedEvent(
    ProfileSaveProfileChangesButtonClickedEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileSavingProfileChangesActionState());
    final String profilePicUrl = event.profileImage == null
        ? AuthRepository.currentUser!.userImage
        : await uploadImage(
            postImage: event.profileImage!,
            postId: AuthRepository.currentUser!.uid,
            ref: 'user_profile_pictures',
          );
    final user = AuthRepository.currentUser!.copyWith(
      username: event.userName,
      userImage: profilePicUrl,
    );
    final isDone = await ProfileRepository.saveProfileChanges(user: user);
    if (isDone) {
      emit(ProfileSaveProfileChangesSuccesActionState());
    } else {
      emit(ProfileSaveProfileChangesFailedActionState());
    }
  }
}
