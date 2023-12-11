import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  PostsBloc() : super(PostsInitial()) {
    on<PostChooseImageButtonClickedEvent>(postChooseImageButtonClickedEvent);
    on<PostImageChoosenSuccessEvent>(postImageChoosenSuccessEvent);
  }

  FutureOr<void> postChooseImageButtonClickedEvent(
    PostChooseImageButtonClickedEvent event,
    Emitter<PostsState> emit,
  ) {
    emit(PostChooseUploadOptionActionState());
  }

  FutureOr<void> postImageChoosenSuccessEvent(
    PostImageChoosenSuccessEvent event,
    Emitter<PostsState> emit,
  ) {
    emit(PostChoosenSuccessState(choosenImage: event.pickedImage));
  }
}
