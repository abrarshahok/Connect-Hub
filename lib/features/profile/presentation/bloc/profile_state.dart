part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

abstract class ProfileActionState extends ProfileState {}

final class ProfileInitial extends ProfileState {}

class ProfileFollowOrUnfollowSuccessActionState extends ProfileActionState {}

class ProfileFollowOrUnfollowFailedActionState extends ProfileActionState {}
