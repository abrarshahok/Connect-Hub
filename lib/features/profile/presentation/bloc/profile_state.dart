part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

abstract class ProfileActionState extends ProfileState {}

final class ProfileInitial extends ProfileState {}

class ProfileFollowOrUnfollowSuccessActionState extends ProfileActionState {}

class ProfileFollowOrUnfollowFailedActionState extends ProfileActionState {}

class ProfileNavigateToProfileSettingsScreenActionState
    extends ProfileActionState {}

class ProfileNewImageChoosenSuccessState extends ProfileState {
  final File? pickedImage;
  ProfileNewImageChoosenSuccessState({required this.pickedImage});
}

class ProfileSaveProfileChangesSuccesActionState extends ProfileActionState {}

class ProfileSaveProfileChangesFailedActionState extends ProfileActionState {}

class ProfileSavingProfileChangesActionState extends ProfileActionState {}
