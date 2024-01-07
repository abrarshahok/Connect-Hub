import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeAddPostButtonClickedEvent>(homeAddPostButtonClickedEvent);
    on<HomeNavigateToChatScreenButtonClickedEvent>(
        homeNavigateToChatScreenButtonClickedEvent);
  }

  FutureOr<void> homeAddPostButtonClickedEvent(
    HomeAddPostButtonClickedEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(HomeShowAddPostOptionsModalSheetActionState());
  }

  FutureOr<void> homeNavigateToChatScreenButtonClickedEvent(
    HomeNavigateToChatScreenButtonClickedEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(HomeNavigateToChatScreenActionState());
  }
}
