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
