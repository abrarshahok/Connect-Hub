part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class ProfileFollowOrUnfollowButtonClickedEvent extends ProfileEvent {
  final String userId;
  final List<dynamic> followers;

  ProfileFollowOrUnfollowButtonClickedEvent({
    required this.userId,
    required this.followers,
  });
}

class ProfileNavigateToProfileSettingScreenButtonClickedEvent
    extends ProfileEvent {}

class ProfileNewImageChoosenSuccessEvent extends ProfileEvent {
  final File pickedImage;
  ProfileNewImageChoosenSuccessEvent({required this.pickedImage});
}

class ProfileChangeProfileImageButtonClickedEvent extends ProfileEvent {}

class ProfileSaveProfileChangesButtonClickedEvent extends ProfileEvent {
  final String userName;
  final File? profileImage;

  ProfileSaveProfileChangesButtonClickedEvent({
    required this.userName,
    required this.profileImage,
  });
}
