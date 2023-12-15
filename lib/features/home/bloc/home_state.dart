part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeActionState extends HomeState {}

class HomeInitial extends HomeState {}

class HomeShowAddPostOptionsModalSheetActionState extends HomeActionState {}
