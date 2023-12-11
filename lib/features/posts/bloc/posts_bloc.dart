import 'dart:async';
import 'dart:io';
import 'package:instagram_clone_flutter/models/post_data_model.dart';
import 'package:instagram_clone_flutter/repos/auth_repo.dart';
import 'package:uuid/uuid.dart';

import 'package:bloc/bloc.dart';
import 'package:instagram_clone_flutter/repos/post_repo.dart';
import 'package:meta/meta.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  PostsBloc() : super(PostsInitial()) {
    on<PostChooseImageButtonClickedEvent>(postChooseImageButtonClickedEvent);
    on<PostImageChoosenSuccessEvent>(postImageChoosenSuccessEvent);
    on<PostUploadButtonClickedEvent>(postUploadButtonClickedEvent);
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

  FutureOr<void> postUploadButtonClickedEvent(
    PostUploadButtonClickedEvent event,
    Emitter<PostsState> emit,
  ) async {
    emit(PostUploadingActionState());
    bool isUploadingSuccess = await PostRepo.uploadPost(
      postId: const Uuid().v1(),
      userId: AuthRepo.user!.uid,
      username: AuthRepo.user!.username,
      caption: event.caption,
      postImage: event.image,
      postedOn: DateTime.now(),
      likes: [],
      comments: [],
    );
    if (isUploadingSuccess) {
      emit(PostUploadSuccessActionState());
    } else {
      emit(PostUploadFailedActionState());
    }
  }
}
