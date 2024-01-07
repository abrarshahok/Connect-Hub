part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class HomeAddPostButtonClickedEvent extends HomeEvent {}

class HomeNavigateToChatScreenButtonClickedEvent extends HomeEvent {}
